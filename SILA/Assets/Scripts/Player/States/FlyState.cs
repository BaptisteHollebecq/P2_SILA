using UnityEngine;
using System;

public class FlyState : FSMState
{
	public static event Action<CameraLockState> PlayerStateChanged;

	Rigidbody _rb;
	float _fallSpeed;
	PlayerControllerV2 _playerScript;
	Transform _transformPlayer;
	Transform _transformRotator;
	Rigidbody _rotatorRb;
	Collider _playerCollider;
	Animator _animator;
	LayerMask _whatIsGround;
	float _distToGround;

	float _airRotation;
	float _moveSpeed;
	float _speedStore;
	float _fallStore;
	float _deadZone = 0.25f;
	float _difAngle;
	bool _canAccelerate;
	Vector3 _flyAngle;
	float _difFlyAngle;

	float _refValue = 0.0f;

	Vector2 _stickInput;
	Camera _camera;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;
	public FlyState(Rigidbody rb, PlayerControllerV2 player, Transform transform, Camera cam, Collider collider, LayerMask layerMask, Animator anim, Transform rotator)
	{
		ID = StateID.Fly;
		_rb = rb;
		_fallSpeed = player.flyGravityScale;
		_transformPlayer = transform;
		_camera = cam;
		_playerScript = player;
		_moveSpeed = player.flySpeed;
		_playerCollider = collider;
		_distToGround = _playerCollider.bounds.extents.y - 0.8f;
		_whatIsGround = layerMask;
		_animator = anim;
		_speedStore = _moveSpeed;
		_fallStore = _fallSpeed;
		_airRotation = player.airRotation;
		_transformRotator = rotator;
	}

	public static float SignedAngle(Vector3 from, Vector3 to, Vector3 normal)
	{
		float angle = Vector3.Angle(from, to);
		float sign = Mathf.Sign(Vector3.Dot(normal, Vector3.Cross(from, to)));
		return (angle * sign);
	}   // return une difference entre 2 vector // angle in [0,180]

	public override void Reason()
	{
		if (Physics.Raycast(_transformPlayer.position, -Vector3.up, _distToGround + 0.12f, _whatIsGround) || Input.GetButtonUp("Jump"))
		{
			_playerScript.SetTransition(Transition.Basic);
		}

		if (_playerScript.canDash && Input.GetButtonDown("Dash"))
			_playerScript.SetTransition(Transition.Dashing);

		if (_playerScript.lifeManager.isDead)
		{
			_playerScript.SetTransition(Transition.Death);
		}
	}

	public override void Act()
	{
		_stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
		_flyAngle = _transformPlayer.forward - new Vector3(0, Input.GetAxis("Vertical") * 2, 0);
		Debug.DrawRay(_transformPlayer.position, _flyAngle, Color.blue);
		_difFlyAngle = SignedAngle(_transformPlayer.forward, _flyAngle, Vector3.right);

		if (_stickInput.magnitude < _deadZone)
		{
			_stickInput = Vector2.zero;
			_canAccelerate = true;
		}                                                                                                       //     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
		else                                                                                                    //
		{                                                                                                       //
			_difAngle = SignedAngle(_transformPlayer.forward, new Vector3(moveDirection.x, 0f, moveDirection.z), Vector3.up);   //
			if (_difAngle > 1)                                                                                  //
			{                                                                                                   //      SINON
				_transformPlayer.Rotate(new Vector3(0f, Mathf.Min(_difAngle, _airRotation * Time.deltaTime / 4), 0f));
			}                                                                                                //      L'ALIGNER AVEC LA CAMERA 
			else if (_difAngle < -1)                                                                         //
			{                                                                                                //
				_transformPlayer.Rotate(new Vector3(0f, Mathf.Max(_difAngle, -_airRotation * Time.deltaTime / 4), 0f));
			}
		}

		if (_stickInput != Vector2.zero)
			moveDirection = (cameraRight.normalized * _stickInput.x) + _transformPlayer.forward.normalized;
		else
			moveDirection = _transformPlayer.forward.normalized;

		moveDirection *= _moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = -_fallSpeed;

		if (Input.GetAxis("Vertical") > 0 &&  _canAccelerate)
		{
			//_transformRotator.localRotation = new Quaternion(3, 0, 0, 0);

			if (_moveSpeed >= 40)
				_moveSpeed = 50;
			else
				_moveSpeed = Mathf.SmoothDamp(_moveSpeed,((_moveSpeed * Mathf.Abs(_difFlyAngle / 5))), ref _refValue, 2f);

			if (_fallSpeed >= 20)
				_fallSpeed = 30;
			else
				_fallSpeed = Mathf.SmoothDamp(_fallSpeed, ((_fallSpeed * Mathf.Abs(_difFlyAngle / 5))), ref _refValue, 2f);
		}
		else
		{
			_moveSpeed = _speedStore;
			_fallSpeed = _fallStore;
		}


		GetCamSettings();

		Debug.Log(_fallSpeed);

		if (_stickInput.y > 0)
			_rb.velocity = _flyAngle.normalized * _moveSpeed;
		else
			_rb.velocity = moveDirection;
	}
	void GetCamSettings()
	{
		cameraForward = _camera.transform.forward;
		cameraForward.y = 0;
		cameraRight = _camera.transform.right;
		cameraRight.y = 0;
		cameraUp = _camera.transform.up;
		cameraUp.y = 0;
	}   // set up les vector par rapport a ceux de la cam, utile pour le deplacement


	public override void DoBeforeEntering()
	{
		_canAccelerate = false;
		_refValue = 0;

		_moveSpeed = _speedStore;
		_fallSpeed = _fallStore;

		_animator.SetBool("Jump", false);
		_animator.SetBool("Fall", false);
		_animator.SetBool("Fly", true);
		_rb.useGravity = false;
		_playerScript.sound.Play("Deploy");
		_playerScript.sound.Play("FallingCape");
		_playerScript.sound.Play("WindCape");

		PlayerStateChanged?.Invoke(CameraLockState.Flight);
	}

	public override void DoBeforeLeaving()
	{
		PlayerStateChanged?.Invoke(CameraLockState.Idle);
		_transformRotator.localRotation = new Quaternion(0, 0, 0, 0);
		_moveSpeed = _speedStore;
		_fallSpeed = _fallStore;

		_playerScript.sound.Stop("Deploy");
		_playerScript.sound.Stop("FallingCape");
		_playerScript.sound.Stop("WindCape");
		_animator.SetBool("Fly", false);
		_rb.useGravity = true;
	}
}
