using UnityEngine;

public class DashState : FSMState
{
	Rigidbody playerRb;
	float dashForce = 10;
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
		playerRb.AddForce(Vector3.forward * dashForce, ForceMode.Impulse);
		player.GetComponent<PlayerControllerV2>().SetTransition(Transition.Stopping);
	}

	public override void DoBeforeEntering()
	{
		Debug.Log("Je commence à dasher");
	
	}
}
