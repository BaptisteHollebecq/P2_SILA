using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class PlayerStates : MonoBehaviour
{
	protected States CurrentState = States.Grounded;
	protected States PreviousState;

	protected enum States
	{
		Grounded,
		Jumping,
		Dashing,
		Flying,
		Falling,
		OnStele,
		Zoom,
	}

	protected void UpdatePlayerState(States newPlayerState)
	{
		if (newPlayerState == CurrentState)
			return;

		CurrentState = newPlayerState;

	}

}
