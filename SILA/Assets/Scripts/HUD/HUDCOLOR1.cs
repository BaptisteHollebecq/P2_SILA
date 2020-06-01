using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDCOLOR1 : MonoBehaviour
{
    private SpriteRenderer _img;

    public Gradient colorMorning;
    public Gradient colorDay;
    public Gradient colorNoon;
    public Gradient colorNight;

    private void Awake()
    {
        _img = GetComponent<SpriteRenderer>();
    }

    private void Update()
    {
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Day:
                {
                    _img.color = colorDay.Evaluate(TimeSystem._transitionSlide);
                    break;
                }
            case TimeOfDay.Morning:
                {
                    _img.color = colorMorning.Evaluate(TimeSystem._transitionSlide);
                    break;
                }
            case TimeOfDay.Noon:
                {
                    _img.color = colorNoon.Evaluate(TimeSystem._transitionSlide);
                    break;
                }
            case TimeOfDay.Night:
                {
                    _img.color = colorNight.Evaluate(TimeSystem._transitionSlide);
                    break;
                }
        }
    }
}
