using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Branch : MonoBehaviour
{
    public Transform bas;
    public Transform haut;

    bool _ismovin = false;

    private void Awake()
    {
        TimeSystem.StatedMorningToDay += BranchRise;
        TimeSystem.StatedDayToNoon += BranchDown;

        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Morning:
                {
                    transform.rotation = bas.rotation;
                    break;
                }
            case TimeOfDay.Day:
                {
                    transform.rotation = haut.rotation;
                    break;
                }
            case TimeOfDay.Noon:
                {
                    transform.rotation = bas.rotation;
                    break;
                }
            case TimeOfDay.Night:
                {
                    transform.rotation = bas.rotation;
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
            Debug.Log("la branch tombe");
            Debug.Log(transform.rotation + "and en bas is " + bas.rotation);
            StartCoroutine(RotateBranch(bas, timing));
            _ismovin = true;
        }
    }

    private void BranchRise(float timing)
    {
        if (!_ismovin)
        {
            Debug.Log("la branch monte");
            Debug.Log(transform.rotation + "and en haut is " + haut.rotation);
            StartCoroutine(RotateBranch(haut, timing));
            _ismovin = true;
        }
    }

    IEnumerator RotateBranch(Transform target, float timing)
    {
        var initRot = transform.rotation;

        for (float f = 0; f < 1; f += Time.deltaTime / timing)
        {
            transform.rotation = Quaternion.Lerp(initRot, target.rotation, f);
            yield return null;
        }

        transform.rotation = target.rotation;
        _ismovin = false;
    }

}
