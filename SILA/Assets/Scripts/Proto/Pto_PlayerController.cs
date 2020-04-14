using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pto_PlayerController : MonoBehaviour
{
	public static event Action<CameraLockState> PlayerStateChanged;
	public static event Action PlayerIsGrounded;
	public static event Action PlayerIsNotGrounded;


	public float moveSpeed;
	float _speedStore;
	Rigidbody theRB;
	Collider collider;
	public LayerMask whatIsGround;
	float distToGround;
	bool _isGrounded;
	public float jumpForce;
	int _jumpCount;
	bool _firstJump;
	public Camera mainCamera;

	public float fallMultiplier = 2.5f;
	public float lowJumpMultiplier = 2f;

	bool _isDashing;
	bool _onStele;
	bool _chouetteEyes;
	bool _canInput;
	float _deadZone = 0.25f;
	float _difAngle;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;
	Vector3 moveInputR;

	Vector3 moveDirection;
	Vector3 dashDirection;
	private float _arrowAngle;
	public float gravityScale;
	bool _canQuit = true;

    private void Awake()
    {
        TimeSystem.StartedTransition += SwitchCanQuit;
        TimeSystem.EndedTransition += EndTransitionTime;
    }

    private void EndTransitionTime()
    {
        _canQuit = true;
    }

    private void SwitchCanQuit()
    {
        _canQuit = false;
    }

    void Start()
    {
		theRB = GetComponent<Rigidbody>();
		collider = GetComponent<CapsuleCollider>();
		_speedStore = moveSpeed;
		_jumpCount = 0;
		_firstJump = false;
		_canInput = true;
		_onStele = false;
		_chouetteEyes = false;
		_isDashing = false;
		distToGround = collider.bounds.extents.y;
	}

	public static float SignedAngle(Vector3 from, Vector3 to, Vector3 normal)
	{
		float angle = Vector3.Angle(from, to);
		float sign = Mathf.Sign(Vector3.Dot(normal, Vector3.Cross(from, to)));
		return (angle * sign);
	}   // return une difference entre 2 vector // angle in [0,180]

	void GetCamSettings()
	{
		cameraForward = mainCamera.transform.forward;
		cameraForward.y = 0;
		cameraRight = mainCamera.transform.right;
		cameraRight.y = 0;
		cameraUp = mainCamera.transform.up;
		cameraUp.y = 0;
	}   // set up les vector par rapport a ceux de la cam, utile pour le deplacement

	public bool IsGrounded()
	{
		if (Physics.Raycast(transform.position, -Vector3.up, distToGround + 0.1f, whatIsGround))
		{
			PlayerIsGrounded?.Invoke();
			return true;
		}
		PlayerIsNotGrounded?.Invoke();
		return false;
	}   //   return true si le player touche le sol
	private void Update()
	{
		_isGrounded = IsGrounded();

		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(transform.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(transform.position, Vector3.down, Color.red, 10);
			if(hitStele.transform.TryGetComponent(out Stele stele))
			{
				_canQuit = false;
				_onStele = true;
				_canInput = false;
				stele.Interact();
			}
			else if(!_chouetteEyes)
			{
				PlayerStateChanged?.Invoke(CameraLockState.Eyes);
				_chouetteEyes = true;

			}
		}
		if(_onStele && Input.GetButtonDown("B"))
		{
            PlayerStateChanged?.Invoke(CameraLockState.Idle);
            _canInput = true;
		}

		if(Input.GetButtonDown("Dash"))
		{
			Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
			dashDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
			_difAngle = SignedAngle(transform.forward, dashDirection , Vector3.up);
			transform.Rotate(new Vector3(0f, _difAngle, 0f));

			_isDashing = true;
			StartCoroutine(Dash());

		}
	}
	IEnumerator Dash()
	{
		yield return new WaitForSeconds(0.2f);
		_isDashing = false;
		moveSpeed = _speedStore;
	}
	void FixedUpdate()
    {
		if(_canInput)
		{
			if(!_isDashing)
			{

				Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
				if (stickInput.magnitude < _deadZone)                                                                    //     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
					stickInput = Vector2.zero;                                                                          //      INPUT = ZERO
				else                                                                                                    //
				{                                                                                                       //
					_difAngle = SignedAngle(transform.forward, new Vector3(moveDirection.x, 0f, moveDirection.z), Vector3.up);   //
					if (_difAngle > 4)                                                                                   //
					{                                                                                                   //      SINON
						transform.Rotate(new Vector3(0f, Mathf.Min(7f, _difAngle), 0f));                                 //      ROTATE LE PLAYER POUR 
					}                                                                                                   //      L'ALIGNER AVEC LA CAMERA 
					else if (_difAngle < -4)                                                                             //
					{                                                                                                   //
						transform.Rotate(new Vector3(0f, Mathf.Max(-7f, _difAngle), 0f));                                //
					}
				}

				Vector2 stickInputR = new Vector2(Input.GetAxis("HorizontalCamera"), Input.GetAxis("VerticalCamera"));
				if (stickInputR.magnitude < _deadZone)
					stickInputR = Vector2.zero;

				GetCamSettings(); // RECUPERE LES VECTEUR DE LA CAMERA

				if (_isGrounded)              // si le player est au sol
				{
					moveSpeed = _speedStore;
					
					//Duplayeralakamera
					moveDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);              //                      DIRECTION DU PLAYER EN FONCTION DE LA CAMERA
					moveDirection = moveDirection.normalized * (moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180));          //     SPEED  * (180 - X) / 180    //  calcule la speed en fonction de l'orientation par rapport au deplacement
					moveDirection.y = 0;                                                                             //     reset y vector a 0 pour eviter de plaquer le player au sol 

					moveInputR = (cameraRight * stickInputR.x) + (cameraForward * stickInputR.y);                //     stick droit pour deplacer le player en meme temps que el monde si il est grounded
					moveInputR = moveInputR.normalized * 5f;
		
					if (Input.GetButtonDown("Jump"))
					{
						Debug.Log("je jump");
						moveDirection.y = theRB.velocity.y * jumpForce;
						_jumpCount += 1;
						_firstJump = true;
					}
					else
					{
						_jumpCount = 0;
						_firstJump = false;
					}

					if(!_chouetteEyes)
						PlayerStateChanged?.Invoke(CameraLockState.Idle);
					else if(_chouetteEyes && Input.GetButtonDown("Jump") || _chouetteEyes && Input.GetAxis("Horizontal") != 0 || _chouetteEyes && Input.GetAxis("Vertical") != 0 || _chouetteEyes && Input.GetButtonDown("B"))
					{
						PlayerStateChanged?.Invoke(CameraLockState.Idle);

						_chouetteEyes = false;
					}
				}
				else
				{
					float yStore = moveDirection.y;
					moveDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
					moveDirection = moveDirection.normalized * (moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180));         // SPEED  * (180 - X) / 180
					moveDirection.y = yStore;
					moveDirection.y += Physics.gravity.y * gravityScale * Time.deltaTime;


					if (Input.GetButtonDown("Jump") && _jumpCount >= 1)
					{
						moveDirection.y = 0;
						gravityScale = 1f;
						moveSpeed = _speedStore / 2;
						_jumpCount += 1;
						_firstJump = false;
						PlayerStateChanged?.Invoke(CameraLockState.Flight);
					}
					else if (Input.GetButton("Jump") && jumpForce >= 1 && moveDirection.y < 0 && !_firstJump)
					{
						moveDirection.y = 0;
						gravityScale = 1f;
						moveSpeed = _speedStore / 2;
						PlayerStateChanged?.Invoke(CameraLockState.Flight);
					}
					else
					{
						gravityScale = 1f;
					}
				}
			}
			else
			{
				moveSpeed = _speedStore * 2;		
			}
		}

		theRB.velocity = moveDirection * moveSpeed;
	}
}
