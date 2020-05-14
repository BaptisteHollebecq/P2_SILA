using UnityEngine;


public class BasicState : FSMState
{
	PlayerControllerV2 _playerScript;
	Transform _transformPlayer;
	Rigidbody _rb;
	Collider _playerCollider;
	Animator _animator;
	LayerMask _whatIsGround;
	float _distToGround;

	float _moveSpeed;
	float _airSpeed;
	float _jumpForce;
	float _deadZone = 0.25f;
	float _difAngle;
	float _lowerJumpFall;
	float _gravityScale;
	float _jumpGravity;

	float _speedStore;
	Camera _camera;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;

	public BasicState(PlayerControllerV2 scriptPlayer, Transform player, Camera cam, Collider collider, LayerMask groundMask, Animator anim)
	{
		ID = StateID.Basic;
		_rb = scriptPlayer._playerRb;
		_playerScript = scriptPlayer;
		_transformPlayer = player;
		_playerCollider = collider;
		_camera = cam;
		_jumpForce = scriptPlayer.jumpForce;
		_moveSpeed = scriptPlayer.moveSpeed;
		_airSpeed = scriptPlayer.airSpeed;
		_whatIsGround = groundMask;
		_distToGround = _playerCollider.bounds.extents.y - 0.8f;
		_lowerJumpFall = scriptPlayer.lowerJumpFall;
		_gravityScale = scriptPlayer.gravityScale;
		_jumpGravity = scriptPlayer.jumpGravity;
		_animator = anim;

		_speedStore = _moveSpeed;
	}

	public static float SignedAngle(Vector3 from, Vector3 to, Vector3 normal)
	{
		float angle = Vector3.Angle(from, to);
		float sign = Mathf.Sign(Vector3.Dot(normal, Vector3.Cross(from, to)));
		return (angle * sign);
	}   // return une difference entre 2 vector // angle in [0,180]

	void GetCamSettings()
	{
		cameraForward = _camera.transform.forward;
		cameraForward.y = 0;
		cameraRight = _camera.transform.right;
		cameraRight.y = 0;
		cameraUp = _camera.transform.up;
		cameraUp.y = 0;
	}   // set up les vector par rapport a ceux de la cam, utile pour le deplacement

	public bool IsGrounded()
	{
		return Physics.Raycast(_transformPlayer.position, -Vector3.up, _distToGround + 0.12f, _whatIsGround);
	}

	public override void Reason()
	{
		if (Input.GetButtonDown("Dash"))
		{
			_playerScript.SetTransition(Transition.Dashing);
		}

		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(_transformPlayer.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(_transformPlayer.position, Vector3.down, Color.red, 10);
			if (hitStele.transform.TryGetComponent(out Stele stele))
			{
				stele.Interact();
				_playerScript.SetTransition(Transition.Stele);
			}
			else if (Physics.Raycast(_transformPlayer.position, -Vector3.up, _distToGround + 0.12f, _whatIsGround))
			{
					_playerScript.SetTransition(Transition.Zooming);
			}
		}

		if(!IsGrounded() && Input.GetButtonDown("Jump"))
		{
			_playerScript.SetTransition(Transition.Flying);
		}

	}

	public override void Act()
	{


		Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
		if (stickInput.magnitude < _deadZone)                                                                    //     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
			stickInput = Vector2.zero;                                                                          //      INPUT = ZERO
		else                                                                                                    //
		{                                                                                                       //
			_difAngle = SignedAngle(_transformPlayer.forward, new Vector3(moveDirection.x, 0f, moveDirection.z), Vector3.up);   //
			if (_difAngle > 4)                                                                                   //
			{                                                                                                   //      SINON
				_transformPlayer.Rotate(new Vector3(0f, Mathf.Min(7f, _difAngle), 0f));                                 //      ROTATE LE PLAYER POUR 
			}                                                                                                   //      L'ALIGNER AVEC LA CAMERA 
			else if (_difAngle < -4)                                                                             //
			{                                                                                                   //
				_transformPlayer.Rotate(new Vector3(0f, Mathf.Max(-7f, _difAngle), 0f));                                //
			}
		}

		Vector2 stickInputR = new Vector2(Input.GetAxis("HorizontalCamera"), Input.GetAxis("VerticalCamera"));
		if (stickInputR.magnitude < _deadZone)
			stickInputR = Vector2.zero;

		GetCamSettings();

		float _yStored = _rb.velocity.y;
		moveDirection = (cameraRight.normalized * stickInput.x) + (cameraForward.normalized * stickInput.y);
		moveDirection *= _moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = _yStored;
		/*moveDirection = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical")) * moveSpeed;*/

		if (!IsGrounded())
		{
			_moveSpeed = _airSpeed;

			moveDirection += Vector3.up * Physics.gravity.y * (_gravityScale - 1) * Time.deltaTime;
			if (Mathf.Abs(_rb.velocity.y) > 70)
				moveDirection.y = -71;

			if (moveDirection.y > 0 && !Input.GetButton("Jump") || moveDirection.y > 0 && !Input.GetButton("Jump"))
				moveDirection += Vector3.up * Physics.gravity.y * (_lowerJumpFall - 1) * Time.deltaTime;
		}
		else
		{
			_moveSpeed = _speedStore;
		}


		#region Jump
		if (Input.GetButtonDown("Jump") && IsGrounded())
		{
			//_animator.SetBool("Jump", true);
			Debug.Log("Je saute !");
			_rb.AddForce(Vector3.up * _jumpForce, ForceMode.Impulse);
			_gravityScale = _jumpGravity;
			//moveDirection.y = _jumpForce * Time.deltaTime;
		}
		else
			_animator.SetBool("Jump", false);

		/*if (!Physics.Raycast(_transformPlayer.position, -Vector3.up, jumpHigh, _whatIsGround))
			moveDirection.y = Mathf.Lerp(0, -_gravityScale, 0.5f);*/


		#endregion

			_rb.velocity = moveDirection;

		#region Animator
		if (IsGrounded())
		{
			_animator.SetBool("Grounded", true);
			_animator.SetBool("Fall", false);
		}	
		else
			_animator.SetBool("Grounded", false);

		if (moveDirection.z != 0 || moveDirection.x != 0)
		{
			_animator.SetBool("Idle", false);
			_animator.SetBool("Run", true);
		}
		else
		{
			_animator.SetBool("Run", false);
			_animator.SetBool("Idle", true);
		}
		
		if(_rb.velocity.y < 0)
			_animator.SetBool("Fall", true);
		else if(IsGrounded() && _animator.GetBool("Run") == true)
			_animator.SetBool("Fall", false);


		#endregion

		Debug.Log(_moveSpeed);
	}

	public override void DoBeforeEntering()
	{
		//Debug.Log("Je reviens en state basic");
	}

	public override void DoBeforeLeaving()
	{
		//Debug.Log("Je quitte l'état basique");
	}
}
