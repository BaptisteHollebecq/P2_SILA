using UnityEngine;


public class BasicState : FSMState
{
	PlayerControllerV2 _playerScript;
	GameObject _player;
	Transform _transformPlayer;
	Rigidbody _rb;
	Collider _playerCollider;
	Animator _animator;
	SlopeDetector _slopeDetector;
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

	Vector2 stickInput;

	float _airRotation;
	float _groundRotation;

	Vector3 _refVectorDamp = Vector3.zero;
	float _refDamp = 0f;
	float _smoothTime;

	bool _hasJumped;
	bool _canJump;
	float _jumpTimer;
	float _maxJumpTimer;

    bool _canPlayGrounded = false;
    bool _isGrounded;
    bool _soundground;

	Camera _camera;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;

	public BasicState(GameObject playerGO, PlayerControllerV2 scriptPlayer, Transform player, Camera cam, Collider collider, LayerMask groundMask, Animator anim)
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
		_airRotation = scriptPlayer.airRotation;
		_groundRotation = scriptPlayer.groundedRotation;
		_animator = anim;
		_speedStore = _moveSpeed;
		_maxJumpTimer = scriptPlayer.jumpBufferTimer;
		_smoothTime = scriptPlayer.smoothTime;
		_player = playerGO;
		_slopeDetector = playerGO.GetComponent<SlopeDetector>();
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
		_isGrounded = Physics.Raycast(_transformPlayer.position, -Vector3.up, _distToGround + 0.12f, _whatIsGround);

		if (_slopeDetector.slopeAngles > _playerScript.maxAngle && _slopeDetector.slopeAngles != 90)
			_isGrounded = false;

