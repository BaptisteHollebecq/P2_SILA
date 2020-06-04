using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowFall : MonoBehaviour
{
    ParticleSystem _particleSystem;

    [SerializeField]
    private float _particleSpeed;
    [SerializeField]
    private float _particleNumber;
    [SerializeField]
    private float _particleLife;

    [SerializeField]
    private float _transitionParticleSpeed;
    [SerializeField]
    private float _transitionParticleNumber;
    [SerializeField]
    private float _transitionParticleLife;


    // Start is called before the first frame update
    void Start()
    {
        _particleSystem = GetComponent<ParticleSystem>();
    }

    // Update is called once per frame
    void Update()
    {
        if (TimeSystem._transitionSlide != 0)
        {

            _particleSystem.startSpeed = _transitionParticleSpeed;
            _particleSystem.emissionRate = _transitionParticleNumber;
            _particleSystem.startLifetime = _transitionParticleLife;
        }
        else
        {
            _particleSystem.startSpeed = _particleSpeed;
            _particleSystem.emissionRate = _particleNumber;
            _particleSystem.startLifetime = _particleLife;
        }
    }
}
