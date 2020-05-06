using System;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class PlayerControllerV2 : MonoBehaviour
{ 

	[Header("Setup Manuel")]
	//public Animator animator;
	public GameObject player;
	public Camera camera;

	public Rigidbody _playerRb { get; private set; }

	Collider _collider;
	PlayerControllerV2 _scriptOnPlayer;
	FSMSystem _fsm;

	//public Collider c { get { return _collider; } }
	[SerializeField]
	StateID _currentStateID;

	[HideInInspector]
	public float _speedStore;

	[Header("Player")]
	public float moveSpeed;
	public float jumpForce;
	public float dashSpeed;
	public float dashDuration;
	public float gravityScale;
	public float flyGravityScale;
	public float higherJumpFall;
	public float lowerJumpFall;
	public LayerMask whatIsGround;

	public void SetTransition(Transition t) { _fsm.PerformTransition(t); }
	public void Start()
	{
		_playerRb = GetComponent<Rigidbody>();
		_scriptOnPlayer = GetComponent<PlayerControllerV2>();
		_collider = GetComponent<Collider>();
		_speedStore = moveSpeed;
		MakeFSM();
	}
	private void Update()
	{
		_fsm.CurrentState.Reason();
		_fsm.CurrentState.Act();

		_currentStateID = _fsm.CurrentID;
	}
	private void MakeFSM()
	{

		BasicState basicState = new BasicState(playerRb, scriptOnPlayer, player.transform, camera, collider, whatIsGround);
		basicState.AddTransition(Transition.Basic, StateID.Basic);
		basicState.AddTransition(Transition.Dashing, StateID.Dash);
		basicState.AddTransition(Transition.Jumping, StateID.Jump);
		basicState.AddTransition(Transition.Falling, StateID.Fall);
		basicState.AddTransition(Transition.Stele, StateID.OnStele);
		basicState.AddTransition(Transition.Zooming, StateID.Zoom);
		basicState.AddTransition(Transition.Flying, StateID.Fly);

		JumpState jumpState = new JumpState(_scriptOnPlayer, _playerRb);
		jumpState.AddTransition(Transition.Basic, StateID.Basic);
		jumpState.AddTransition(Transition.Dashing, StateID.Dash);
		jumpState.AddTransition(Transition.Falling, StateID.Fall);

		DashState dashState = new DashState(_playerRb, _scriptOnPlayer, player.transform, camera);
		dashState.AddTransition(Transition.Basic, StateID.Basic);
		dashState.AddTransition(Transition.Falling, StateID.Fall);

		FlyState flyState = new FlyState(_playerRb, _scriptOnPlayer, player.transform, camera, _collider, whatIsGround);
		flyState.AddTransition(Transition.Basic, StateID.Basic);
		flyState.AddTransition(Transition.Falling, StateID.Fall);
		flyState.AddTransition(Transition.Dashing, StateID.Dash);

		FallState fallState = new FallState(player, _collider, whatIsGround, _scriptOnPlayer);
		fallState.AddTransition(Transition.Basic, StateID.Basic);
		fallState.AddTransition(Transition.Dashing, StateID.Dash);
		fallState.AddTransition(Transition.Flying, StateID.Fly);

		OnSteleState steleState = new OnSteleState(_scriptOnPlayer, player);
		steleState.AddTransition(Transition.Basic, StateID.Basic);

		ZoomState zoomState = new ZoomState(_playerRb, _scriptOnPlayer);
		zoomState.AddTransition(Transition.Basic, StateID.Basic);
		zoomState.AddTransition(Transition.Jumping, StateID.Jump);


		_fsm = new FSMSystem();
		_fsm.AddState(basicState);
		_fsm.AddState(jumpState);
		_fsm.AddState(dashState);
		_fsm.AddState(flyState);
		_fsm.AddState(fallState);
		_fsm.AddState(steleState);
		_fsm.AddState(zoomState);
	}

}
