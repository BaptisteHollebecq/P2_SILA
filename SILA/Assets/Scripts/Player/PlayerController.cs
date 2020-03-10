using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
	public static event Action<CameraLockState> PlayerStateChanged;

	#region Variables

	[Header("Player")]
	public float moveSpeed;
	public float jumpForce;
	public float gravityScale;
	public int StompMtpl;
	public float fallMultiplier = 2.5f;
	public float lowJumpMultiplier = 2f;
	public LayerMask whatIsGround;
	public int maxGroundAngle;
	public float groundAngle;

	Rigidbody _rb;
	Collider _collid;
	Vector3 moveDirection;
	Vector3 dashDirection;
	float _speedStore;
	float _arrowAngle;
	bool _isDashing = false;
	bool _onStele = false;
	bool _chouetteEyes = false;
	bool _canInput = true;
	bool _canDash = true;
	bool _isResetting = false;
	int _jumpCount = 0;
	bool _firstJump = false;
	float distToGround;
	bool _isGrounded;
	float _deadZone = 0.25f;
	float _difAngle;
	bool _canQuit;
	bool _isFlying = false;
	bool _isJumping = false;
	bool _hardGrounded = false;

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
		distToGround = _collid.bounds.extents.y;
	}

	void Update()
	{
		if (_isDashing && _canDash)
			_canDash = false;

		_isGrounded = IsGrounded();

		CheckResets();
		MoveInput();
		Dash();
		Flight();
		Interact();
		StopInteract();
		Jump();
		AtkDown();
	}

	private void CheckResets()
	{
		if (_isGrounded)
		{
			_isJumping = false;
			if (!_canDash)
			{
				if (!_isResetting)
					StartCoroutine(ResetDash());
				else
				{
					_canDash = true;
					_isResetting = false;
				}
			}
		}

		if (!_isGrounded && !_isJumping && !_isFlying && !_isDashing && Physics.Raycast(transform.position, -Vector3.up, distToGround + 0.15f, whatIsGround))
			_hardGrounded = true;
		else
			_hardGrounded = false;
	}

	IEnumerator ResetDash()
	{
		yield return new WaitForSeconds(1f);
		_canDash = true;
	}

	private void AtkDown()
	{
		if(!_isGrounded && Input.GetButtonDown("B"))
		{
			moveDirection.y = Physics.gravity.y * gravityScale * StompMtpl;
		}
	}

	void MoveInput()
	{
		if (_rb.velocity.y > 10 && !_isJumping)
			_rb.velocity = Vector3.zero;

		if (!_canInput)
			return;

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

		float yStored = _rb.velocity.y;
		moveDirection = (cameraRight.normalized * stickInput.x) + (cameraForward.normalized * stickInput.y);
		moveDirection *= moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = yStored;

		#region Gravity
		if (_isGrounded && !_isDashing && !_isJumping)
		{
			gravityScale = 1;
			moveDirection.y = _rb.velocity.y;
			moveSpeed = _speedStore;
			_jumpCount = 0;
		}
		else if (_isDashing)
			moveDirection.y = 0;
		else if (_isFlying)
			moveDirection.y = -gravityScale;
		else
		{
			moveDirection.y = _rb.velocity.y * gravityScale;
			if (moveDirection.y < 0)
				moveDirection.y *= 1.1f;
			/*if (Mathf.Abs(moveDirection.y) > 100)
				moveDirection.y = -100;*/
		}

		if (_hardGrounded)
			moveDirection.y = Physics.gravity.y;


		if (moveDirection.y < 0 && !_isDashing || moveDirection.y < 0 && !_isFlying)
			moveDirection += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;
		else if (moveDirection.y > 0 && !Input.GetButton("Jump") && !_isDashing || moveDirection.y > 0 && !Input.GetButton("Jump") && !_isFlying)
			moveDirection += Vector3.up * Physics.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;

		#endregion


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

	public bool IsGrounded ()
	{
		if (Physics.Raycast (transform.position, -Vector3.up, distToGround + 0.12f, whatIsGround))
			return true;
		return false;
	}

	#region Dash
	void Dash()
	{
		if (_canDash && _canInput && Input.GetButtonDown("Dash") && !_isResetting)
		{
			_canDash = false;
			_canInput = false;
			if(!_isGrounded)
			{
				_isResetting = true;
			}
			//ajouter grav = 0
			Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
			dashDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
			_difAngle = SignedAngle(transform.forward, dashDirection, Vector3.up);
			transform.Rotate(new Vector3(0f, _difAngle, 0f));
			StartCoroutine(EndDash());
		}
		
	}
	IEnumerator EndDash()
	{
		_isDashing = true;
		if(_canDash)
			_canDash = false;
		Vector3 dashDir = dashDirection.normalized;
		moveSpeed = _speedStore * 3.5f;
		moveDirection += dashDir * moveSpeed;
		moveDirection.y = 0;
		yield return new WaitForSeconds(0.5f);
		_canInput = true;
		moveSpeed = _speedStore;
		_isDashing = false;
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
				_rb.velocity = Vector3.zero;
				moveDirection = Vector3.zero;
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
			_isJumping = true;
			_hardGrounded = false;
			moveDirection.y = jumpForce;
			_rb.velocity += new Vector3 (0, jumpForce);
			_jumpCount++;
			_firstJump = true;
		}
	}

	void Flight()
	{
		if (Input.GetButtonDown("Jump") && _jumpCount >= 1 && !_isGrounded)
		{
			if (!_isDashing)
				moveSpeed = _speedStore * 2;
			_hardGrounded = false;
			_jumpCount += 1;
			gravityScale = 3;
			_isFlying = true;
			_firstJump = false;
		}
		else if (Input.GetButton("Jump") && jumpForce >= 1 && moveDirection.y < 0 && !_firstJump && !_isGrounded)
		{
			if(!_isDashing)
				moveSpeed = _speedStore * 2;
			_hardGrounded = false;
			gravityScale = 3;
			_isFlying = true;
		}
		else
		{
			if(!_isDashing)
				moveSpeed = _speedStore;

			gravityScale = 1;
			_isFlying = false;
		}
	}

	void FixedUpdate()
	{
		if (groundAngle < maxGroundAngle)
			_rb.velocity = moveDirection;
		else
			return;
	}
}
