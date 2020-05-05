using UnityEngine;


public class BasicState : FSMState
{
	PlayerControllerV2 _playerScript;
	Transform _transformPlayer;
	Rigidbody _rb;
	Collider _playerCollider;
	LayerMask _whatIsGround;
	float _distToGround;

	float _moveSpeed;
	float _jumpForce;
	float _deadZone = 0.25f;
	float _difAngle;
	float _lowerJumpFall;
	float _higherJumpFall;


	Camera _camera;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;

	public BasicState(PlayerControllerV2 scriptPlayer, Transform player, Camera cam, Collider collider, LayerMask groundMask)
	{
		ID = StateID.Basic;
		_rb = scriptPlayer._playerRb;
		_playerScript = scriptPlayer;
		_transformPlayer = player;
		_playerCollider = collider;
		_camera = cam;
		_jumpForce = scriptPlayer.jumpForce;
		_moveSpeed = scriptPlayer.moveSpeed;
		_whatIsGround = groundMask;
		_distToGround = _playerCollider.bounds.extents.y - 0.8f;
		_lowerJumpFall = scriptPlayer.lowerJumpFall;
		_higherJumpFall = scriptPlayer.higherJumpFall;
		
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
		
		if (Input.GetButtonDown("Jump") && IsGrounded())
		{
			_rb.AddForce(Vector3.up * _jumpForce, ForceMode.Impulse);
		}

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

		float yStored = _rb.velocity.y;
		moveDirection = (cameraRight.normalized * stickInput.x) + (cameraForward.normalized * stickInput.y);
		moveDirection *= _moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = yStored;
		/*moveDirection = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical")) * moveSpeed;*/

		if (moveDirection.y < 0)
			moveDirection += Vector3.up * Physics.gravity.y * (_higherJumpFall - 1) * Time.deltaTime;
		else if (moveDirection.y > 0 && !Input.GetButton("Jump") || moveDirection.y > 0 && !Input.GetButton("Jump"))
			moveDirection += Vector3.up * Physics.gravity.y * (_lowerJumpFall - 1) * Time.deltaTime;


		_rb.velocity = moveDirection;

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
