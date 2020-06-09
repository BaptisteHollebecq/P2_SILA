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

    public AudioClip charging;
    public AudioClip explode;

    private AudioSource _source;
    private bool _started = false;
    private float _timer = 0;
    private Collider _collider;
    private Rigidbody _rb;
    private enum State { Charging, Active, Resting };
    private State actualState;

    private PlayerControllerV2 _controller;

    private void Awake()
    {
        _collider = GetComponent<BoxCollider>();
        _rb = null;
        _source = GetComponent<AudioSource>();
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.GetComponent<Rigidbody>() != null)
        {
            _rb = other.GetComponent<Rigidbody>();
            _controller = other.GetComponent<PlayerControllerV2>();
            if (_rb.velocity.y < 0)
                _rb.velocity = new Vector3(_rb.velocity.x, 0, _rb.velocity.z);
            _controller.onG = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        _controller.onG = false;
        _rb = null;
    }

    private void Update()
    {
        _source.volume = .15f * HUDOptions._params[0] * HUDOptions._params[1];
    }

    private void FixedUpdate()
    {
        if (TimeSystem.actualTime == TimeOfDay.Noon)
        {
            if (Time.timeSinceLevelLoad >= Start && !_started)
            {
                _started = true;
                actualState = State.Charging;

                _source.PlayOneShot(charging);
            }

            if (_started)
            {
                _timer++;
                switch (actualState)
                {
                    case State.Charging:
                        {
                            //PLAY CHARGING ANIMATION HERE

                            if (_timer / 50 >= ChargingTime)
                            {
                                _source.PlayOneShot(explode);
                                actualState = State.Active;
                                _timer = 0;
                            }
                            break;
                        }
                    case State.Active:
                        {

                            float force = PushForce;
                            if (_rb != null)
                            {
                                _rb.AddForce(Vector3.up * (force * 10));
                            }
                            if (force < PushForce * 2)
                                force += 2;

                            if (_timer / 50 >= ActiveTime)
                            {
                                actualState = State.Resting;
                                StartCoroutine(DecreaseVolume(_source, .2f));
                                _timer = 0;
                            }
                            break;
                        }
                    case State.Resting:
                        {

                            if (_timer / 50 >= RestingTime)
                            {
                                _source.PlayOneShot(charging);
                                actualState = State.Charging;
                                _timer = 0;
                            }
                            break;
                        }
                }

            }
        }

    }

    private IEnumerator DecreaseVolume(AudioSource source, float time)
    {
        while (source.volume > 0)
        {
            yield return new WaitForEndOfFrame();
            source.volume -= Time.deltaTime / time;
        }
        source.Stop();
        yield return null;
    }

}