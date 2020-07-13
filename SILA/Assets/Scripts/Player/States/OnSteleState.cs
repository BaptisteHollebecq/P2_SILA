using System;
using UnityEngine;

public class OnSteleState : FSMState
{
	public static event Action<CameraLockState> PlayerStateChanged;
    public static event Action SteleQuited;

	PlayerControllerV2 _playerScript;
	Rigidbody _rb;
	Animator _animator;
	bool _canQuit;
	Vector3 _moveDirection;

	float _animationTimer;
	float _pryOut = 1;
	bool _startTimer = false;

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
		if(_animationTimer > _pryOut)
			_playerScript.SetTransition(Transition.Basic);

	}

	public override void Act()
	{
		//Debug.Log(_animationTimer);
		_rb.constraints = RigidbodyConstraints.FreezeAll;

		if (_canQuit && Input.GetButtonDown("B"))
		{
			_animator.SetBool("Pry", false);
			_startTimer = true;
		}

		if(_startTimer)
			_animationTimer += Time.fixedDeltaTime;
	}

	public override void DoBeforeEntering()
	{
		_animator.SetBool("Pry", true);
		_rb.velocity = Vector3.zero;
		_moveDirection = Vector3.zero;
	}

	public override void DoBeforeLeaving()
	{

		_animator.SetBool("PryOut", false);
		_animationTimer = 0;
		_startTimer = false;
		_rb.constraints = RigidbodyConstraints.FreezeRotation;
		PlayerStateChanged?.Invoke(CameraLockState.Idle);
        SteleQuited?.Invoke();

    }
}
