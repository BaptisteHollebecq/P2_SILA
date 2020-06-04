using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Branch : MonoBehaviour
{
    public float angle;

    bool _ismovin = false;

    private void Awake()
    {
        TimeSystem.StatedMorningToDay += BranchRise;
        TimeSystem.StatedDayToNoon += BranchDown;

        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Morning:
                {
                    transform.rotation = Quaternion.Euler(0, 0, angle);
                    break;
                }
            case TimeOfDay.Day:
                {
                    transform.rotation = Quaternion.Euler(0, 0, 0);
                    break;
                }
            case TimeOfDay.Noon:
                {
                    transform.rotation = Quaternion.Euler(0, 0, angle);
                    break;
                }
            case TimeOfDay.Night:
                {
                    transform.rotation = Quaternion.Euler(0, 0, angle);
                    break;
                }
        }

    }

    private void OnDestroy()
    {
        TimeSystem.StatedMorningToDay -= BranchRise;
        TimeSystem.StatedDayToNoon -= BranchDown;
    }


    private void BranchDown(float timing)
    {
        if (!_ismovin)
        {
            StartCoroutine(RotateBranch(false, timing));
            _ismovin = true;
        }
    }

    private void BranchRise(float timing)
    {
        if (!_ismovin)
        {
            StartCoroutine(RotateBranch(true, timing));
            _ismovin = true;
        }
    }

    IEnumerator RotateBranch(bool rise, float timing)
    {

        var initRot = transform.localRotation;

        for (float f = 0; f < 1; f += Time.deltaTime / timing)
        {
            if (rise)
                transform.localRotation = Quaternion.Lerp(initRot, Quaternion.Euler(0, 0, 0), f);
            else
                transform.localRotation = Quaternion.Lerp(initRot, Quaternion.Euler(0, 0, angle), f);
            yield return null;
        }

        if (rise)
            transform.localRotation = Quaternion.Euler(0, 0, 0);
        else
            transform.localRotation = Quaternion.Euler(0, 0, 60);
        _ismovin = false;
    }

}
