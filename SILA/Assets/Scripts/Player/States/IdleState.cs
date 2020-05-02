using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : FSMState
{
	public IdleState()
	{
		ID = StateID.Idle;
	}
	public override void Reason(GameObject player, Rigidbody rigidbody)
	{
		if (Input.GetButtonDown("Dash"))
		{
			player.GetComponent<PlayerControllerV2>().SetTransition(Transition.Dashing);
		}

		if (Input.GetButtonDown("Jump"))
		{
			player.GetComponent<PlayerControllerV2>().SetTransition(Transition.Jumping);
		}
	}

	public override void Act(GameObject player, Rigidbody rigidbody)
	{

	}
}
