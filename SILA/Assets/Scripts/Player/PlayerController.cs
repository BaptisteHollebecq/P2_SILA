using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
	public static event Action<CameraLockState> PlayerStateChanged;
	public static event Action PlayerIsGrounded;
	public static event Action PlayerIsNotGrounded;

	#region Variables

	[Header("Player")]
	public float moveSpeed;
	public float jumpForce;
	public float gravityScale;
	public float fallMultiplier = 2.5f;
	public float lowJumpMultiplier = 2f;

	Rigidbody _rb;
	Collider _collid;
	Vector3 moveDirection;
	Vector3 dashDirection;
	float _speedStore;
	float _arrowAngle;
	bool _isDashing;
	bool _onStele;
	bool _chouetteEyes;
	bool _canInput;
	int _jumpCount;
	bool _firstJump;
	float distToGround;
	bool _isGrounded;
	float _deadZone = 0.25f;
	float _difAngle;
	bool _canQuit;
	bool _isFlying;

	[Header("Camera")]
	public Camera mainCamera;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;
	Vector3 moveInputR;
	#endregion

	void Awake()
	{
		TimeSystem.StartedTransition += SwitchCanQuit;
		TimeSystem.EndedTransition += EndTransitionTime;
	}

	void Start()
    {
		_rb = GetComponent<Rigidbody>();
		_collid = GetComponent<CapsuleCollider>();
		_speedStore = moveSpeed;
		_jumpCount = 0;
		_firstJump = false;
		_canInput = true;
		_onStele = false;
		_chouetteEyes = false;
		_isDashing = false;
		_isFlying = false;
		distToGround = _collid.bounds.extents.y;
	}

	void Update()
	{
		_isGrounded = IsGrounded();

		Dash();
		Interact();
		StopInteract();
		Jump();
		Flight();
		InputSettings();
		Ground();
		Move();
		AtkDown();
	}

	private void AtkDown()
	{
		if(!_isGrounded && Input.GetButtonDown("B"))
		{
			_rb.velocity = Vector3.down * moveSpeed * 2;
		}
	}

	void Ground()
	{
		moveDirection.y = _rb.velocity.y;

		if(!_isGrounded && !_isFlying)
		{
			if (!_isDashing)
				moveSpeed = _speedStore / 2;

			if (_rb.velocity.y < 0)
				moveDirection += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;
			else if (_rb.velocity.y > 0 && !Input.GetButton("Jump"))
				moveDirection += Vector3.up * Physics.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;
		}
		else
		{
			gravityScale = 2;
			if(!_isDashing)
				moveSpeed = _speedStore;
		}
	}

	void InputSettings()
	{
		if(_canInput)
		{
			bool hasInput = Input.GetKey (KeyCode.I);

			//_rb.constraints = RigidbodyConstraints.FreezeRotation;
			//_rb.constraints |= RigidbodyConstraints.FreezePositionZ;

			_rb.constraints = hasInput ?
				(RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ) :
				RigidbodyConstraints.FreezeRotation;

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

			GetCamSettings();
			moveDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
			moveDirection = moveDirection.normalized * (moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180));
		}
	}

	void EndTransitionTime()
	{
		_canQuit = true;
	}

	void SwitchCanQuit()
	{
		_canQuit = false;
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
		if (Physics.Raycast(transform.position, -Vector3.up, distToGround + 0.1f))
		{
			PlayerIsGrounded?.Invoke();
			return true;
		}
		PlayerIsNotGrounded?.Invoke();
		return false;
	}   //   return true si le player touche le sol

	#region Dash
	void Dash()
	{
		if (Input.GetButtonDown("Dash"))
		{
			Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
			dashDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
			_difAngle = SignedAngle(transform.forward, dashDirection, Vector3.up);
			transform.Rotate(new Vector3(0f, _difAngle, 0f));
			moveSpeed = _speedStore * 2;
			_isDashing = true;
			StartCoroutine(EndDash());
		}
	}
	IEnumerator EndDash()
	{
		yield return new WaitForSeconds(0.2f);
		_isDashing = false;
		moveSpeed = _speedStore;
	}
	#endregion

	void Interact()
	{
		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(transform.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(transform.position, Vector3.down, Color.red, 10);
			if (hitStele.transform.TryGetComponent(out Stele stele))
			{
				_canQuit = false;
				_onStele = true;
				_canInput = false;
				stele.Interact();
			}
			else if (!_chouetteEyes && _isGrounded)
			{
				PlayerStateChanged?.Invoke(CameraLockState.Eyes);
				_chouetteEyes = true;
			}
		}
	}

	void StopInteract()
	{
		if (_canQuit && _onStele && Input.GetButtonDown("B"))
		{
			PlayerStateChanged?.Invoke(CameraLockState.Idle);
			_onStele = false;
			_canInput = true;
		}

		if (_chouetteEyes && Input.GetButtonDown("Jump") || _chouetteEyes && Input.GetAxis("Horizontal") != 0 || _chouetteEyes && Input.GetAxis("Vertical") != 0 || _chouetteEyes && Input.GetButtonDown("B"))
		{
			PlayerStateChanged?.Invoke(CameraLockState.Idle);
			_chouetteEyes = false;
		}
	}

	void Jump()
	{
		if (_isGrounded && _canInput && Input.GetButtonDown("Jump"))
		{
			_rb.velocity =  Vector3.up * jumpForce;
			moveSpeed = _speedStore / 2;
			Debug.Log(moveSpeed);
			_jumpCount += 1;
			_firstJump = true;
		}
	}
	void Flight()
	{
		if (Input.GetButtonDown("Jump") && _jumpCount >= 1)
		{
			Debug.Log("je vole");
		}
		else if (Input.GetButton("Jump") && jumpForce >= 1 && moveDirection.y < 0 && !_firstJump)
		{
			
		}
		else
		{
			
		}
	}


	void Move()
	{
		_rb.velocity = moveDirection;
	}
}
