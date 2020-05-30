using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathState : FSMState
{
	PlayerControllerV2 playerScript;
	Transform playerTransform;
	Collider playerCol;
	LayerMask whatIsGround;
	float distToGround;

	public DeathState(GameObject player, Collider collider, LayerMask groundMask, PlayerControllerV2 script)
	{
		ID = StateID.Death;
		playerTransform = player.transform;
		playerCol = collider;
		whatIsGround = groundMask;
		playerScript = script;
	}
	public override void Reason()
	{
		
	}

	public override void Act()
	{

	}

	public override void DoBeforeEntering()
	{
		
	}

    public override void DoBeforeLeaving()
    {
        
    }
}
