using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class PlayerStates : MonoBehaviour
{
	protected States CurrentState = States.NA;

	protected enum States
	{
		NA,
		Jumping,
		Dashing,
		Flying,
		OnStele,
		Zoom,
	}

	protected abstract void OnStateEnter();
	protected abstract void OnStateExit();

	protected void UpdatePlayerState(States newPlayerState)
	{
		if (newPlayerState == CurrentState)
			return;
		OnStateExit();
		CurrentState = newPlayerState;
		OnStateEnter();
	}

}
