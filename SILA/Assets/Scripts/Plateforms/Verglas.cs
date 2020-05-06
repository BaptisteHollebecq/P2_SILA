using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(BoxCollider))]
public class Verglas : MonoBehaviour
{
    private Rigidbody _rb;
    private Vector3 _savedVelocity;

    private void OnTriggerEnter(Collider other)
    {
        
    }

}
