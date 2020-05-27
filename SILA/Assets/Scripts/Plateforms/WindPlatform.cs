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

    public bool Debug = false;
    public float windForce;
    private float inertieDuration = 5f;

    private AudioSource _source;
    [Range(0f, 1f)] public float volume;


    private void Awake()
    {
        _renderer = transform.GetChild(1).GetComponent<MeshRenderer>();
        _source = transform.GetComponent<AudioSource>();

    }

    private void Start()
    {
        _source.volume = volume * HUDOptions._params[0];
        _source.loop = true;
        _source.Play();
    }

    private void Update()
    {
        _windDirection = transform.GetChild(0).transform.forward;
        //_windDirection = new Vector3(0,_windDirection.y,0);

        /*if (Debug)
        {
            _renderer.enabled = true;
        }
        else
            _renderer.enabled = false;*/

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
