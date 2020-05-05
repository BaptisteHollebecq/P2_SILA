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
	public Camera camera;
	Rigidbody playerRb;
	Collider collider;
	PlayerControllerV2 scriptOnPlayer;
	FSMSystem fsm;

	[Header("Player")]
	public float moveSpeed;
	public float jumpForce;
	public LayerMask whatIsGround;

	public void SetTransition(Transition t) { fsm.PerformTransition(t); }
	public void Start()
	{
		playerRb = GetComponent<Rigidbody>();
		scriptOnPlayer = GetComponent<PlayerControllerV2>();
		collider = GetComponent<Collider>();
		MakeFSM();
	}
	private void Update()
	{
		fsm.CurrentState.Reason();
		fsm.CurrentState.Act();
	}
	private void MakeFSM()
	{
		BasicState basicState = new BasicState(playerRb, scriptOnPlayer, player.transform, camera);
		basicState.AddTransition(Transition.Basic, StateID.Basic);
		basicState.AddTransition(Transition.Dashing, StateID.Dash);
		basicState.AddTransition(Transition.Jumping, StateID.Jump);
		basicState.AddTransition(Transition.Falling, StateID.Fall);
		basicState.AddTransition(Transition.Stele, StateID.OnStele);
		basicState.AddTransition(Transition.Zooming, StateID.Eyes);

		JumpState jumpState = new JumpState(scriptOnPlayer, playerRb);
		jumpState.AddTransition(Transition.Jumping, StateID.Jump);
		jumpState.AddTransition(Transition.Basic, StateID.Basic);
		jumpState.AddTransition(Transition.Dashing, StateID.Dash);
		jumpState.AddTransition(Transition.Falling, StateID.Fall);

		DashState dashState = new DashState(playerRb, scriptOnPlayer);
		dashState.AddTransition(Transition.Dashing, StateID.Dash);
		dashState.AddTransition(Transition.Basic, StateID.Basic);
		dashState.AddTransition(Transition.Falling, StateID.Fall);

		FlyState flyState = new FlyState();
		flyState.AddTransition(Transition.Flying, StateID.Fly);
		flyState.AddTransition(Transition.Basic, StateID.Basic);
		flyState.AddTransition(Transition.Falling, StateID.Fall);
		flyState.AddTransition(Transition.Dashing, StateID.Dash);

		FallState fallState = new FallState(player, collider, whatIsGround, scriptOnPlayer);
		fallState.AddTransition(Transition.Falling, StateID.Fall);
		fallState.AddTransition(Transition.Basic, StateID.Basic);
		fallState.AddTransition(Transition.Dashing, StateID.Dash);
		fallState.AddTransition(Transition.Flying, StateID.Fly);

		OnSteleState steleState = new OnSteleState();
		steleState.AddTransition(Transition.Stele, StateID.OnStele);

		ZoomState zoomState = new ZoomState();
		zoomState.AddTransition(Transition.Zooming, StateID.Eyes);


		fsm = new FSMSystem();
		fsm.AddState(basicState);
		fsm.AddState(jumpState);
		fsm.AddState(dashState);
		fsm.AddState(flyState);
		fsm.AddState(fallState);
		fsm.AddState(steleState);
		fsm.AddState(zoomState);
	}

}
