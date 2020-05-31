using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(AudioSource))]
public class ActiveTimeSound : MonoBehaviour
{
    private AudioSource _source;

    public AudioClip clip;

    public bool Dawn;
    public bool Day;
    public bool Twilight;
    public bool Night;

    public int randomMin;
    public int randomMax;

    bool _canplay;

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
                    if (Dawn && _canplay)
                    {
                        _source.PlayOneShot(clip);
                        _canplay = false;
                        StartCoroutine(SwitchCanChange());
                    }
                    break;
                }
            case TimeOfDay.Day:
                {
                    if (Day && _canplay)
                    {
                        _source.PlayOneShot(clip);
                    }
                    break;
                }
            case TimeOfDay.Noon:
                {
                    if (Twilight && _canplay)
                    {
                        _source.PlayOneShot(clip);
                    }
                    break;
                }
            case TimeOfDay.Night:
                {
                    if (Night && _canplay)
                    {
                        _source.PlayOneShot(clip);
                    }
                    break;
                }
        }
    }

    private IEnumerator SwitchCanChange()
    {
        System.Random rand = new System.Random();
        yield return new WaitForSeconds(rand.Next(randomMin, randomMax));
    }
}
