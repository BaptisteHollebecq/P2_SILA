using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public enum TimeOfDay { Morning, Day, Noon, Night, Null };


public class TimeSystem : MonoBehaviour
{
   

    [SerializeField] private Transform _lightTransform;
    [SerializeField] private Light _light;

    [Header("")]
    public TimeOfDay startingTime;
    [HideInInspector] public TimeOfDay targetTime = TimeOfDay.Null;
    [HideInInspector] public TimeOfDay actualTime;
    [HideInInspector] public float currentTime;                 // current time used in transition
    [SerializeField] private float _transitionTime = 2f;        // time in second to go from the actual time to the next one
    

    [Header("Morning Setup")]
    [SerializeField] private float _lightIntensityMorning;
    [SerializeField] private Vector3 _sunRotationMorning;
    [SerializeField] private Gradient _colorMorning;

    [Header("Day Setup")]
    [SerializeField] private float _lightIntensityDay;
    [SerializeField] private Vector3 _sunRotationDay;
    [SerializeField] private Gradient _colorDay;

    [Header("Noon Setup")]
    [SerializeField] private float _lightIntensityNoon;
    [SerializeField] private Vector3 _sunRotationNoon;
    [SerializeField] private Gradient _colorNoon;

    [Header("Night Setup")]
    [SerializeField] private float _lightIntensityNight;
    [SerializeField] private Vector3 _sunRotationNight;
    [SerializeField] private Gradient _colorNight;

    private float _transitionScale;
    private float _transitionSlide = 0f;
    private float _rotationScale;
    private float _intensityScale;
    private float _timeScale;

    void MorningTime()
    {
        _lightTransform.rotation = Quaternion.Euler(_sunRotationMorning);
        _light.intensity = _lightIntensityMorning;
        _light.color = _colorMorning.Evaluate(0);
        actualTime = TimeOfDay.Morning;
        currentTime = 0f;
    }

    void DayTime()
    {
        _lightTransform.rotation = Quaternion.Euler(_sunRotationDay);
        _light.intensity = _lightIntensityDay;
        _light.color = _colorDay.Evaluate(0);
        actualTime = TimeOfDay.Day;
        currentTime = 0.25f;
    }

    void NoonTime()
    {
        _lightTransform.rotation = Quaternion.Euler(_sunRotationNoon);
        _light.intensity = _lightIntensityNoon;
        _light.color = _colorNoon.Evaluate(0);
        actualTime = TimeOfDay.Noon;
        currentTime = 0.5f;
    }

    void NightTime()
    {
        _lightTransform.rotation = Quaternion.Euler(_sunRotationNight);
        _light.intensity = _lightIntensityNight;
        _light.color = _colorNight.Evaluate(0);
        actualTime = TimeOfDay.Night;
        currentTime = 0.75f;
    }

    void SetupScale(TimeOfDay from)
    {
        if (from == TimeOfDay.Morning)
        {
            _rotationScale = ((_sunRotationDay.x - _sunRotationMorning.x) / _transitionTime) * Time.deltaTime;
            _transitionScale = (1 / _transitionTime) * Time.deltaTime;
            _timeScale = (0.25f / _transitionTime) * Time.deltaTime;
            _intensityScale = (Mathf.Abs(_lightIntensityMorning - _lightIntensityDay) / _transitionTime) * Time.deltaTime;
        }
        else if (from == TimeOfDay.Day)
        {
            _rotationScale = ((_sunRotationNoon.x - _sunRotationDay.x) / _transitionTime) * Time.deltaTime;
            _transitionScale = (1 / _transitionTime) * Time.deltaTime;
            _timeScale = (0.25f / _transitionTime) * Time.deltaTime;
            _intensityScale = (Mathf.Abs(_lightIntensityDay - _lightIntensityNoon) / _transitionTime) * Time.deltaTime;
        }
        else if (from == TimeOfDay.Noon)
        {
            _rotationScale = ((360 + (_sunRotationNight.x - _sunRotationNoon.x) - 180) / _transitionTime) * Time.deltaTime;
            _transitionScale = (1 / _transitionTime) * Time.deltaTime;
            _timeScale = (0.25f / _transitionTime) * Time.deltaTime;
            _intensityScale = (Mathf.Abs(_lightIntensityNoon - _lightIntensityNight) / _transitionTime) * Time.deltaTime;
        }
        else if (from == TimeOfDay.Night)
        {
            _rotationScale = ((360 - (_sunRotationMorning.x - _sunRotationNight.x) - 180) / 3.5f) * Time.deltaTime;
            _transitionScale = (1 / 3.5f) * Time.deltaTime;
            _timeScale = (0.25f / 3.5f) * Time.deltaTime;
            _intensityScale = (Mathf.Abs(_lightIntensityMorning - _lightIntensityNight) / 3.5f) * Time.deltaTime;
        }
    }

