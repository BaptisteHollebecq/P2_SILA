using UnityEngine;

public class DashState : FSMState
{
	Rigidbody playerRb;
	PlayerControllerV2 playerScript;
	float dashForce = 10;
	public DashState(Rigidbody rb, PlayerControllerV2 player)
	{
		playerRb = rb;
		playerScript = player;
		ID = StateID.Dash;
	}
	public override void Reason()
	{
	
	}

	public override void Act()
	{
		playerRb.AddForce(Vector3.forward * dashForce, ForceMode.Impulse);
		//playerScript.SetTransition(Transition.Basic);
	}

	public override void DoBeforeEntering()
	{
		Debug.Log("Je commence à dasher");
	
	}
}
