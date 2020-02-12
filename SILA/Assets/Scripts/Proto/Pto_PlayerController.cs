using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pto_PlayerController : MonoBehaviour
{
	public static event System.Action<CameraLockState> PlayerStateChanged;

	public float moveSpeed;
	float speedStore;
	//Rigidbody theRB;
	public float jumpForce;
	int jumpCount;
	bool firstJump;
	CharacterController controller;
	public Camera mainCamera;

	public float fallMultiplier = 2.5f;
	public float lowJumpMultiplier = 2f;

	bool _isDashing;
	bool onStele;
	bool chouetteEyes;
	bool canInput;
	float deadZone = 0.25f;
	float difAngle;
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
		//theRB = GetComponent<Rigidbody>();
		controller = GetComponent<CharacterController>();
		speedStore = moveSpeed;
		jumpCount = 0;
		firstJump = false;
		canInput = true;
		onStele = false;
		chouetteEyes = false;
		_isDashing = false;
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

	private void Update()
	{
		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(transform.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(transform.position, Vector3.down, Color.red, 10);
			if(hitStele.transform.TryGetComponent(out Stele stele))
			{
				_canQuit = false;
				onStele = true;
				canInput = false;
				stele.Interact();
			}
			else if(!chouetteEyes)
			{
				PlayerStateChanged?.Invoke(CameraLockState.Eyes);
				chouetteEyes = true;

			}
		}
		if(onStele && Input.GetButtonDown("B"))
		{
            PlayerStateChanged?.Invoke(CameraLockState.Idle);
            canInput = true;
		}

		if(Input.GetButtonDown("Dash"))
		{
			Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
			dashDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
			difAngle = SignedAngle(transform.forward, dashDirection , Vector3.up);
			transform.Rotate(new Vector3(0f, difAngle, 0f));

			_isDashing = true;
			StartCoroutine(Dash());

		}
	}
	IEnumerator Dash()
	{
		yield return new WaitForSeconds(0.2f);
		_isDashing = false;
		moveSpeed = speedStore;
	}
	void FixedUpdate()
    {
		if(canInput)
		{
			if(!_isDashing)
			{
				if (moveDirection.y < 0)
				{
					controller.Move(Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime);
					moveSpeed = speedStore * 0.5f;
				}
				else if (moveDirection.y > 0 && !Input.GetButton("Jump"))
				{
					controller.Move( Vector3.up * Physics.gravity.y * 1f * Time.deltaTime);
				}

				Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
				if (stickInput.magnitude < deadZone)                                                                    //     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
					stickInput = Vector2.zero;                                                                          //      INPUT = ZERO
				else                                                                                                    //
				{                                                                                                       //
					difAngle = SignedAngle(transform.forward, new Vector3(moveDirection.x, 0f, moveDirection.z), Vector3.up);   //
					if (difAngle > 4)                                                                                   //
					{                                                                                                   //      SINON
						transform.Rotate(new Vector3(0f, Mathf.Min(7f, difAngle), 0f));                                 //      ROTATE LE PLAYER POUR 
					}                                                                                                   //      L'ALIGNER AVEC LA CAMERA 
					else if (difAngle < -4)                                                                             //
					{                                                                                                   //
						transform.Rotate(new Vector3(0f, Mathf.Max(-7f, difAngle), 0f));                                //
					}
				}

				Vector2 stickInputR = new Vector2(Input.GetAxis("HorizontalCamera"), Input.GetAxis("VerticalCamera"));
				if (stickInputR.magnitude < deadZone)
					stickInputR = Vector2.zero;

				GetCamSettings(); // RECUPERE LES VECTEUR DE LA CAMERA

				if (controller.isGrounded)              // si le player est au sol
				{
					//Duplayeralakamera
					moveDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);              //                      DIRECTION DU PLAYER EN FONCTION DE LA CAMERA
					moveDirection = moveDirection.normalized * (moveSpeed * ((180 - Mathf.Abs(difAngle)) / 180));          //     SPEED  * (180 - X) / 180    //  calcule la speed en fonction de l'orientation par rapport au deplacement
					moveDirection.y = 0;                                                                             //     reset y vector a 0 pour eviter de plaquer le player au sol 

					moveInputR = (cameraRight * stickInputR.x) + (cameraForward * stickInputR.y);                //     stick droit pour deplacer le player en meme temps que el monde si il est grounded
					moveInputR = moveInputR.normalized * 5f;
		
					if (Input.GetButtonDown("Jump"))
					{
						moveDirection.y = jumpForce;
						jumpCount += 1;
						firstJump = true;
					}
					else
					{
						jumpCount = 0;
						firstJump = false;
					}

					moveSpeed = speedStore;
					if(!chouetteEyes)
						PlayerStateChanged?.Invoke(CameraLockState.Idle);
					else if(chouetteEyes && Input.GetButtonDown("Jump") || chouetteEyes && Input.GetAxis("Horizontal") != 0 || chouetteEyes && Input.GetAxis("Vertical") != 0 || chouetteEyes && Input.GetButtonDown("B"))
					{
						PlayerStateChanged?.Invoke(CameraLockState.Idle);

						chouetteEyes = false;
					}
				}
				
				else
				{
					float yStore = moveDirection.y;
					moveDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
					moveDirection = moveDirection.normalized * (moveSpeed * ((180 - Mathf.Abs(difAngle)) / 180));         // SPEED  * (180 - X) / 180
					moveDirection.y = yStore;


					if (Input.GetButtonDown("Jump") && jumpCount >= 1)
					{
						moveDirection.y = 0;
						gravityScale = 4f;
						moveSpeed = speedStore;
						jumpCount += 1;
						firstJump = false;
						PlayerStateChanged?.Invoke(CameraLockState.Flight);
					}
					else if (Input.GetButton("Jump") && jumpForce >= 1 && moveDirection.y < 0 && !firstJump)
					{
						moveDirection.y = 0;
						gravityScale = 4f;
						moveSpeed = speedStore;

						PlayerStateChanged?.Invoke(CameraLockState.Flight);
					}
					else
					{
						gravityScale = 5;
					}

				}
				moveDirection.y += (Physics.gravity.y * gravityScale * Time.deltaTime);
				controller.Move(moveDirection * Time.deltaTime);
			}
			else
			{

				moveSpeed = speedStore * 2;
				controller.Move(dashDirection * moveSpeed * Time.deltaTime);
			}
		}
	}
}