    TimeOfDay ChangeTime(TimeOfDay from, TimeOfDay to)
    {
        SetupScale(from);

        if (from != to)
        {
            if (_transitionSlide <= 1)
            {
                _transitionSlide += _transitionScale;
                if (from == TimeOfDay.Morning)
                {
                    _light.color = _colorMorning.Evaluate(_transitionSlide);
                    if (_lightIntensityDay > _lightIntensityMorning)
                        _light.intensity += _intensityScale;
                    else
                        _light.intensity -= _intensityScale;
                }
                else if (from == TimeOfDay.Day)
                {
                    _light.color = _colorDay.Evaluate(_transitionSlide);
                    if (_lightIntensityNoon > _lightIntensityDay)
                        _light.intensity += _intensityScale;
                    else
                        _light.intensity -= _intensityScale;
                }
                else if (from == TimeOfDay.Noon)
                {
                    _light.color = _colorNoon.Evaluate(_transitionSlide);
                    if (_lightIntensityNight > _lightIntensityNoon)
                        _light.intensity += _intensityScale;
                    else
                        _light.intensity -= _intensityScale;
                }
                else if (from == TimeOfDay.Night)
                {
                    _light.color = _colorNight.Evaluate(_transitionSlide);
                    if (_lightIntensityMorning > _lightIntensityNight)
                        _light.intensity += _intensityScale;
                    else
                        _light.intensity -= _intensityScale;
                }
                currentTime += _timeScale;
                if (currentTime >= 1)
                    currentTime -= 1;
                _lightTransform.Rotate(new Vector3(1f, 0f, 0f), _rotationScale);
                if ((_lightTransform.rotation.x >= 0.999987f || _lightTransform.rotation.x < 0f))
                {
                    _lightTransform.rotation = Quaternion.Euler(new Vector3(0f, 0f, 0f));
                    //Debug.Log(_transitionSlide);
                }
                return from;
            }
            else
            {
                if (from == TimeOfDay.Morning)
                    from = TimeOfDay.Day;
                else if (from == TimeOfDay.Day)
                    from = TimeOfDay.Noon;
                else if (from == TimeOfDay.Noon)
                    from = TimeOfDay.Night;
                else if (from == TimeOfDay.Night)
                    from = TimeOfDay.Morning;
                _transitionSlide = 0;
                return from;
            }
        }
        else
        {
            if (from == TimeOfDay.Morning)
                MorningTime();
            else if (from == TimeOfDay.Day)
                DayTime();
            else if (from == TimeOfDay.Noon)
                NoonTime();
            else if (from == TimeOfDay.Night)
                NightTime();
            _transitionSlide = 0;
            targetTime = TimeOfDay.Null;
            return from;
        }
    }

    private void Start()
    {
        switch (startingTime)
        {
            case TimeOfDay.Morning:
                MorningTime();
                break;
            case TimeOfDay.Day:
                DayTime();
                break;
            case TimeOfDay.Noon:
                NoonTime();
                break;
            case TimeOfDay.Night:
                NightTime();
                break;
            default:
                MorningTime();
                break;
        }

    }

    private void Update()
    {
        /*if (Input.GetButtonDown("Night"))
            _targetTime = TimeOfDay.Night;
        if (Input.GetButtonDown("Morning"))
            _targetTime = TimeOfDay.Morning;
        if (Input.GetButtonDown("Day"))
            _targetTime = TimeOfDay.Day;
        if (Input.GetButtonDown("Noon"))
            _targetTime = TimeOfDay.Noon;*/

        //Debug.Log(actualTime);
        //Debug.Log(_rotationScale);
        //Debug.Log(_lightTransform.localRotation.x);
        //Debug.Log(currentTime);
    }
    private void FixedUpdate()
    {
        if (targetTime != TimeOfDay.Null)
        {
            actualTime = ChangeTime(actualTime, targetTime);
        }
    }
}
