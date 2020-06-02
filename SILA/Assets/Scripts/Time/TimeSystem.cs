using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeSystem : MonoBehaviour
{

    public static event System.Action EndedTransition;
    public static event System.Action StartedTransition;

    public static event System.Action StatedMorningToDay;
    public static event System.Action StatedDayToNoon;


    [SerializeField] private Transform _lightTransform;
    [SerializeField] private Light _light;

    [Header("")]
    public TimeOfDay startingTime;
    [HideInInspector] public TimeOfDay targetTime = TimeOfDay.Null;
    [HideInInspector] public static TimeOfDay actualTime;
    [HideInInspector] public static float currentTime;                 // current time used in transition
    [SerializeField] private float _transitionTime = 2f;        // time in second to go from the actual time to the next one
    [SerializeField] private SoundManager sound;


    [Header("Morning Setup")]
    [SerializeField] private float _lightIntensityMorning;
    [SerializeField] private Vector3 sunRotationMorning;
    [SerializeField] private Gradient _colorMorning;
    private Quaternion _sunRotationMorning;

    [SerializeField] private Gradient _SkyColorMorning;
    [SerializeField] private Gradient _EquatorColorMorning;
    [SerializeField] private Gradient _GroundColorMorning;
    [SerializeField] private Gradient _FogColorMorning;
    [SerializeField] private float _FogDensityMorning;


    [Header("Day Setup")]
    [SerializeField] private float _lightIntensityDay;
    [SerializeField] private Vector3 sunRotationDay;
    [SerializeField] private Gradient _colorDay;
    private Quaternion _sunRotationDay;

    [SerializeField] private Gradient _SkyColorDay;
    [SerializeField] private Gradient _EquatorColorDay;
    [SerializeField] private Gradient _GroundColorDay;
    [SerializeField] private Gradient _FogColorDay;
    [SerializeField] private float _FogDensityDay;

    [Header("Noon Setup")]
    [SerializeField] private float _lightIntensityNoon;
    [SerializeField] private Vector3 sunRotationNoon;
    [SerializeField] private Gradient _colorNoon;
    private Quaternion _sunRotationNoon;

    [SerializeField] private Gradient _SkyColorNoon;
    [SerializeField] private Gradient _EquatorColorNoon;
    [SerializeField] private Gradient _GroundColorNoon;
    [SerializeField] private Gradient _FogColorNoon;
    [SerializeField] private float _FogDensityNoon;

    [Header("Night Setup")]
    [SerializeField] private float _lightIntensityNight;
    [SerializeField] private Vector3 sunRotationNight;
    [SerializeField] private Gradient _colorNight;
    private Quaternion _sunRotationNight;

    [SerializeField] private Gradient _SkyColorNight;
    [SerializeField] private Gradient _EquatorColorNight;
    [SerializeField] private Gradient _GroundColorNight;
    [SerializeField] private Gradient _FogColorNight;
    [SerializeField] private float _FogDensityNight;

    private float _transitionScale;
    [HideInInspector] public static float _transitionSlide = 0f;
    private float _rotationScale;
    private float _intensityScale;
    private float _timeScale;
    /*private float _skyColorScale;
    private float _equatorColorScale;
    private float _groundColorScale;
    private float _fogColorScale;*/
    private float _fogDensityScale;

    private bool _menu = true;
    private bool _canswitch = true;

    private void Awake()
    {
        _sunRotationMorning.eulerAngles = sunRotationMorning;
        _sunRotationDay.eulerAngles = sunRotationDay;
        _sunRotationNoon.eulerAngles = sunRotationNoon;
        _sunRotationNight.eulerAngles = sunRotationNight;

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

    void MorningTime()
    {
        sound.Stop("Transition");
        sound.Play("AmbianceDawn");
        Debug.Log("play sound morning");

        _lightTransform.rotation = _sunRotationMorning;
        _light.intensity = _lightIntensityMorning;
        _light.color = _colorMorning.Evaluate(0);
        actualTime = TimeOfDay.Morning;
        currentTime = 0f;

        RenderSettings.ambientSkyColor = _SkyColorMorning.Evaluate(0);
        RenderSettings.ambientGroundColor = _GroundColorMorning.Evaluate(0);
        RenderSettings.ambientEquatorColor = _EquatorColorMorning.Evaluate(0);
        RenderSettings.fogColor = _FogColorMorning.Evaluate(0);
        RenderSettings.fogDensity = _FogDensityMorning;
    }

    void DayTime()
    {
        sound.Stop("Transition");
        sound.Play("AmbianceDay");

        _lightTransform.rotation = _sunRotationDay;
        _light.intensity = _lightIntensityDay;
        _light.color = _colorDay.Evaluate(0);
        actualTime = TimeOfDay.Day;
        currentTime = 0.25f;

        RenderSettings.ambientSkyColor = _SkyColorDay.Evaluate(0);
        RenderSettings.ambientGroundColor = _GroundColorDay.Evaluate(0);
        RenderSettings.ambientEquatorColor = _EquatorColorDay.Evaluate(0);
        RenderSettings.fogColor = _FogColorDay.Evaluate(0);
        RenderSettings.fogDensity = _FogDensityDay;
    }

    void NoonTime()
    {
        sound.Stop("Transition");
        sound.Play("AmbianceTwilight");

        _lightTransform.rotation = _sunRotationNoon;
        _light.intensity = _lightIntensityNoon;
        _light.color = _colorNoon.Evaluate(0);
        actualTime = TimeOfDay.Noon;
        currentTime = 0.5f;

        RenderSettings.ambientSkyColor = _SkyColorNoon.Evaluate(0);
        RenderSettings.ambientGroundColor = _GroundColorNoon.Evaluate(0);
        RenderSettings.ambientEquatorColor = _EquatorColorNoon.Evaluate(0);
        RenderSettings.fogColor = _FogColorNoon.Evaluate(0);
        RenderSettings.fogDensity = _FogDensityNoon;
    }

    void NightTime()
    {
        sound.Stop("Transition");
        sound.Play("AmbianceNight");

        _lightTransform.rotation = _sunRotationNight;
        _light.intensity = _lightIntensityNight;
        _light.color = _colorNight.Evaluate(0);
        actualTime = TimeOfDay.Night;
        currentTime = 0.75f;

        RenderSettings.ambientSkyColor = _SkyColorNight.Evaluate(0);
        RenderSettings.ambientGroundColor = _GroundColorNight.Evaluate(0);
        RenderSettings.ambientEquatorColor = _EquatorColorNight.Evaluate(0);
        RenderSettings.fogColor = _FogColorNight.Evaluate(0);
        RenderSettings.fogDensity = _FogDensityNight;
    }

    private void Start()
    {
        RenderSettings.fog = true;
    }

    private void Update()
    {
        if (Input.GetKeyDown("n"))
        {
            targetTime = TimeOfDay.Night;
            StartCoroutine(ChangeTimeV2());
            _menu = false;
        }
        if (Input.GetKeyDown("a"))
        {
            targetTime = TimeOfDay.Morning;
            StartCoroutine(ChangeTimeV2());
            _menu = false;
        }
        if (Input.GetKeyDown("j"))
        {
            targetTime = TimeOfDay.Day;
            StartCoroutine(ChangeTimeV2());
            _menu = false;
        }
        if (Input.GetKeyDown("c"))
        {
            targetTime = TimeOfDay.Noon;
            StartCoroutine(ChangeTimeV2());
            _menu = false;
        }

    }

    public IEnumerator ChangeTimeV2()
    {

        StartedTransition?.Invoke();

        float timeScale = SetupScaleV2(actualTime, targetTime);


        while (actualTime != targetTime && targetTime != TimeOfDay.Null)
        {
            yield return new WaitForEndOfFrame();

            _transitionSlide += Time.fixedDeltaTime / (_transitionTime * timeScale);

            if (actualTime == TimeOfDay.Morning)
            {
               // StatedMorningToDay?.Invoke();

                _light.color = _colorMorning.Evaluate(_transitionSlide);
                RenderSettings.ambientSkyColor = _SkyColorMorning.Evaluate(_transitionSlide);
                RenderSettings.ambientGroundColor = _GroundColorMorning.Evaluate(_transitionSlide);
                RenderSettings.ambientEquatorColor = _EquatorColorMorning.Evaluate(_transitionSlide);
                RenderSettings.fogColor = _FogColorMorning.Evaluate(_transitionSlide);

                _light.intensity = Mathf.Lerp(_lightIntensityMorning, _lightIntensityDay, _transitionSlide);
                RenderSettings.fogDensity = Mathf.Lerp(_FogDensityMorning, _FogDensityDay, _transitionSlide);

                _lightTransform.rotation = QuaternionExtension.Lerp(_sunRotationMorning, _sunRotationDay, _transitionSlide, true);
            }
            else if (actualTime == TimeOfDay.Day)
            {
                // StatedMorningToDay?.Invoke();

                _light.color = _colorDay.Evaluate(_transitionSlide);
                RenderSettings.ambientSkyColor = _SkyColorDay.Evaluate(_transitionSlide);
                RenderSettings.ambientGroundColor = _GroundColorDay.Evaluate(_transitionSlide);
                RenderSettings.ambientEquatorColor = _EquatorColorDay.Evaluate(_transitionSlide);
                RenderSettings.fogColor = _FogColorDay.Evaluate(_transitionSlide);

                _light.intensity = Mathf.Lerp(_lightIntensityDay, _lightIntensityNoon, _transitionSlide);
                RenderSettings.fogDensity = Mathf.Lerp(_FogDensityDay, _FogDensityNoon, _transitionSlide);

                _lightTransform.rotation = QuaternionExtension.Lerp(_sunRotationDay, _sunRotationNoon, _transitionSlide, true);
            }
            else if (actualTime == TimeOfDay.Noon)
            {
                // StatedMorningToDay?.Invoke();

                _light.color = _colorNoon.Evaluate(_transitionSlide);
                RenderSettings.ambientSkyColor = _SkyColorNoon.Evaluate(_transitionSlide);
                RenderSettings.ambientGroundColor = _GroundColorNoon.Evaluate(_transitionSlide);
                RenderSettings.ambientEquatorColor = _EquatorColorNoon.Evaluate(_transitionSlide);
                RenderSettings.fogColor = _FogColorNoon.Evaluate(_transitionSlide);

                _light.intensity = Mathf.Lerp(_lightIntensityNoon, _lightIntensityNight, _transitionSlide);
                RenderSettings.fogDensity = Mathf.Lerp(_FogDensityNoon, _FogDensityNight, _transitionSlide);

                _lightTransform.rotation = QuaternionExtension.Lerp(_sunRotationNoon, _sunRotationNight, _transitionSlide, false);
            }
            else if (actualTime == TimeOfDay.Night)
            {
                // StatedMorningToDay?.Invoke();

                _light.color = _colorNight.Evaluate(_transitionSlide);
                RenderSettings.ambientSkyColor = _SkyColorNight.Evaluate(_transitionSlide);
                RenderSettings.ambientGroundColor = _GroundColorNight.Evaluate(_transitionSlide);
                RenderSettings.ambientEquatorColor = _EquatorColorNight.Evaluate(_transitionSlide);
                RenderSettings.fogColor = _FogColorNight.Evaluate(_transitionSlide);

                _light.intensity = Mathf.Lerp(_lightIntensityNight, _lightIntensityMorning, _transitionSlide);
                RenderSettings.fogDensity = Mathf.Lerp(_FogDensityNight, _FogDensityMorning, _transitionSlide);

                _lightTransform.rotation = QuaternionExtension.Lerp(_sunRotationNight, _sunRotationMorning, _transitionSlide, false);
            }
            
            currentTime += _timeScale;
            if (currentTime >= 1)
                currentTime -= 1;

            if (_transitionSlide >= 1)
            {
                _transitionSlide = 0;
                if (actualTime == TimeOfDay.Morning)
                {
                    DayTime();
                }
                else if (actualTime == TimeOfDay.Day)
                {
                    NoonTime();
                }
                else if (actualTime == TimeOfDay.Noon)
                {
                    NightTime();
                }
                else if (actualTime == TimeOfDay.Night)
                {
                    MorningTime();
                }
            }
        }
        targetTime = TimeOfDay.Null;

        if (_menu)
        {
            EndedTransition?.Invoke();
        }
        _menu = true;
        _canswitch = true;
        yield return null;
    }

    private float SetupScaleV2(TimeOfDay from, TimeOfDay to)
    {
        if (from == TimeOfDay.Morning)
        {
            if (to == TimeOfDay.Day)
            {
                _timeScale = (0.25f / _transitionTime) * Time.fixedDeltaTime;
                return 1;
            }
            else if (to == TimeOfDay.Noon)
            {
                _timeScale = (0.5f / _transitionTime) * Time.fixedDeltaTime;
                return 0.5f;
            }
            else if (to == TimeOfDay.Night)
            {
                _timeScale = (0.75f / _transitionTime) * Time.fixedDeltaTime;
                return 0.333334f;
            }
        }
        if (from == TimeOfDay.Day)
        {
            if (to == TimeOfDay.Noon)
            {
                _timeScale = (0.25f / _transitionTime) * Time.fixedDeltaTime;
                return 1;
            }
            else if (to == TimeOfDay.Night)
            {
                _timeScale = (0.5f / _transitionTime) * Time.fixedDeltaTime;
                return 0.5f;
            }
            else if (to == TimeOfDay.Morning)
            {
                _timeScale = (0.75f / _transitionTime) * Time.fixedDeltaTime;
                return 0.333334f;
            }
        }
        if (from == TimeOfDay.Noon)
        {
            if (to == TimeOfDay.Night)
            {
                _timeScale = (0.25f / _transitionTime) * Time.fixedDeltaTime;
                return 1;
            }
            else if (to == TimeOfDay.Morning)
            {
                _timeScale = (0.5f / _transitionTime) * Time.fixedDeltaTime;
                return 0.5f;
            }
            else if (to == TimeOfDay.Day)
            {
                _timeScale = (0.75f / _transitionTime) * Time.fixedDeltaTime;
                return 0.333334f;
            }
        }
        if (from == TimeOfDay.Night)
        {
            if (to == TimeOfDay.Morning)
            {
                _timeScale = (0.25f / _transitionTime) * Time.fixedDeltaTime;
                return 1;
            }
            else if (to == TimeOfDay.Day)
            {
                _timeScale = (0.5f / _transitionTime) * Time.fixedDeltaTime;
                return 0.5f;
            }
            else if (to == TimeOfDay.Noon)
            {
                _timeScale = (0.75f / _transitionTime) * Time.fixedDeltaTime;
                return 0.333334f;
            }
        }
        return 0;
    }


}
