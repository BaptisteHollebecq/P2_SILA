using UnityEngine;
using System;

public class ZoomState : FSMState
{
	public static event Action<CameraLockState> PlayerStateChanged;

	PlayerControllerV2 _playerScript;
	Rigidbody _rb;
	Vector3 _moveDirection;

	public ZoomState(Rigidbody rigidbody, PlayerControllerV2 player)
	{
		ID = StateID.Zoom;
		_rb = rigidbody;
		_playerScript = player;
	}
	public override void Reason()
	{
		if (Input.GetAxis("Horizontal") != 0 || Input.GetAxis("Vertical") != 0 || Input.GetButtonDown("B"))
			_playerScript.SetTransition(Transition.Basic);
		else if (Input.GetButtonDown("Jump"))
			_playerScript.SetTransition(Transition.Jumping);
	}

	public override void Act()
	{

	}

	public override void DoBeforeEntering()
	{
		_rb.velocity = Vector3.zero;
		_moveDirection = Vector3.zero;
		PlayerStateChanged?.Invoke(CameraLockState.Eyes);
	}

	public override void DoBeforeLeaving()
	{
		PlayerStateChanged?.Invoke(CameraLockState.Idle);
	}
}
