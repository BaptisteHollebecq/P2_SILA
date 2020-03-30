using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class PlayerControllerV2 : PlayerStates
{
	#region Variables

	



	#endregion


	private void Update()
	{
		if(Input.GetButtonDown("A"))
		{
			UpdatePlayerState(States.Jumping);
		}

		if (Input.GetButtonDown("Y"))
		{
			UpdatePlayerState(States.Zoom);
		}

		if (Input.GetButtonDown("Dash"))
		{
			UpdatePlayerState(States.Dashing);
		}
	}

	protected override void OnStateEnter()
	{
		switch (CurrentState)
		{
			case States.NA:
				Debug.Log("NA");
				break;

			case States.Dashing:
				Debug.Log("DASH");
				break;

			case States.Flying:
				Debug.Log("FLY");
				break;

			case States.Jumping:
				Debug.Log("JUMP");
				break;

			case States.OnStele:
				Debug.Log("STELE");
				break;

			case States.Zoom:
				Debug.Log("ZOOM");
				break;
		}
	}
	protected override void OnStateExit()
	{
	}

	void FixedUpdate()
	{
		
	}
}
