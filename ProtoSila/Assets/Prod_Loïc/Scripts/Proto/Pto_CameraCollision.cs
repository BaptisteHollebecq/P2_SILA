using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pto_CameraCollision : MonoBehaviour
{
	[Header("Settings")]
	public float minDistance;
	public float maxDistance;
	public float smooth;

	float distance;
	Vector3 dollyDir;

	void Awake()
	{
		dollyDir = transform.localPosition.normalized;
		distance = transform.localPosition.magnitude;
	}

    void Update()
    {
		Vector3 desiredCameraPos = transform.parent.TransformPoint(dollyDir * maxDistance);
		RaycastHit hit;

		if(Physics.Linecast(transform.parent.position, desiredCameraPos, out hit))
			distance = Mathf.Clamp(hit.distance * 0.87f, minDistance, maxDistance);
		else
			distance = maxDistance;

		transform.localPosition = Vector3.Lerp(transform.localPosition, dollyDir * distance, Time.deltaTime * smooth);
    }
}
