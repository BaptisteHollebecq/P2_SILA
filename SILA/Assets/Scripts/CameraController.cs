using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    //public GameObject Player;

    [HideInInspector]
    public float yPosition = 5f;
    [HideInInspector]
    public float zPosition = -10f;
    [Header("Position Settings")]
    [Range(-10.0f, 10.0f)]
    public float xOffsetPosition = 0f;
    [Range(-10.0f, 10.0f)]
    public float yOffsetPosition = 0f;
    [Header("LookAt Settings")]
    [Range(-10.0f, 10.0f)]
    public float xOffsetLookAt = 0f;
    [Range(-10.0f, 10.0f)]
    public float yOffsetLookAt = 0f;
    [Header(" ")]
    public float rotationSpeed = 90f;
    [Header(" ")]
    public bool freeCamera = false;
    public bool invertHorizontal = false;
    public bool invertVertical = false;
    public bool complexeMode = false;

    Rigidbody target;
    Transform targetTransform;
    Vector3 offsetPosition;
    Vector3 lookAt;
    bool locked = true;
    float deadzone = 0.25f;
    float horizontalInput;
    float verticalInput;
 


    private void Start()
    {
        target = GameObject.Find("Player").GetComponentInParent<Rigidbody>();
        targetTransform = target.transform;
        offsetPosition = new Vector3(0f, yPosition, zPosition);
    }

    private void Update()
    {
        horizontalInput = (Input.GetAxis("HorizontalCamera"));
        if (Mathf.Abs(horizontalInput) < deadzone)
            horizontalInput = 0f;
        verticalInput = (Input.GetAxis("VerticalCamera"));
        if (Mathf.Abs(verticalInput) < deadzone)
            verticalInput = 0f;

        if (invertHorizontal)
            horizontalInput *= -1;
        if (invertVertical)
            verticalInput *= -1;
       
    }
    private void LateUpdate()
    {
 
        offsetPosition = Quaternion.AngleAxis(horizontalInput * (rotationSpeed * Time.deltaTime), Vector3.up) * offsetPosition;

        lookAt = new Vector3(targetTransform.position.x + xOffsetLookAt, targetTransform.position.y + yOffsetLookAt, targetTransform.position.z);
        transform.position = targetTransform.position + offsetPosition;
        transform.LookAt(lookAt);
    }

}
