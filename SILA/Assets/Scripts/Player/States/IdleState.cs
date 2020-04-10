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
		/*if (Physics.Raycast(player.transform.position, -Vector3.up, 1.5f))
		{
			player.GetComponent<PlayerControllerV2>().SetTransition(Transition.Stopping);
		}*/

	}

	public override void Act(GameObject player, Rigidbody rigidbody)
	{
		Debug.Log(ID);
	}
}
