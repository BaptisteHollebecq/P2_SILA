using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpState : FSMState
{
	Rigidbody rigidbody;
	int jumpForce = 10;

	public JumpState()
	{
		ID = StateID.Jump;
	}
	public override void Reason(GameObject player)
	{
		if(Input.GetButtonDown("Jump"))
		{
			player.GetComponent<PlayerControllerV2>().SetTransition(Transition.Jumping);
		}

	}

	public override void Act(GameObject player)
	{
		rigidbody.GetComponent<Rigidbody>().AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
	}
}
