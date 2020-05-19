using System;
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Rigidbody))]
public class PlayerControllerV2 : MonoBehaviour
{ 

	[Header("Setup Manuel")]
	public Animator animator;
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
	[HideInInspector]
	public bool _isGrounded;
	[HideInInspector]
	public bool _isOnMap;
	//[HideInInspector]
	public bool _canDash;
	//[HideInInspector]
	public float _dashTimer;

    [Header("Player")]
	public float moveSpeed;
	public float airSpeed;
	public float jumpForce;
	public float dashSpeed;
	public float dashDuration;
	public float dashReset;
	public float flySpeed;
	public float flyGravityScale;
	public float jumpGravity;
	public float gravityScale;
	public float lowerJumpFall;
	public float airRotation;
	public float groundedRotation;
	public LayerMask whatIsGround;

	float _distToGround;

	public void SetTransition(Transition t) { _fsm.PerformTransition(t); }
	public void Start()
	{
		_playerRb = GetComponent<Rigidbody>();
		_scriptOnPlayer = GetComponent<PlayerControllerV2>();
		_collider = GetComponent<Collider>();
		_speedStore = moveSpeed;
		_distToGround = _collider.bounds.extents.y - 0.8f;
		_dashTimer = dashReset + 1;
		MakeFSM();
	}
	private void Update()
	{
        if (!_isOnMap)
        {
            _fsm.CurrentState.Reason();
            _fsm.CurrentState.Act();
        }

		_currentStateID = _fsm.CurrentID;

		_isGrounded = IsGrounded();

		if(_dashTimer > dashReset && _isGrounded)
		{
			_canDash = true;
		}

		if(_canDash == false)
		{
			DashReset();
		}
	}

	public void DashReset()
	{
		_dashTimer += Time.deltaTime;
		if (_dashTimer > dashReset)
			_dashTimer = dashReset + 1;
	}

	public bool IsGrounded()
	{
		return Physics.Raycast(player.transform.position, -Vector3.up, _distToGround + 0.12f, whatIsGround);
	}

    public IEnumerator EndIsOnMap()
    {
        yield return new WaitForSeconds(0.05f);
        _isOnMap = false;
    }

	private void MakeFSM()
	{
		BasicState basicState = new BasicState(_scriptOnPlayer, player.transform, camera, _collider, whatIsGround, animator);
		basicState.AddTransition(Transition.Dashing, StateID.Dash);
		basicState.AddTransition(Transition.Falling, StateID.Fall);
		basicState.AddTransition(Transition.Stele, StateID.OnStele);
		basicState.AddTransition(Transition.Zooming, StateID.Zoom);
		basicState.AddTransition(Transition.Flying, StateID.Fly);

		DashState dashState = new DashState(_playerRb, _scriptOnPlayer, player.transform, camera, animator);
		dashState.AddTransition(Transition.Basic, StateID.Basic);
		dashState.AddTransition(Transition.Falling, StateID.Fall);
		dashState.AddTransition(Transition.Flying, StateID.Fly);

		FlyState flyState = new FlyState(_playerRb, _scriptOnPlayer, player.transform, camera, _collider, whatIsGround, animator);
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




		_fsm = new FSMSystem();
		_fsm.AddState(basicState);
		_fsm.AddState(dashState);
		_fsm.AddState(flyState);
		_fsm.AddState(fallState);
		_fsm.AddState(steleState);
		_fsm.AddState(zoomState);
	}

}
