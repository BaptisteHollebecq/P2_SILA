using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Branch : MonoBehaviour
{
/*    public Transform bas;
    public Transform haut;
*/
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
                    transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, transform.rotation.eulerAngles.z+ angle);
                    break;
                }
            case TimeOfDay.Day:
                {
                    transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles);
                    break;
                }
            case TimeOfDay.Noon:
                {
                    transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, transform.rotation.eulerAngles.z + angle);
                    break;
                }
            case TimeOfDay.Night:
                {
                    transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, transform.rotation.eulerAngles.z + angle);
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
        Vector3 target;
        if (rise)
        {
            target = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, 0f);
        }
        else
        {
            target = new Vector3(transform.eulerAngles.x, transform.eulerAngles.y, angle);
        }

        var initRot = transform.eulerAngles;

        for (float f = 0; f < 1; f += Time.deltaTime / timing)
        {
            transform.rotation = Quaternion.Lerp(Quaternion.Euler(initRot), Quaternion.Euler(target), f);
            yield return null;
        }

        transform.rotation = Quaternion.Euler(target);
        _ismovin = false;
    }

}
