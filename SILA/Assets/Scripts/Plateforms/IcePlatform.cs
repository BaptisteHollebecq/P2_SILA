using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IcePlatform : MonoBehaviour
{
    public bool ActiveOnMorning = false;
    public bool ActiveOnNoon = false;

    private Transform _platform;
    private float _scale = 0f;
    private BoxCollider _collider;
    private MeshRenderer _mesh;

    private void Awake()
    {
        _platform = transform.GetChild(0);
        _collider = _platform.GetComponent<BoxCollider>();
        _mesh = _platform.GetComponent<MeshRenderer>();

        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Morning:
                {
                    if (ActiveOnMorning)
                        _scale = 1f;
                    else
                        _scale = 0f;
                    break;
                }
            case TimeOfDay.Day:
                {
                    _scale = 0;
                    break;
                }
            case TimeOfDay.Noon:
                {
                    if (ActiveOnNoon)
                        _scale = 1f;
                    else
                        _scale = 0f;
                    break;
                }
            case TimeOfDay.Night:
                {
                    _scale = 0;
                    break;
                }

        }
        _platform.localScale = new Vector3(_scale,1, _scale);
    }

    private void FixedUpdate()
    {
        _scale = TimeSystem.currentTime * 2;
        _scale = Mathf.Repeat(_scale, 1);
        _scale = 1 - _scale;
        _scale = Mathf.Abs((_scale - 0.5f) * 2);

        if (TimeSystem.currentTime >= 0.25f && TimeSystem.currentTime <= 0.75f)
        {
            if (ActiveOnNoon)
                _platform.localScale = new Vector3(_scale, 1, _scale);

        }
        if (TimeSystem.currentTime >= 0.75f || TimeSystem.currentTime <= 0.25f)
        {
            if (ActiveOnMorning)
                _platform.localScale = new Vector3(_scale, 1, _scale);
        }

        if(_scale < 0.05f)
        {
            _mesh.enabled = false;
            _collider.enabled = false;
        }
        else
        {
            _mesh.enabled = true;
            _collider.enabled = true;
        }
    }
}