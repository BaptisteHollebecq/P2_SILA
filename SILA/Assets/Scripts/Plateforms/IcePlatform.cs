using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IcePlatform : MonoBehaviour
{
    public bool ActiveOnMorning = false;
    public bool ActiveOnNoon = false;

    private Transform _platform;
    private float _scale = 0f;

    private void Awake()
    {
        _platform = transform.GetChild(0);
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Morning:
                {
                    _scale = 1f;
                    break;
                }
            case TimeOfDay.Day:
                {
                    _scale = 0;
                    break;
                }
            case TimeOfDay.Noon:
                {
                    _scale = 1f;
                    break;
                }
            case TimeOfDay.Night:
                {
                    _scale = 0;
                    break;
                }

        }
    }

    private void FixedUpdate()
    {
        _scale = TimeSystem.currentTime;


        Debug.Log(_scale);
    }
}