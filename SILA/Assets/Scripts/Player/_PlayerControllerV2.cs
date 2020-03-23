using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum States
{
	NA,
	Grounded,
	Jumping,
	Dashing,
	Flying,
	OnStele,
	Zoom,
}
public class _PlayerControllerV2 : MonoBehaviour
{
	protected States states { get; private set; } = States.NA;

	protected void OnStateEnter()
	{
		switch (states)
		{
			case States.NA:
				break;

			case States.Dashing:
				break;

			case States.Flying:
				break;

			case States.Grounded:
				break;

			case States.Jumping:
				break;

			case States.OnStele:
				break;

			case States.Zoom:
				break;
		}

	}

}
