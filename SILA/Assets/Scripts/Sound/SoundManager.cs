using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public enum SoundType { ambiance, character, environement, transition, music}

[System.Serializable]
public class Sound
{
    public string name;
    public SoundType type;
    public AudioClip audioclip;

    [Range(0f, 1f)]
    public float volume;
    public bool loop;
    public bool oneShot;
    public float DecreaseTime;
}


public class SoundManager : MonoBehaviour
{
    public bool menu = false;
    [Range(0, 1)] public float musicVolume;
    public Sound[] sounds;

    public AudioSource AmbianceSource;
    [HideInInspector] public float AmbianceVolume;
    public AudioSource CharacterSource;
    [HideInInspector] public float CharacterVolume;
    public AudioSource EnvironementSource;
    [HideInInspector] public float EnvironementVolume;
    public AudioSource TransitionSource;
    [HideInInspector] public float TransitionVolume;
    public AudioSource MusicMorningSource;
    public AudioSource MusicDaySource;
    public AudioSource MusicTwilightSource;
    public AudioSource MusicNightSource;
    [HideInInspector] public float MusicVolume;
    //test

    private void Start()
    {
        if (!menu)
        {

            AmbianceVolume = HUDOptions._params[0] * HUDOptions._params[1];
            CharacterVolume = HUDOptions._params[0] * HUDOptions._params[2];
            EnvironementVolume = HUDOptions._params[0] * HUDOptions._params[1];
            TransitionVolume = HUDOptions._params[0] * HUDOptions._params[1];
            MusicVolume = HUDOptions._params[0] * HUDOptions._params[3] * musicVolume;
        }
        else
            MusicVolume = musicVolume;

        switch (TimeSystem.actualTime)
            {
                case TimeOfDay.Morning:
                    {
                        MusicMorningSource.volume = MusicVolume;
                        MusicDaySource.volume = 0;
                        MusicTwilightSource.volume = 0;
                        MusicNightSource.volume = 0;
                        break;
                    }
                case TimeOfDay.Day:
                    {
                        MusicMorningSource.volume = 0;
                        MusicDaySource.volume = MusicVolume;
                        MusicTwilightSource.volume = 0;
                        MusicNightSource.volume = 0;
                        break;
                    }
                case TimeOfDay.Noon:
                    {
                        MusicMorningSource.volume = 0;
                        MusicDaySource.volume = 0;
                        MusicTwilightSource.volume = MusicVolume;
                        MusicNightSource.volume = 0;
                        break;
                    }
                case TimeOfDay.Night:
                    {
                        MusicMorningSource.volume = 0;
                        MusicDaySource.volume = 0;
                        MusicTwilightSource.volume = 0;
                        MusicNightSource.volume = MusicVolume;
                        break;
                    }
            }

            MusicMorningSource.Play();
            MusicDaySource.Play();
            MusicTwilightSource.Play();
            MusicNightSource.Play();
    }

    private void Update()
    {
        if (!menu)
        {
            AmbianceVolume = HUDOptions._params[0] * HUDOptions._params[1];
            CharacterVolume = HUDOptions._params[0] * HUDOptions._params[2];
            EnvironementVolume = HUDOptions._params[0] * HUDOptions._params[1];
            TransitionVolume = HUDOptions._params[0] * HUDOptions._params[1];
            MusicVolume = HUDOptions._params[0] * HUDOptions._params[3] * musicVolume;


            switch (TimeSystem.actualTime)
            {
                case TimeOfDay.Morning:
                    {
                        MusicMorningSource.volume = MusicVolume * (1 - TimeSystem._transitionSlide);
                        MusicDaySource.volume = MusicVolume * TimeSystem._transitionSlide;
                        MusicTwilightSource.volume = 0;
                        MusicNightSource.volume = 0;
                        break;
                    }
                case TimeOfDay.Day:
                    {
                        MusicMorningSource.volume = 0;
                        MusicDaySource.volume = MusicVolume * (1 - TimeSystem._transitionSlide);
                        MusicTwilightSource.volume = MusicVolume * TimeSystem._transitionSlide;
                        MusicNightSource.volume = 0;
                        break;
                    }
                case TimeOfDay.Noon:
                    {
                        MusicMorningSource.volume = 0;
                        MusicDaySource.volume = 0;
                        MusicTwilightSource.volume = MusicVolume * (1 - TimeSystem._transitionSlide);
                        MusicNightSource.volume = MusicVolume * TimeSystem._transitionSlide;
                        break;
                    }
                case TimeOfDay.Night:
                    {
                        MusicMorningSource.volume = MusicVolume * TimeSystem._transitionSlide;
                        MusicDaySource.volume = 0;
                        MusicTwilightSource.volume = 0;
                        MusicNightSource.volume = MusicVolume * (1 - TimeSystem._transitionSlide);
                        break;
                    }
            }
        }
    }

