﻿using System;
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
	Rigidbody playerRb;
	private FSMSystem fsm;

	public void SetTransition(Transition t) { fsm.PerformTransition(t); }
	public void Start()
	{
		playerRb = GetComponent<Rigidbody>();
		MakeFSM();
	}
	private void Update()
	{
		fsm.CurrentState.Reason(player, playerRb);
		fsm.CurrentState.Act(player, playerRb);
	}
	private void MakeFSM()
	{
		IdleState idleState = new IdleState();
		idleState.AddTransition(Transition.Stopping, StateID.Idle);
		idleState.AddTransition(Transition.Dashing, StateID.Dash);
		idleState.AddTransition(Transition.Jumping, StateID.Jump);
		idleState.AddTransition(Transition.Falling, StateID.Fall);
		idleState.AddTransition(Transition.Stele, StateID.OnStele);
		idleState.AddTransition(Transition.Zooming, StateID.Eyes);

		MovementState movementState = new MovementState();
		movementState.AddTransition(Transition.Moving, StateID.Move);

		JumpState jumpState = new JumpState();
		jumpState.AddTransition(Transition.Jumping, StateID.Jump);
		jumpState.AddTransition(Transition.Stopping, StateID.Idle);

		DashState dashState = new DashState(playerRb);
		dashState.AddTransition(Transition.Dashing, StateID.Dash);
		dashState.AddTransition(Transition.Stopping, StateID.Idle);
		dashState.AddTransition(Transition.Falling, StateID.Fall);

		FlyState flyState = new FlyState();
		flyState.AddTransition(Transition.Flying, StateID.Fly);
		flyState.AddTransition(Transition.Stopping, StateID.Idle);
		flyState.AddTransition(Transition.Flying, StateID.Fly);
			
		FallState fallState = new FallState();
		fallState.AddTransition(Transition.Falling, StateID.Fall);
		fallState.AddTransition(Transition.Stopping, StateID.Idle);

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
