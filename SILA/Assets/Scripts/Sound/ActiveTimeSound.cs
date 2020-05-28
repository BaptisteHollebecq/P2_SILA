using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActiveTimeSound : MonoBehaviour
{
    private AudioSource _source;
    public bool Dawn;
    public bool Day;
    public bool Twilight;
    public bool Night;

    private void Awake()
    {
        _source = transform.GetComponent<AudioSource>();
    }

    void Update()
    {
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Morning:
                {
                    if (Dawn)
                    {
                        _source.Play();
                    }
                    else
                        _source.Stop();
                    break;
                }
            case TimeOfDay.Day:
                {
                    if (Day)
                    {
                        _source.Play();
                    }
                    else
                        _source.Stop();
                    break;
                }
            case TimeOfDay.Noon:
                {
                    if (Twilight)
                    {
                        _source.Play();
                    }
                    else
                        _source.Stop();
                    break;
                }
            case TimeOfDay.Night:
                {
                    if (Night)
                    {
                        _source.Play();
                    }
                    else
                        _source.Stop();
                    break;
                }
        }
    }
}