    public void Play(string name)
    {
        Sound s = Array.Find(sounds, Sound => Sound.name == name);
        if (s == null)
        {
            Debug.LogWarning("Error : sound " + name + " not found");
            return;
        }
        /*Debug.LogWarning("Playing : " + name + " at "+ s.volume * AmbianceVolume +" of volume");
        Debug.LogWarning("Volume sound at " + s.volume + " times Options sounds at " + AmbianceVolume);*/
        switch (s.type)
        {
            case SoundType.ambiance:
                {
                    AmbianceVolume = HUDOptions._params[0] * HUDOptions._params[1];
                    AmbianceSource.loop = s.loop;
                    AmbianceSource.volume = s.volume * AmbianceVolume;
                    AmbianceSource.clip = s.audioclip;
                    if (s.oneShot)
                        AmbianceSource.PlayOneShot(s.audioclip);
                    else
                        AmbianceSource.Play();
                    break;
                }
            case SoundType.character:
                {
                    CharacterVolume = HUDOptions._params[0] * HUDOptions._params[2];
                    CharacterSource.loop = s.loop;
                    CharacterSource.volume = s.volume * CharacterVolume;
                    CharacterSource.clip = s.audioclip;
                    if (s.oneShot)
                        CharacterSource.PlayOneShot(s.audioclip);
                    else
                        CharacterSource.Play();
                    break;
                }
            case SoundType.environement:
                {
                    EnvironementVolume = HUDOptions._params[0] * HUDOptions._params[1];
                    EnvironementSource.loop = s.loop;
                    EnvironementSource.volume = s.volume * EnvironementVolume;
                    EnvironementSource.clip = s.audioclip;
                    if (s.oneShot)
                        EnvironementSource.PlayOneShot(s.audioclip);
                    else
                        EnvironementSource.Play();
                    break;
                }
            case SoundType.transition:
                {
                    TransitionVolume = HUDOptions._params[0] * HUDOptions._params[1];
                    TransitionSource.loop = s.loop;
                    TransitionSource.volume = s.volume * TransitionVolume;
                    TransitionSource.clip = s.audioclip;
                    if (s.oneShot)
                        TransitionSource.PlayOneShot(s.audioclip);
                    else
                        TransitionSource.Play();
                    break;
                }
        }

    }

    public void Stop(string name)
    {
        Sound s = Array.Find(sounds, Sound => Sound.name == name);
        if (s == null)
            return;
        switch (s.type)
        {
            case SoundType.ambiance:
                {
                    if (AmbianceSource.isPlaying)
                    {
                        if (s.DecreaseTime != 0)
                        {
                            StartCoroutine(DecreaseVolume(AmbianceSource, s.DecreaseTime));
                        }
                        else
                            AmbianceSource.Stop();
                    }
                    break;
                }
            case SoundType.character:
                {
                    if (CharacterSource.isPlaying)
                    {
                        if (s.DecreaseTime != 0)
                        {
                            StartCoroutine(DecreaseVolume(CharacterSource, s.DecreaseTime));
                        }
                        else 
                            CharacterSource.Stop();
                    }

                    break;
                }
            case SoundType.environement:
                {
                    if (EnvironementSource.isPlaying)
                    {
                        if (s.DecreaseTime != 0)
                        {
                            StartCoroutine(DecreaseVolume(EnvironementSource, s.DecreaseTime));
                        }
                        else
                            EnvironementSource.Stop();
                    }
                    break;
                }
            case SoundType.transition:
                {
                    if (TransitionSource.isPlaying)
                    {
                        if (s.DecreaseTime != 0)
                        {
                            StartCoroutine(DecreaseVolume(TransitionSource, s.DecreaseTime));
                        }
                        else
                            TransitionSource.Stop();
                    }
                    break;
                }
        }
    }

    private IEnumerator DecreaseVolume(AudioSource source, float time)
    { 
        while (source.volume > 0)
        {
            yield return new WaitForEndOfFrame();
            source.volume -= Time.deltaTime / time;
        }
        source.Stop();
    }
}