		return _isGrounded;
	}

	public override void Reason()
	{
		if (_playerScript.canDash && Input.GetButtonDown("Dash"))
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

		if(!IsGrounded() && Input.GetButtonDown("Jump") && !_canJump)
		{
			_playerScript.SetTransition(Transition.Flying);
		}

		if (_playerScript.lifeManager.isDead)
		{
			_playerScript.SetTransition(Transition.Death);
		}

	}

	public override void Act()
	{
		
		stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));

		if (stickInput.magnitude < _deadZone)
		{
			stickInput = Vector2.zero;
			/*if (IsGrounded())
			{
				_rb.constraints = RigidbodyConstraints.FreezePositionY | RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;											//      INPUT = ZERO
			}
			else
			{
				_rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
			}*/
		}																										//     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
		else                                                                                                    //
		{                                                                                                       //
			_difAngle = SignedAngle(_transformPlayer.forward, new Vector3(moveDirection.x, 0f, moveDirection.z), Vector3.up);   //
			if (_difAngle > 4)                                                                                  //
			{                                                                                                   //      SINON
				if(IsGrounded())
					_transformPlayer.Rotate(new Vector3(0f, Mathf.Min(7f, _difAngle), 0f) * _groundRotation * Time.deltaTime);                  //      ROTATE LE PLAYER POUR 
				else if(!IsGrounded())
					_transformPlayer.Rotate(new Vector3(0f, Mathf.Min(7f, _difAngle), 0f) * _airRotation * Time.deltaTime);
			}                                                                                                   //      L'ALIGNER AVEC LA CAMERA 
			else if (_difAngle < 4)                                                                            //
			{                                                                                                   //
				if (IsGrounded())
					_transformPlayer.Rotate(new Vector3(0f, Mathf.Max(-7f, _difAngle), 0f) * _groundRotation * Time.deltaTime);                                //
				else if (!IsGrounded())
					_transformPlayer.Rotate(new Vector3(0f, Mathf.Max(-7f, _difAngle), 0f) * _airRotation * Time.deltaTime);
			}

			_rb.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationY | RigidbodyConstraints.FreezeRotationZ;
		}

		Vector2 stickInputR = new Vector2(Input.GetAxis("HorizontalCamera"), Input.GetAxis("VerticalCamera"));
		if (stickInputR.magnitude < _deadZone)
			stickInputR = Vector2.zero;

		GetCamSettings();

		_slopeDetector.checkForSlope = true;
		if (_slopeDetector.slopeAngles > _playerScript.maxAngle && _slopeDetector.slopeAngles != 90)
		{
			stickInput = Vector3.SmoothDamp(stickInput, Vector3.zero, ref _refVectorDamp, 0.01f);
		}

		float _yStored = _rb.velocity.y;
		moveDirection = (cameraRight.normalized * stickInput.x) + (cameraForward.normalized * stickInput.y);
		moveDirection *= _moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = _yStored;


		if (!IsGrounded())
		{
			_moveSpeed = _airSpeed;

			moveDirection += Vector3.up * Physics.gravity.y * (_gravityScale - 1) * Time.deltaTime;
		if (Mathf.Abs(_rb.velocity.y) > 70)
			moveDirection.y = -71;

		if (moveDirection.y > 0 && !Input.GetButton("Jump") || moveDirection.y > 0 && !Input.GetButton("Jump"))
			moveDirection += Vector3.up * Physics.gravity.y * (_lowerJumpFall - 1) * Time.deltaTime;

		if(!_hasJumped)
		{
			_canJump = true;
			_jumpTimer += Time.deltaTime;
		}

        if (_rb.velocity.y < -11)
            _canPlayGrounded = true;
        }
		else
		{
			_hasJumped = false;
			_jumpTimer = 0;
			_moveSpeed = _speedStore;

            /*if (_canPlayGrounded)
            {
                _playerScript.sound.Play("Grounded");
                _canPlayGrounded = false;
            }*/

        }

		if(_jumpTimer > _maxJumpTimer)
		{
			_hasJumped = true;
			_jumpTimer = 0;
			_canJump = false;
		}

		//Debug.Log(_jumpTimer);
		//Debug.DrawRay(_transformPlayer.position, _transformPlayer.forward, Color.red);
        #region Jump


		if (Input.GetButtonDown("Jump") && IsGrounded() && !_hasJumped || Input.GetButtonDown("Jump") && !IsGrounded() && _canJump)
		{
			_animator.SetBool("Jump", true);
			_canJump = false;
			_hasJumped = true;
			_rb.velocity = Vector3.zero;
			moveDirection.y = 0;
			//Debug.Log("Je saute !");
			_rb.AddForce(Vector3.up * _jumpForce, ForceMode.Impulse);
			_gravityScale = Mathf.SmoothDamp(_gravityScale, _jumpGravity, ref _refDamp, _smoothTime);

            _playerScript.sound.Play("Jump");
        }

        #endregion



		#region Animator

		if (stickInput.magnitude <= 0.5f)
		{
			_animator.SetBool("Walk", true);
			_animator.speed = ((stickInput.magnitude / 0.5f)) + 1;
		}
		else if (stickInput.magnitude > 0.5f)
		{
			_animator.SetBool("Walk", false);
			_animator.SetBool("Run", true);
			_animator.speed = stickInput.magnitude;
		}

		/*if (Mathf.Abs(Input.GetAxis("Horizontal")) >= 0.3f && Input.GetAxis("Vertical") > 0.5f || Mathf.Abs(Input.GetAxis("Horizontal")) >= 0.3f && Input.GetAxis("Vertical") < 0.5f)
			_animator.SetFloat("Blend", Input.GetAxis("Horizontal"));
		else
			_animator.SetFloat("Blend", 0f);*/
		/*else if (Input.GetAxis("Vertical") != 0 && Input.GetAxis("Horizontal") > 0.5f || Input.GetAxis("Vertical") != 0 && Input.GetAxis("Horizontal") < 0.5f)
			_animator.SetFloat("Blend", Mathf.SmoothDamp(0, Input.GetAxis("Vertical"), ref _refDamp, 0.01f));*/

		if (IsGrounded())
		{
			if (_rb.velocity.y < -0.2f)
			{
				_animator.SetBool("Jump", false);
				_animator.SetBool("Fall", true);
			}

			_animator.SetBool("Grounded", true);
			_animator.SetBool("Fall", false);
		}	
		else
		{
			if (_rb.velocity.y < -0.2f)
				_animator.SetBool("Fall", true);

			_animator.SetBool("Grounded", false);
		}

		if (moveDirection.z != 0 || moveDirection.x != 0)
		{
			_animator.SetBool("Idle", false);
			_animator.SetFloat("MoveSpeed", stickInput.magnitude);
		}
		else
		{
			_animator.SetFloat("MoveSpeed", 0);
			_animator.SetBool("Idle", true);
		}
		

		#endregion


		_rb.velocity = moveDirection;
	}

	public override void FixedAct()
	{
		
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
