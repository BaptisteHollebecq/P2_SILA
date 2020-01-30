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

    private void Awake()
    {
        transform.gameObject.SetActive(false);
        _arrow = transform.GetChild(transform.childCount - 1);

        CameraMaster.DisplayTimeMenu += DisplayMenu;
    }

    private void DisplayMenu()
    {
        if (!_isActive)
        {
            _isActive = true;
            transform.gameObject.SetActive(true);
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
