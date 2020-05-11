using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(BoxCollider))]
public class Verglas : MonoBehaviour
{
    private Rigidbody _rb;
    private Vector3 _savedVelocity;
    private SlopeDetector _playerDetector;

    private float _deadZone = 0.25f;


    public float slipperyCoheficient = 10f;
    public float friction = 0.1f;
    private float _decrease;

    private void OnCollisionStay(Collision collision)
    {
        if(_playerDetector.isOnSlope == true)
        {
            _rb.AddForce(_playerDetector.slopeDirection * (_playerDetector.slopeAngles * slipperyCoheficient));        
        }
        else
        {
            Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
            if (stickInput.magnitude < _deadZone)                                                                   
                stickInput = Vector2.zero;
            if (stickInput != Vector2.zero)
            {
                _savedVelocity = _rb.velocity;
                _decrease = slipperyCoheficient;
            }
            else if (_decrease >= 0)
            {
                _rb.AddForce(_savedVelocity * _decrease);
                _decrease -= friction;
            }
        }
    }


    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            _rb = collision.transform.GetComponent<Rigidbody>();
            _playerDetector = collision.transform.GetComponent<SlopeDetector>();
            _playerDetector.checkForSlope = true;
            _savedVelocity = _rb.velocity;
        }
    }


    private void OnCollisionExit(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            _playerDetector.checkForSlope = false;
            _rb = null;
            _playerDetector = null;
            _savedVelocity = Vector3.zero;
        }
    }
}
