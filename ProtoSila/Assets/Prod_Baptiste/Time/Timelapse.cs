using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Timelapse : MonoBehaviour
{

    [Header("TIME")]
    [Tooltip("Day Lenght in minutes")]
    [SerializeField]
    private float _irlDayLength = 1f;
    public float irlDayLength { get { return _irlDayLength; } }

    [SerializeField]
    [Range(0f, 1f)]
    private float _timeOfDay;
    public float timeOfDay { get { return _timeOfDay; } }
    public bool pause = false;

    [Header("SETUP")]
    public float accelerationTime = 10f;
    [Header("")]
    public float nightTime = 0f;
    public float morningTime = 6f;
    public float dayTime = 12f;
    public float noonTime = 18f;

    [Header("SUN")]
    [SerializeField]
    private Transform _sun;
    [SerializeField]
    private Light _sunLight;
    private float _sunIntensity;
    [SerializeField]
    private float _sunVariation = 1.5f;
    [SerializeField]
    private float _sunBaseIntensity = 1f;

    private float _timeScale = 100f;
    private float _refTimeBase = 60f;
    private float _refTime = 60f;
    private float _targetTime = -1;

    private void Start()
    {
        CheckTime();
        CheckTime();
    }

    void CheckTime()
    {

        if (nightTime == 24)
            nightTime = 0;
        if (morningTime == 24)
            morningTime = 0;
        if (dayTime == 24)
            dayTime = 0;
        if (noonTime == 24)
            noonTime = 0;
    }

    private void Update()
    {

        if (Input.GetButtonDown("Night"))
            _targetTime = nightTime;
        if (Input.GetButtonDown("Morning"))
            _targetTime = morningTime;
        if (Input.GetButtonDown("Day"))
            _targetTime = dayTime; 
        if (Input.GetButtonDown("Noon"))
            _targetTime = noonTime;


        if (_targetTime != -1)
        {
            _refTime = _refTimeBase * (accelerationTime);
            if (Mathf.Floor(_timeOfDay * 24) == _targetTime)
            {
                _targetTime = -1;
                _refTime = _refTimeBase;
            }
        }

        Debug.Log(Mathf.Floor(_timeOfDay * 24));
    }

    private void FixedUpdate()
    {
        if (!pause)
        {
            UpdateTimeScale();
            UpdateTime();
        }
        AdjustSunRotation();
        SunIntensity();
    }


    private void UpdateTimeScale()
    {
        _timeScale = 24 / (_irlDayLength / _refTime);
    }

    private void UpdateTime()
    {
        _timeOfDay += Time.deltaTime * _timeScale / 86400;
        if (_timeOfDay > 1)
            _timeOfDay -= 1;
    }

    private void AdjustSunRotation()
    {
        float sunAngle = (_timeOfDay * 360f);
        _sun.transform.localRotation = Quaternion.Euler(new Vector3(sunAngle, 0f, 0f));
    }

    private void SunIntensity()
    {
        /*float _morningLength = (dayTime - morningTime);
        float _intensityScaleMorning = (_sunVariation / _timeScale) * _morningLength;

        float _noonLength = (24 - noonTime + nightTime);
        float _intensityScaleNoon = (_sunVariation / _timeScale) * _noonLength;


        if ((_timeOfDay >= (noonTime / 24) && _timeOfDay < 24) || (_timeOfDay >= 0 && _timeOfDay <= (nightTime / 24)))
            _sunLight.intensity -= _intensityScaleNoon;
        if (_timeOfDay >= (morningTime / 24) && _timeOfDay <= (dayTime / 24))
            _sunLight.intensity += _intensityScaleMorning;*/

        #region OLD
        _sunIntensity = Vector3.Dot(_sunLight.transform.forward, Vector3.down);
        _sunIntensity = Mathf.Clamp01(_sunIntensity);

        _sunLight.intensity = _sunIntensity * _sunVariation + _sunBaseIntensity;
        #endregion
    }

}
