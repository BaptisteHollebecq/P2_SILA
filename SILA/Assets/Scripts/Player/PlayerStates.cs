using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum Transition
{
	NullTransition = 0,
	Stopping = 1,
	Moving = 2,
	Jumping = 3,
	Dashing = 4,
	Falling = 5,
	Flying = 6,
	Stele = 7,
	Zooming = 8
}

public enum StateID
{
	NullStateID = 0,
	Idle = 1,
	Move = 2,
	Jump = 3,
	Dash = 4,
	Fall = 5,
	Fly = 6,
	OnStele = 7,
	Eyes = 8
}
public abstract class PlayerStates : MonoBehaviour
{
	
}

