using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class _PlayerControllerV2 : MonoBehaviour
{

	private States _currentState = States.NA;
	private States _previousState;

	private enum States
	{
		NA,
		Grounded,
		Jumping,
		Dashing,
		Flying,
		OnStele,
		Zoom,
	}

	protected void OnStateEnter()
	{
		switch (_currentState)
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

			case States.Grounded:
				Debug.Log("GROUNDED");
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

	private void Update()
	{
		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(transform.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(transform.position, Vector3.down, Color.red, 10);
			if (hitStele.transform.TryGetComponent(out Stele stele))
			{
				stele.Interact();
				_previousState = _currentState;
				_currentState = States.OnStele;
				OnStateEnter();
			}
			else
			{
				_previousState = _currentState;
				_currentState = States.Zoom;
				OnStateEnter();
			}
		}

		if(Input.GetButtonDown("A"))
		{
			_previousState = _currentState;
			_currentState = States.Jumping;
			OnStateEnter();
		}
	}

}
