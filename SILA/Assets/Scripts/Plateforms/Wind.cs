using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wind : MonoBehaviour
{
    private Vector3 _windDirection;
    private Rigidbody _rb;
    private bool _isGrounded = false;
    
    public float windForce = 0.1f;

    private void Awake()
    {
        //Pto_PlayerController

    }

    private void PlayerIsGrounded()
    {
        _isGrounded = true;
    }

    private void PlayerAsJumped()
    {
        _isGrounded = false;
    }

    private void Update()
    {
        _windDirection = transform.GetChild(0).transform.forward;

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = other.GetComponent<Rigidbody>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = null;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (!_isGrounded)
         _rb.AddForce(_windDirection * windForce);
    }

}
