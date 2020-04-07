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
		

		fsm = new FSMSystem();
		fsm.AddState();
		fsm.AddState();
	}

}
