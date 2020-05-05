using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BasicState : FSMState
{
	PlayerControllerV2 playerScript;
	Transform transformPlayer;
	Rigidbody rb;
	Collider playerCollider;
	LayerMask whatIsGround;
	float distToGround;


	float moveSpeed;
	float _deadZone = 0.25f;
	float _difAngle;


	Camera camera;
	Vector3 moveDirection;
	Vector3 cameraForward;      // vector forward "normalisé" de la cam
	Vector3 cameraRight;        // vector right "normalisé" de la cam
	Vector3 cameraUp;

	public BasicState(Rigidbody rigidbody, PlayerControllerV2 scriptPlayer, Transform player, Camera cam, Collider collider, LayerMask groundMask)
	{
		ID = StateID.Basic;
		rb = rigidbody;
		playerScript = scriptPlayer;
		transformPlayer = player;
		camera = cam;

		moveSpeed = scriptPlayer.moveSpeed;
	}

	public static float SignedAngle(Vector3 from, Vector3 to, Vector3 normal)
	{
		float angle = Vector3.Angle(from, to);
		float sign = Mathf.Sign(Vector3.Dot(normal, Vector3.Cross(from, to)));
		return (angle * sign);
	}   // return une difference entre 2 vector // angle in [0,180]

	void GetCamSettings()
	{
		cameraForward = camera.transform.forward;
		cameraForward.y = 0;
		cameraRight = camera.transform.right;
		cameraRight.y = 0;
		cameraUp = camera.transform.up;
		cameraUp.y = 0;
	}   // set up les vector par rapport a ceux de la cam, utile pour le deplacement

	public override void Reason()
	{
		if (Input.GetButtonDown("Dash"))
		{
			playerScript.SetTransition(Transition.Dashing);
		}

		if (Input.GetButtonDown("Jump"))
		{
			playerScript.SetTransition(Transition.Jumping);
		}

		if (Input.GetButtonDown("Y"))
		{
			RaycastHit hitStele;
			Physics.Raycast(transformPlayer.position, Vector3.down, out hitStele, 10);
			Debug.DrawRay(transformPlayer.position, Vector3.down, Color.red, 10);
			if (hitStele.transform.TryGetComponent(out Stele stele))
			{
				playerScript.SetTransition(Transition.Stele);
			}
			else if (Physics.Raycast(transformPlayer.position, -Vector3.up, distToGround + 0.12f, whatIsGround))
			{
					playerScript.SetTransition(Transition.Basic);
			}

				//PlayerStateChanged?.Invoke(CameraLockState.Eyes);

		}

		if (rb.velocity.y < -2)
			playerScript.SetTransition(Transition.Falling);
	}

	public override void Act()
	{
		Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
		if (stickInput.magnitude < _deadZone)                                                                    //     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
			stickInput = Vector2.zero;                                                                          //      INPUT = ZERO
		else                                                                                                    //
		{                                                                                                       //
			_difAngle = SignedAngle(transformPlayer.forward, new Vector3(moveDirection.x, 0f, moveDirection.z), Vector3.up);   //
			if (_difAngle > 4)                                                                                   //
			{                                                                                                   //      SINON
				transformPlayer.Rotate(new Vector3(0f, Mathf.Min(7f, _difAngle), 0f));                                 //      ROTATE LE PLAYER POUR 
			}                                                                                                   //      L'ALIGNER AVEC LA CAMERA 
			else if (_difAngle < -4)                                                                             //
			{                                                                                                   //
				transformPlayer.Rotate(new Vector3(0f, Mathf.Max(-7f, _difAngle), 0f));                                //
			}
		}

		Vector2 stickInputR = new Vector2(Input.GetAxis("HorizontalCamera"), Input.GetAxis("VerticalCamera"));
		if (stickInputR.magnitude < _deadZone)
			stickInputR = Vector2.zero;

		GetCamSettings();

		float yStored = rb.velocity.y;
		moveDirection = (cameraRight.normalized * stickInput.x) + (cameraForward.normalized * stickInput.y);
		moveDirection *= moveSpeed * ((180 - Mathf.Abs(_difAngle)) / 180);
		moveDirection.y = yStored;
		/*moveDirection = new Vector3(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical")) * moveSpeed;*/

		rb.velocity = moveDirection;

		Debug.Log(rb.velocity.y);
	}

	public override void DoBeforeEntering()
	{
		//Debug.Log("Je reviens en state basic");
	}

	public override void DoBeforeLeaving()
	{
		//Debug.Log("Je quitte l'état basique");
	}
}
