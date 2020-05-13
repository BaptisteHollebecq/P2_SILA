using UnityEngine;

public class FlyState : FSMState
{
	Rigidbody _rb;
	float _fallSpeed;
	PlayerControllerV2 _playerScript;
	Transform _transformPlayer;
	Collider _playerCollider;
	Animator _animator;
	LayerMask _whatIsGround;
	float _distToGround;


	float _moveSpeed;
	float _deadZone = 0.25f;
	float _difAngle;

	Camera camera;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;
	public FlyState(Rigidbody rb, PlayerControllerV2 player, Transform transform, Camera cam, Collider collider, LayerMask layerMask, Animator anim)
	{
		ID = StateID.Fly;
		_rb = rb;
		_fallSpeed = player.flyGravityScale;
		_transformPlayer = transform;
		camera = cam;
		_playerScript = player;
		_moveSpeed = player.flySpeed;
		_playerCollider = collider;
		_distToGround = _playerCollider.bounds.extents.y - 0.8f;
		_whatIsGround = layerMask;
		_animator = anim;
	}

	public static float SignedAngle(Vector3 from, Vector3 to, Vector3 normal)
	{
		float angle = Vector3.Angle(from, to);
		float sign = Mathf.Sign(Vector3.Dot(normal, Vector3.Cross(from, to)));
		return (angle * sign);
	}   // return une difference entre 2 vector // angle in [0,180]

	void GetCamSettings()
	{
		cameraForward = camera.transform.forward;
		cameraForward.y = 0;
		cameraRight = camera.transform.right;
		cameraRight.y = 0;
		cameraUp = camera.transform.up;
		cameraUp.y = 0;
	}   // set up les vector par rapport a ceux de la cam, utile pour le deplacement
	public override void Reason()
	{
		if(Physics.Raycast(_transformPlayer.position, -Vector3.up, _distToGround + 0.12f, _whatIsGround) || Input.GetButtonUp("Jump"))
		{
			_playerScript.SetTransition(Transition.Basic);
		}

		if (Input.GetButtonDown("Dash"))
			_playerScript.SetTransition(Transition.Dashing);
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

		moveDirection = (cameraRight.normalized * stickInput.x) + (cameraForward.normalized * stickInput.y);
		moveDirection *= _moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = -_fallSpeed;

		_rb.velocity = moveDirection;
	}

	public override void DoBeforeEntering()
	{
		_animator.SetBool("Jump", false);
		_animator.SetBool("Fall", false);
		_animator.SetBool("Fly", true);
		_rb.useGravity = false;
	}

	public override void DoBeforeLeaving()
	{
		_animator.SetBool("Fly", false);
		_rb.useGravity = true;
	}
}
