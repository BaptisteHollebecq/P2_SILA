using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeMenu : MonoBehaviour
{
    public static event System.Action MenuDisplayed;

    private bool _isActive = false;
    private float _deadZone = 0.25f;
    private bool _isChanging = false;

    private Transform _arrow;
    private float _arrowAngle;
    private TimeOfDay _actualTime;
    private TimeSystem _timeManager;

	private CanvasGroup CanvasGroup;
    public HUDInGame Hud;

    private void Awake()
    {
        Initialize();
    }

    private void Initialize()
    {
        CameraMaster.MovedToPivot += DisplayMenu;
        TimeSystem.EndedTransition += EndTransitionTime;

        CanvasGroup = transform.GetComponent<CanvasGroup>();
		CanvasGroup.alpha = 0;
		_arrow = transform.GetChild(transform.childCount - 1);
        _timeManager = GetComponentInParent<TimeSystem>();
    }

    private void EndTransitionTime()
    {
        _isChanging = false;
        CanvasGroup.alpha = 1;
    }

    private void DisplayMenu()
    {
        if (!_isActive)
        {
            MenuDisplayed?.Invoke();
            _isActive = true;
			CanvasGroup.alpha = 1;
            Hud.Hide();
            _actualTime = TimeSystem.actualTime;
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
            {
                if (!_isChanging)
                    TurnArrow(stickInput); 
            }

            if (Input.GetButtonDown("B"))
            {
                if (!_isChanging)
                {
                    _isActive = false;
                    CanvasGroup.alpha = 0;
                    Hud.Show();
                }
            }
            if (Input.GetButtonDown("A"))
            {
                CheckTime();
            }
        }
    }

    private void CheckTime()
    {

        if (_arrowAngle > -45f && _arrowAngle <= 45f)
        {
            if (TimeSystem.actualTime != TimeOfDay.Day)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Day;
                CanvasGroup.alpha = 0;
            }
        }
        else if (_arrowAngle > 45f && _arrowAngle <= 135f)
        {
            if (TimeSystem.actualTime != TimeOfDay.Morning)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Morning;
                CanvasGroup.alpha = 0;
            }
        }
        else if (_arrowAngle > 135f || _arrowAngle <= -135f)
        {
            if (TimeSystem.actualTime != TimeOfDay.Night)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Night;
                CanvasGroup.alpha = 0;
            }
        }
        else
        {
            if (TimeSystem.actualTime != TimeOfDay.Noon)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Noon;
                CanvasGroup.alpha = 0;
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
