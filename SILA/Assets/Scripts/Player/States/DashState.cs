using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DashState : FSMState
{
	Rigidbody playerRb;
	public DashState(Rigidbody rb)
	{
		playerRb = rb;
		ID = StateID.Dash;
	}
	public override void Reason(GameObject player, Rigidbody rigidbody)
	{
	
	}

	public override void Act(GameObject player, Rigidbody rigidbody)
	{

	}

	public override void DoBeforeEntering()
	{
		Debug.Log("Je commence à dasher");
	
	}
}
