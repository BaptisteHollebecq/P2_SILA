using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pto_CameraFollow : MonoBehaviour
{
	public GameObject cameraFollowObj;

	[Header("Camera Rotation Settings")]
	public float cameraMoveSpeed;
	public float clampAngle;
	public float inputSensitivity;

	float InputX;
	float InputZ;
	float rotY = 0.0f;
	float rotX = 0.0f;

	// Start is called before the first frame update
	void Start()
    {
		Vector3 rot = transform.localRotation.eulerAngles;
		rotY = rot.y;
		rotX = rot.x;
    }

    // Update is called once per frame
    void Update()
    {	
		//Setup the rotation of the sticks here
		InputX = Input.GetAxis("HorizontalCamera");
		InputZ = Input.GetAxis("VerticalCamera");

		rotY += InputX * inputSensitivity * Time.deltaTime;
		rotX += InputZ * inputSensitivity * Time.deltaTime;

		rotX = Mathf.Clamp(rotX, -clampAngle, clampAngle);

		Quaternion localRotation = Quaternion.Euler(rotX, rotY, 0f);
		transform.rotation = localRotation;
    }

	void LateUpdate()
	{
		CameraUpdater();
	}

	void CameraUpdater()
	{
		// set the target obj to follow
		Transform target = cameraFollowObj.transform;

		// move towards the GameObject that is the target
		float step = cameraMoveSpeed * Time.deltaTime;
		transform.position = Vector3.MoveTowards(transform.position, target.position, step);
	}


}
