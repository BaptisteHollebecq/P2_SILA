using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerControllerV2 : MonoBehaviour
{
	public static event Action<CameraLockState> PlayerStateChanged;

	/*[Header("Animator")]
	public Animator animator;*/

	public GameObject player;
	private FSMSystem fsm;

	public void SetTransition(Transition t) { fsm.PerformTransition(t); }
	public void Start()
	{
		MakeFSM();
	}
	public void FixedUpdate()
	{
		fsm.CurrentState.Reason(player);
		fsm.CurrentState.Act(player);
	}
	private void MakeFSM()
	{
		IdleState idleState = new IdleState();
		idleState.AddTransition(Transition.Stopping, StateID.Idle);

		MovementState movementState = new MovementState();
		movementState.AddTransition(Transition.Moving, StateID.Move);

		JumpState jumpState = new JumpState();
		jumpState.AddTransition(Transition.Jumping, StateID.Jump);

		DashState dashState = new DashState();
		dashState.AddTransition(Transition.Dashing, StateID.Dash);

		FlyState flyState = new FlyState();
		flyState.AddTransition(Transition.Flying, StateID.Fly);

		FallState fallState = new FallState();
		fallState.AddTransition(Transition.Falling, StateID.Fall);

		OnSteleState steleState = new OnSteleState();
		steleState.AddTransition(Transition.Stele, StateID.OnStele);

		ZoomState zoomState = new ZoomState();
		zoomState.AddTransition(Transition.Zooming, StateID.Eyes);


		fsm = new FSMSystem();
		fsm.AddState(idleState);
		fsm.AddState(jumpState);
		fsm.AddState(movementState);
		fsm.AddState(dashState);
		fsm.AddState(flyState);
		fsm.AddState(fallState);
		fsm.AddState(steleState);
		fsm.AddState(zoomState);
	}

}
