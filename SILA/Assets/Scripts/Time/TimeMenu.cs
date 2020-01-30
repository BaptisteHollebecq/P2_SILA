using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeMenu : MonoBehaviour
{
    private bool _isActive = false;
    private float _deadZone = 0.25f;

    private Transform _arrow;
    private float _arrowAngle;
    private TimeOfDay _actualTime;
    private TimeSystem _timeManager;

    private void Awake()
    {
        Initialize();
    }

    private void Initialize()
    {
        transform.gameObject.SetActive(false);
        _arrow = transform.GetChild(transform.childCount - 1);
        _timeManager = transform.GetComponentInParent<TimeSystem>();

        CameraMaster.DisplayTimeMenu += DisplayMenu;
    }

    private void DisplayMenu()
    {
        if (!_isActive)
        {
            _isActive = true;
            transform.gameObject.SetActive(true);
            _actualTime = transform.GetComponentInParent<TimeSystem>().actualTime;
            //Debug.Log(_actualTime);
            switch (_actualTime)
            {
                case TimeOfDay.Morning:
                    _arrow.rotation = Quaternion.AngleAxis(90f, Vector3.forward);
                    break;
                case TimeOfDay.Day:
                    _arrow.rotation = Quaternion.AngleAxis(0f, Vector3.forward);
                    break;
                case TimeOfDay.Noon:
                    _arrow.rotation = Quaternion.AngleAxis(270f, Vector3.forward);
                    break;
                case TimeOfDay.Night:
                    _arrow.rotation = Quaternion.AngleAxis(180f, Vector3.forward);
                    break;
            }
        }
    }

    private void Update()
    {

        if (_isActive)
        {
            Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
            if (stickInput.magnitude < _deadZone)                                                                      
                stickInput = Vector2.zero;                                                                         
            else
                TurnArrow(stickInput);

            if (Input.GetButtonDown("B"))
            {
                _isActive = false;
                transform.gameObject.SetActive(false);
            }
            if (Input.GetButtonDown("A"))
            {
                Debug.Log(_arrowAngle);
                CheckTime();
            }
        }
    }

    private void CheckTime()
    {
        if (_arrowAngle > -45f && _arrowAngle <= 45f)
        {
            _timeManager.targetTime = TimeOfDay.Day;
        }
        else if (_arrowAngle > 45f && _arrowAngle <= 135f)
        {
            _timeManager.targetTime = TimeOfDay.Morning;
        }
        else if (_arrowAngle > 135f && _arrowAngle <= 225f)
        {
            _timeManager.targetTime = TimeOfDay.Night;
        }
        else
        {
            _timeManager.targetTime = TimeOfDay.Noon;
        }
    }


    public void TurnArrow(Vector2 stickInput)
    {

        float horizontal = stickInput.x;
        float vertical = stickInput.y;
        

        Vector3 aim = new Vector3(horizontal, vertical, 0f);
        _arrowAngle = (Mathf.Atan2(aim.y, aim.x) * Mathf.Rad2Deg) - 90f;

        _arrow.rotation = Quaternion.AngleAxis(_arrowAngle, Vector3.forward);

    }
}
