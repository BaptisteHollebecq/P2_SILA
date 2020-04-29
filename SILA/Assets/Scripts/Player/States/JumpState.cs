using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpState : FSMState
{
	int jumpForce = 1;

	public JumpState()
	{
		ID = StateID.Jump;
	}
	public override void Reason(GameObject player, Rigidbody rigidbody)
	{
	}

	public override void Act(GameObject player,	Rigidbody rigidbody)
	{
		Debug.Log(ID);
		rigidbody.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
	}
}
