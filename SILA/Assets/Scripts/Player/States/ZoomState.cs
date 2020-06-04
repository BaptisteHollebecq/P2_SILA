using UnityEngine;
using System;

public class ZoomState : FSMState
{
	public static event Action<CameraLockState> PlayerStateChanged;

	GameObject _player;
	PlayerControllerV2 _playerScript;
	Rigidbody _rb;
	Vector3 _moveDirection;

	public ZoomState(Rigidbody rigidbody, PlayerControllerV2 player, GameObject	playerGO)
	{
		ID = StateID.Zoom;
		_rb = rigidbody;
		_playerScript = player;
	}
	public override void Reason()
	{
		if (Input.GetAxis("Horizontal") != 0 || Input.GetAxis("Vertical") != 0 || Input.GetButtonDown("B") || Input.GetButtonDown("Y"))
			_playerScript.SetTransition(Transition.Basic);
		else if (Input.GetButtonDown("Jump"))
			_playerScript.SetTransition(Transition.Jumping);
	}

	public override void Act()
	{
		_rb.constraints = RigidbodyConstraints.FreezeAll;
	}

	public override void DoBeforeEntering()
	{
		_rb.velocity = Vector3.zero;
		_moveDirection = Vector3.zero;
		PlayerStateChanged?.Invoke(CameraLockState.Eyes);
	}

	public override void DoBeforeLeaving()
	{
		_rb.constraints = RigidbodyConstraints.FreezeRotation;
		PlayerStateChanged?.Invoke(CameraLockState.Idle);
	}
}
