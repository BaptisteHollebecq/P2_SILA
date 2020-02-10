using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wind : MonoBehaviour
{
    private Vector3 _windDirection;
    private Rigidbody _rb;
    
    public float windForce = 0.1f;
    

    private void Update()
    {
        _windDirection = transform.GetChild(0).transform.rotation.eulerAngles + new Vector3(0, 0, 270);
        
        // -90 degrees

        Debug.Log(_windDirection);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<Rigidbody>() != null)
        {
            _rb = other.GetComponent<Rigidbody>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        _rb = null;
    }

    private void OnTriggerStay(Collider other)
    {
        _rb.AddForce(_windDirection * windForce);
    }

}
