using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PlayerControllerV2 : PlayerStates
{
	public static event Action<CameraLockState> PlayerStateChanged;

	[Header("Animator")]
	public Animator animator;

	#region Variables

	[Header("Player")]
	public float moveSpeed;
	public float jumpForce;
	public float gravityJump;
	public float gravityFlight;
	public float flightSpeed;
	public int StompMtpl;
	public float fallMultiplier = 2.5f;
	public float lowJumpMultiplier = 2f;
	public float dashMultiplier = 0;
	public float dashForce = 0;
	public LayerMask whatIsGround;
	public int maxGroundAngle;
	public float groundAngle;
	//[HideInInspector]
	public float gravityScale;

	Rigidbody _rb;
	Collider _collid;
	Vector3 moveDirection;
	Vector3 dashDirection;
	float _gravityStore;
	float distToGround;
	float _speedStore;
	float _arrowAngle;
	bool _canInput = true;
	bool _canDash = true;
	int _jumpCount = 0;
	bool _firstJump = false;
	float _deadZone = 0.25f;
	float _difAngle;
	bool _canQuit = true;
	bool _hardGrounded = false;
	bool _isResetting = false;


	[Header("Camera")]
	public Camera mainCamera;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;

	#endregion

	private void Awake()
	{
		TimeSystem.StartedTransition += SwitchCanQuit;
		CameraMaster.MovedToPivot += EndTransitionTime;
		TimeSystem.EndedTransition += EndTransitionTime;
	}
	private void Start()
	{
		_rb = GetComponent<Rigidbody>();
		_collid = GetComponent<CapsuleCollider>();
		_gravityStore = gravityScale;
		_speedStore = moveSpeed;
		distToGround = _collid.bounds.extents.y - 0.8f;
	}

	private void Update()
	{
		MoveInput();
		CheckResets();
		UpdatePlayerMovement();
		/*Flight();*/
		StopInteract();
	}

	void UpdatePlayerMovement()
	{
		if (Input.GetButtonDown("Jump") && CurrentState == States.Grounded)
		{
			UpdatePlayerState(States.Jumping);
			PreviousState = CurrentState;
			moveDirection.y = jumpForce;
			gravityScale = gravityJump;
			animator.SetBool("Grounded", false);
			animator.SetBool("Jump", true);
			_jumpCount++;
			_firstJump = true;
			_hardGrounded = false;
		}

		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(transform.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(transform.position, Vector3.down, Color.red, 10);
			if (hitStele.transform.TryGetComponent(out Stele stele))
			{
				UpdatePlayerState(States.OnStele);
				PreviousState = CurrentState;
				_rb.velocity = Vector3.zero;
				moveDirection = Vector3.zero;
				//_canQuit = false;
				_canInput = false;
				stele.Interact();
			}
			else if (CurrentState != States.Zoom && CurrentState == States.Grounded)
			{
				UpdatePlayerState(States.Zoom);
				PreviousState = CurrentState;
				PlayerStateChanged?.Invoke(CameraLockState.Eyes);
			}
		}

		if (_canDash && _canInput && Input.GetButtonDown("Dash") && !_isResetting)
		{
			Dash();
		}
	}
	#region Dash
	void Dash()
	{
		animator.SetBool("Dash", true);
		_canDash = false;
		_canInput = false;
		if (CurrentState != States.Grounded)
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
	IEnumerator EndDash()
	{
		UpdatePlayerState(States.Dashing);
		Vector3 dashDir = dashDirection.normalized;
		moveSpeed = _speedStore * 3.5f;
		moveDirection += dashDir * moveSpeed;
		moveDirection.y = 0;
		yield return new WaitForSeconds(dashMultiplier);
		animator.SetBool("Dash", false);
		_canInput = true;
		moveSpeed = _speedStore;
		CurrentState = PreviousState;
	}

	IEnumerator ResetDash()
	{
		Debug.Log("coucou");
		yield return new WaitForSeconds(1f);
		_canDash = true;
	}
	#endregion
	void StopInteract()
	{
		if (_canQuit && CurrentState == States.OnStele && Input.GetButtonDown("B"))
		{
			UpdatePlayerState(States.Grounded);
			CurrentState = States.Grounded;

			Debug.Log("t'es libre frr");
			PlayerStateChanged?.Invoke(CameraLockState.Idle);
			_canInput = true;
		}

		if (CurrentState == States.Zoom && Input.GetAxis("Horizontal") != 0 || CurrentState == States.Zoom && Input.GetAxis("Vertical") != 0 || CurrentState == States.Zoom && Input.GetButtonDown("B"))
		{
			UpdatePlayerState(States.Grounded);
			CurrentState = States.Grounded;

			PlayerStateChanged?.Invoke(CameraLockState.Idle);

		}
		else if(CurrentState == States.Zoom && Input.GetButtonDown("Jump"))
		{
			UpdatePlayerState(States.Jumping);
			PreviousState = CurrentState;

			PlayerStateChanged?.Invoke(CameraLockState.Idle);

		}
	}
	/*void Flight()
	{
		if (Input.GetButtonDown("Jump") && _jumpCount >= 1 && CurrentState != States.Grounded)
		{
			animator.SetBool("Fly", true);
			UpdatePlayerState(States.Flying);
			PreviousState = CurrentState;

			if (CurrentState != States.Dashing)
				moveSpeed = _speedStore * flightSpeed;
			_hardGrounded = false;
			_jumpCount += 1;
			gravityScale = gravityFlight;
			_firstJump = false;
		}
		else if (Input.GetButton("Jump") && _jumpCount >= 1 && moveDirection.y < 0 && !_firstJump && CurrentState != States.Grounded)
		{
			animator.SetBool("Fly", true);
			UpdatePlayerState(States.Flying);
			PreviousState = CurrentState;

			if (CurrentState != States.Dashing)
				moveSpeed = _speedStore * flightSpeed;
			_hardGrounded = false;
			gravityScale = gravityFlight;
		}
		else
		{
			animator.SetBool("Fly", false);
			if(PreviousState == States.Flying)
				UpdatePlayerState(States.Falling);

			if (CurrentState != States.Dashing)
				moveSpeed = _speedStore;
			if (CurrentState != States.Dashing)
				gravityScale = gravityJump;
		}
	}*/
	void MoveInput()
	{
		if (_rb.velocity.y > 10 && CurrentState != States.Jumping)
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

		#region Animator

		if (moveDirection.y < 5 && CurrentState != States.Flying && CurrentState != States.Grounded)
		{
			animator.SetBool("Fall", true);
		}

		if (moveDirection.x != 0 || moveDirection.z != 0)
		{
			animator.SetBool("Run", true);
			animator.SetBool("Idle", false);
			if (moveDirection.y > 10 && CurrentState == States.Jumping)
				animator.SetBool("Jump", true);
		}
		else
		{
			animator.SetBool("Run", false);
			animator.SetBool("Idle", true);
		}

		#endregion

		#region Gravity
		if (CurrentState == States.Grounded && CurrentState != States.Dashing && CurrentState != States.Jumping)
		{
			gravityScale = 1;
			moveDirection.y = _rb.velocity.y;
			moveSpeed = _speedStore;
			_jumpCount = 0;
		}
		else if (CurrentState == States.Dashing)
			moveDirection.y = 0;
		else if (CurrentState == States.Flying)
			moveDirection.y = -gravityScale;
		else
		{
			moveDirection.y = _rb.velocity.y - gravityScale;
			if (moveDirection.y < 0)
				moveDirection.y *= 1.1f;
			if (Mathf.Abs(moveDirection.y) > 70)
				moveDirection.y = -71;
		}

		/*if (_hardGrounded)
			moveDirection.y = Physics.gravity.y;*/

		if (moveDirection.y < 0 && CurrentState != States.Dashing || moveDirection.y < 0 && CurrentState != States.Flying)
			moveDirection += Vector3.up * Physics.gravity.y * (fallMultiplier - 1) * Time.deltaTime;
		else if (moveDirection.y > 0 && !Input.GetButton("Jump") && CurrentState != States.Dashing || moveDirection.y > 0 && !Input.GetButton("Jump") && CurrentState != States.Flying)
			moveDirection += Vector3.up * Physics.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;

		#endregion
	}
	void GetCamSettings()
	{
		cameraForward = mainCamera.transform.forward;
		cameraForward.y = 0;
		cameraRight = mainCamera.transform.right;
		cameraRight.y = 0;
		cameraUp = mainCamera.transform.up;
		cameraUp.y = 0;
	}   // set up les vector par rapport a ceux de la cam, utile pour le deplacement
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
	private void CheckResets()
	{
		if (IsGrounded())
		{
			UpdatePlayerState(States.Grounded);
			PreviousState = CurrentState;
			animator.SetBool("Grounded", true);
			animator.SetBool("Jump", false);
			animator.SetBool("Fly", false);
			animator.SetBool("Fall", false);
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
			else
				_isResetting = false;
		}
		else
			animator.SetBool("Grounded", false);

		/*if (!_isGrounded && !_isJumping && !_isFlying && !_isDashing && Physics.Raycast(transform.position, -Vector3.up, distToGround, whatIsGround))
			_hardGrounded = true;
		else
			_hardGrounded = false;*/
	}

	public bool IsGrounded()
	{
		if (Physics.Raycast(transform.position, -Vector3.up, distToGround + 0.12f, whatIsGround))
			return true;
		return false;
	}

	void FixedUpdate()
	{
		//Debug.Log(CurrentState);
		_rb.velocity = moveDirection;
	}
}
