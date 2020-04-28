using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DashState : FSMState
{
	public DashState()
	{
		ID = StateID.Dash;
	}
	public override void Reason(GameObject player, Rigidbody rigidbody)
	{
		if (Input.GetButtonDown("Dash"))
		{
			player.GetComponent<PlayerControllerV2>().SetTransition(Transition.Dashing);
		}
	}

	public override void Act(GameObject player, Rigidbody rigidbody)
	{
		Debug.Log("Je dash");
	}
}
