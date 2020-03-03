using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindPlatform : MonoBehaviour
{
    private Vector3 _windDirection;
    private Rigidbody _rb;
    private PlayerController _player;
    private bool _isGrounded = false;

    public float windForce = 0.1f;


    private void Update()
    {
        _windDirection = transform.GetChild(0).transform.forward;

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = other.GetComponent<Rigidbody>();
            _player = other.GetComponent<PlayerController>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = null;
            _player = null;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (_player != null)
        {
            if (!_player.IsGrounded())
            {
                _rb.AddForce(_windDirection * windForce);
            }
        }
    }
}
