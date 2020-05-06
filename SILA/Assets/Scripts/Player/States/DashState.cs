using UnityEngine;
using System.Collections;

public class DashState : FSMState
{
	Transform _playerTransform;
	Rigidbody _playerRb;
	PlayerControllerV2 _playerScript;
	Camera _camera;
	float _difAngle;
	float _moveSpeed;
	float _dashSpeed;
	float _dashDuration;
	float _speedStore;
	float _dashTimer;

	Vector3 dashDirection;
	Vector3 dashDir;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;

	public DashState(Rigidbody rb, PlayerControllerV2 player, Transform transform, Camera cam)
	{
		_playerTransform = transform;
		_playerRb = rb;
		_playerScript = player;
		_camera = cam;
		ID = StateID.Dash;
		_moveSpeed = player.moveSpeed;
		_dashSpeed = player.dashSpeed;
		_dashDuration = player.dashDuration;
		_speedStore = player._speedStore;
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

	public override void Reason()
	{
		if(_dashTimer > _dashDuration)
		{
			_playerRb.velocity = Vector3.zero;
			_playerScript.SetTransition(Transition.Basic);
		}
	}

	public override void Act()
	{
		_playerRb.velocity = dashDir;
		_dashTimer += Time.deltaTime;
	}

	public override void DoBeforeEntering()
	{
		_dashTimer = 0;
		Debug.Log("Je commence à dasher");
		GetCamSettings();
		Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
		dashDirection = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
		_difAngle = SignedAngle(_playerTransform.forward, dashDirection, Vector3.up);
		_playerTransform.Rotate(new Vector3(0f, _difAngle, 0f));

		dashDir = dashDirection.normalized * _dashSpeed;

		/*_moveSpeed = _speedStore * _dashSpeed;
		moveDirection += dashDir * _moveSpeed;
		moveDirection.y = 0;

		//animator.SetBool("Dash", false);
		_moveSpeed = _speedStore;

		_playerRb.velocity = moveDirection;*/
	}

	IEnumerator Dash(Vector3 dashDir)
	{
		for (float t = 0; t < 1; t += Time.deltaTime / _dashDuration)
		{
			yield return null;
		}
	}
}
