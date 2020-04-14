using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Geyser : MonoBehaviour
{
    public float Start;
    public float RestingTime;
    public float ActiveTime;
    public float ChargingTime;
    public float PushForce;

    private bool _started = false;
    private float _timer = 0;
    private Collider _collider;
    private Rigidbody _rb;
    private enum State { Charging, Active, Resting };
    private State actualState;

    private void Awake()
    {
        _collider = GetComponent<BoxCollider>();
        _rb = null;
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

    private void FixedUpdate()
    {

        if (Time.timeSinceLevelLoad >= Start && !_started)
        {
            _started = true;
            actualState = State.Charging;
        }

        if (_started)
        {
            _timer++;
            switch (actualState)
            {
                case State.Charging:
                    {
                        //PLAY CHARGING ANIMATION HERE
                        Debug.Log("Charging");
                        if (_timer / 50 >= ChargingTime)
                        {
                            actualState = State.Active;
                            _timer = 0;
                        }
                        break;
                    }
                case State.Active:
                    {
                        float force = PushForce + ((ActiveTime * 50)/* * 2*/);
                        if (_rb != null)
                        {
                            _rb.AddForce(Vector3.up * (force * 10));
                        }
                        force -= 2;

                        if (_timer / 50 >= ActiveTime)
                        {
                            actualState = State.Resting;
                            _timer = 0;
                        }
                        break;
                    }
                case State.Resting:
                    {
                        if (_timer / 50 >= RestingTime)
                        {
                            actualState = State.Charging;
                            _timer = 0;
                        }
                        break;
                    }
            }

        }

    }


}