using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathState : FSMState
{
	PlayerControllerV2 playerScript;

	public DeathState(PlayerControllerV2 script)
	{
		ID = StateID.Death;
		playerScript = script;
	}
	public override void Reason()
	{
		if(!playerScript.lifeManager.isDead)
		{
			playerScript.SetTransition(Transition.Basic);
		}
	}

	public override void Act()
	{
		playerScript._playerRb.velocity = Vector3.zero;
	}

	public override void DoBeforeEntering()
	{
		
	}

    public override void DoBeforeLeaving()
    {
        
    }
}
