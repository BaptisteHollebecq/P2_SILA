using System;
using UnityEngine;

public class OnSteleState : FSMState
{
	public static event Action<CameraLockState> PlayerStateChanged;

	PlayerControllerV2 _playerScript;
	Rigidbody _rb;
	bool _canQuit;
	Vector3 _moveDirection;

	public OnSteleState(PlayerControllerV2 player, GameObject playerGO)
	{
		ID = StateID.OnStele;
		_rb = player._playerRb;
		_playerScript = player;

		TimeSystem.StartedTransition += SwitchCanQuit;
		CameraMaster.MovedToPivot += EndTransitionTime;
		TimeSystem.EndedTransition += EndTransitionTime;
	}

	void EndTransitionTime()
	{
		_canQuit = true;
	}

	void SwitchCanQuit()
	{
		_canQuit = false;
	}

	public override void Reason()
	{
		if(_canQuit && Input.GetButtonDown("B"))
		{
			_playerScript.SetTransition(Transition.Basic);
		}

	}

	public override void Act()
	{
	}

	public override void DoBeforeEntering()
	{
		_rb.velocity = Vector3.zero;
		_moveDirection = Vector3.zero;
	}

	public override void DoBeforeLeaving()
	{
		PlayerStateChanged?.Invoke(CameraLockState.Idle);
	}
}
