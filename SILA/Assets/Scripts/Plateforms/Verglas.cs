using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(BoxCollider))]
public class Verglas : MonoBehaviour
{
    private Rigidbody _rb;
    private Vector3 _savedVelocity;
    private SlopeDetector _playerDetector;


    public float force = 5f;


    private void OnCollisionStay(Collision collision)
    {
        if(_playerDetector.isOnSlope == true)
        {
            _rb.AddForce(_playerDetector.slopeDirection * _playerDetector.slopeAngles * force); ;
        }
    }


    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            _rb = collision.transform.GetComponent<Rigidbody>();
            _playerDetector = collision.transform.GetComponent<SlopeDetector>();
            _playerDetector.checkForSlope = true;
        }
    }


    private void OnCollisionExit(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            _playerDetector.checkForSlope = false;
            _rb = null;
            _playerDetector = null;
        }
    }
}
