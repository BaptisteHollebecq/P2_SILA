using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerTracks : MonoBehaviour
{
    [SerializeField]
    private GameObject _objectSnowCollision_L;
    [SerializeField]
    private GameObject _objectSnowCollision_R;
    [SerializeField]
    private ParticleSystem _particleSystem_L;
    [SerializeField]
    private ParticleSystem _particleSystem_R;
   

    RaycastHit _groundHit;

    int _layerMask;

    

    // Start is called before the first frame update
    void Start()
    {
        _layerMask = LayerMask.GetMask("Ground");
    }

    // Update is called once per frame
    void Update()
    {
        EmitWhenGrounded(_objectSnowCollision_L, _particleSystem_L);
        EmitWhenGrounded(_objectSnowCollision_R, _particleSystem_R);
        

    }

    private void EmitWhenGrounded(GameObject objectSnowCollision, ParticleSystem particleSystem)
    {
        if (Physics.Raycast(objectSnowCollision.transform.position, Vector3.down, out _groundHit, 0.4f, _layerMask))
        {
            particleSystem.emissionRate = 100f;
        }
        else
        {
            particleSystem.emissionRate = 0f;
        }    
    }

    
}
