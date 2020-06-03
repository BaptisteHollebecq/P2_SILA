using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum Transition
{
	NullTransition = 0,
	Basic = 1,
	Jumping = 2,
	Dashing = 3,
	Death = 4,
	Flying = 5,
	Stele = 6,
	Zooming = 7
}

public enum StateID
{
	NullStateID = 0,
	Basic = 1,
	Jump = 2,
	Dash = 3,
	Death = 4,
	Fly = 5,
	OnStele = 6,
	Zoom = 7
}
public abstract class PlayerStates : MonoBehaviour
{
}

