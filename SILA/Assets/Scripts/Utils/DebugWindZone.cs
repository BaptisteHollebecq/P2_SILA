using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DebugWindZone : MonoBehaviour
{
    private Transform _parent;
    private BoxCollider _collider;


    private void Awake()
    {
        _parent = transform.parent;
        _collider = _parent.GetComponent<BoxCollider>();
    }

    void Update()
    {
        transform.localScale = _collider.size;
    }
}
