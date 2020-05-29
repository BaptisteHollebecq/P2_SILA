using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FallState : FSMState
{
	PlayerControllerV2 playerScript;
	Transform playerTransform;
	Collider playerCol;
	LayerMask whatIsGround;
	float distToGround;

	public FallState(GameObject player, Collider collider, LayerMask groundMask, PlayerControllerV2 script)
	{
		ID = StateID.Fall;
		playerTransform = player.transform;
		playerCol = collider;
		whatIsGround = groundMask;
		playerScript = script;

		distToGround = playerCol.bounds.extents.y - 0.8f;
	}
	public override void Reason()
	{
		if (Physics.Raycast(playerTransform.position, -Vector3.up, distToGround + 0.12f, whatIsGround))
		{
			playerScript.SetTransition(Transition.Basic);
		}
	}

	public override void Act()
	{

	}

	public override void DoBeforeEntering()
	{
		Debug.Log("Je tombe");
	}

    public override void DoBeforeLeaving()
    {
        playerScript.sound.Play("Grounded");
    }
}
