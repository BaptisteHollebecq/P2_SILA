using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpState : FSMState
{
	float _jumpForce;
	Rigidbody _rigidbody;
	PlayerControllerV2 _playerScript;

	public JumpState(PlayerControllerV2 player, Rigidbody playerRb)
	{
		ID = StateID.Jump;
		_jumpForce = player.jumpForce;
		_rigidbody = playerRb;
		_playerScript = player;
	}
	public override void Reason()
	{
	}

	public override void Act()
	{
		/*Debug.Log(ID);*/
		_rigidbody.AddForce(Vector3.up * _jumpForce, ForceMode.Impulse);
		_playerScript.SetTransition(Transition.Basic);
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
