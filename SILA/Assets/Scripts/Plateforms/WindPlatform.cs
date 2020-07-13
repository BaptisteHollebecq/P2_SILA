using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindPlatform : MonoBehaviour
{
    private Vector3 _windDirection;
    private Rigidbody _rb;
    private PlayerControllerV2 _player;
    private bool _isGrounded = false;
    private MeshRenderer _renderer;

    public bool _debug = false;
    public float windForce;
    public float inertieDuration = 5f;

    private AudioSource _source;
    private Collider _collider;
    [Range(0f, 1f)] public float volume;


    private void Awake()
    {
        _renderer = transform.GetChild(1).GetComponent<MeshRenderer>();
        _source = transform.GetComponent<AudioSource>();
        _collider = transform.GetComponent<BoxCollider>();
    }

    private void Start()
    {
        
    }

    private void Update()
    {
        /*Debug.Log("son option master == " + HUDOptions._params[0]);
        Debug.Log("son option enviro == " + HUDOptions._params[1]);*/

        _source.volume = volume * HUDOptions._params[0] * HUDOptions._params[1];
        _windDirection = transform.GetChild(0).transform.forward;
        if (_collider.enabled == true)
        {
            if (!_source.isPlaying)
            {   
                _source.loop = true;
                _source.Play();
            }
        }
        else
        {
            if (_source.isPlaying)
            {
                _source.Stop();
            }
        }

    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _rb = other.GetComponent<Rigidbody>();
            _player = other.GetComponent<PlayerControllerV2>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _player.WindInertie(_windDirection, windForce, inertieDuration);
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
