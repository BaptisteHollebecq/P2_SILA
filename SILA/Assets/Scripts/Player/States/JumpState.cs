using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpState : FSMState
{
	float jumpForce;
	Rigidbody rigidbody;
	PlayerControllerV2 playerScript;

	public JumpState(PlayerControllerV2 player, Rigidbody playerRb)
	{
		ID = StateID.Jump;
		jumpForce = player.jumpForce;
		rigidbody = playerRb;
		playerScript = player;
	}
	public override void Reason()
	{
	}

	public override void Act()
	{
		/*Debug.Log(ID);*/
		rigidbody.AddForce(Vector3.up * jumpForce, ForceMode.Impulse);
		playerScript.SetTransition(Transition.Basic);
	}
	public override void DoBeforeEntering()
	{
		//Debug.Log("Je passe en jump");
	}
	public override void DoBeforeLeaving()
	{
		//Debug.Log("Je sors du jump");
	}

}
