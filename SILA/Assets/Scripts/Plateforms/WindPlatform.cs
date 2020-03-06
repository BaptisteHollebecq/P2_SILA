using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindPlatform : MonoBehaviour
{
    private Vector3 _windDirection;
    private Rigidbody _rb;
    private PlayerController _player;
    private bool _isGrounded = false;

    public float windForce;


    private void Update()
    {
        _windDirection = transform.GetChild(0).transform.forward;
        _windDirection = new Vector3(0,_windDirection.y,0);

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = other.GetComponent<Rigidbody>();
            _player = other.GetComponent<PlayerController>();
            Debug.Log("player aquired");
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = null;
            _player = null;
            Debug.Log("null");
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (_player != null)
        {
            Debug.Log("oui");
            if (!_player.IsGrounded())
            {
                Debug.Log("jumped");
                _rb.AddForce(_windDirection * windForce);
                Debug.DrawLine(transform.position, _windDirection);
            }
        }
    }
}
