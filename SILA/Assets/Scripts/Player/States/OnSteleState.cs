using System;
using UnityEngine;

public class OnSteleState : FSMState
{
	public static event Action<CameraLockState> PlayerStateChanged;

	PlayerControllerV2 _playerScript;
	Rigidbody _rb;
	Animator _animator;
	bool _canQuit;
	Vector3 _moveDirection;

	public OnSteleState(PlayerControllerV2 player, GameObject playerGO, Animator anim)
	{
		ID = StateID.OnStele;
		_rb = player._playerRb;
		_playerScript = player;
		_animator = anim;

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
			_animator.SetBool("Pry", false);
			_playerScript.SetTransition(Transition.Basic);
		}

	}

	public override void Act()
	{
		_rb.constraints = RigidbodyConstraints.FreezeAll;
	}

	public override void DoBeforeEntering()
	{
		_animator.SetBool("Pry", true);
		_rb.velocity = Vector3.zero;
		_moveDirection = Vector3.zero;
	}

	public override void DoBeforeLeaving()
	{
		_rb.constraints = RigidbodyConstraints.FreezeRotation;
		PlayerStateChanged?.Invoke(CameraLockState.Idle);
	}
}
