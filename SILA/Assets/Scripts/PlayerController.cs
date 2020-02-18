using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Baptiste
{
	public class PlayerController : MonoBehaviour
	{
		#region Variables

		Rigidbody rb;
		Vector3 vel;

		float deadZone = 0.25f;
		float difAngle;

		[Header("Camera")]
		public Camera mainCamera;
		Vector3 cameraForward;
		Vector3 cameraRight;
		Vector3 cameraUp;

		[Header("Movement")]
		Vector3 moveInput;
		public float speed;
		float moveSpeed;
		public float speedMultiplier;
		float _xVelRef;
		float _zVelRef;
		public float gravityStrength;
		public float airFriction = 0.8f;

		[Header("Jump")]
		public float jumpForce;
		public bool canJump;
		float distToGround;
		public float fallMultiplier = 2.5f;
		public float lowJumpMultiplier = 2f;

		#endregion
		private void Start()
		{
			rb = GetComponent<Rigidbody>();
			distToGround = GetComponent<Collider>().bounds.extents.y;
		}

		private void Update()
		{
			/*if (GameState.CurrentState != GameState.State.Play)
				return;*/
			AdaptCamera();
			Jump();
			UpdateAbilities();
			isGrounded();
			Move();
		}
		public static float SignedAngle(Vector3 from, Vector3 to, Vector3 normal)
		{
			float angle = Vector3.Angle(from, to);
			float sign = Mathf.Sign(Vector3.Dot(normal, Vector3.Cross(from, to)));
			return (angle * sign);
		}
		void AdaptCamera()
		{
			moveSpeed = speed;

			Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
			if (stickInput.magnitude < deadZone)                                                                            //     SI LE JOUEUR NE TOUCHE PAS AU JOYSTICK   
				stickInput = Vector2.zero;                                                                                  //      INPUT = ZERO
			else                                                                                                            //
			{                                                                                                               //
				difAngle = SignedAngle(transform.forward, new Vector3(moveInput.x, 0f, moveInput.z), Vector3.up);  //
				if (difAngle > 4)                                                                                           //
				{                                                                                                           //      SINON
					transform.Rotate(new Vector3(0f, Mathf.Min(7f, difAngle), 0f));                                         //      ROTATE LE PLAYER POUR 
				}                                                                                                           //      L'ALIGNER AVEC LA CAMERA 
				else if (difAngle < -4)                                                                                     //
				{                                                                                                           //
					transform.Rotate(new Vector3(0f, Mathf.Max(-7f, difAngle), 0f));                                        //
				}
			}

			GetCamSettings();

			moveInput = (cameraRight * stickInput.x) + (cameraForward * stickInput.y);
			moveInput = moveInput.normalized * (moveSpeed * ((180 - Mathf.Abs(difAngle)) / 180));
		}
		void Jump()
		{
			if (canJump && Input.GetButtonDown("Jump"))
			{
				canJump = false;
				moveInput.y += jumpForce;
			}

		}

		bool isGrounded()
		{
			if (Physics.Raycast(transform.position, Vector3.down, distToGround + 0.01f))
			{
				canJump = true;
				return true;
			}
			else
			{
				moveInput.y += (Physics.gravity.y * gravityStrength);
				canJump = false;
				return false;
			}
		}
		void Move()
		{
			rb.velocity = moveInput;
		}

		void UpdateAbilities()
		{
		}

		void GetCamSettings()
		{
			cameraForward = mainCamera.transform.forward;
			cameraForward.y = 0;
			cameraRight = mainCamera.transform.right;
			cameraRight.y = 0;
			cameraUp = mainCamera.transform.up;
			cameraUp.y = 0;
		}
	}
}
