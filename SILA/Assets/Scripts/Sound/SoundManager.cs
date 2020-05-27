using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public enum SoundType { ambiance, character, environement, transition}

[System.Serializable]
public class Sound
{
    public string name;
    public SoundType type;
    public AudioClip audioclip;

    [Range(0f, 1f)]
    public float volume;
    public bool loop;
    public float DecreaseTime;
}


public class SoundManager : MonoBehaviour
{
    public Sound[] sounds;

    public AudioSource AmbianceSource;
    public AudioSource CharacterSource;
    public AudioSource EnvironementSource;
    public AudioSource TransitionSource;



    public void Play(string name)
    {
        Sound s = Array.Find(sounds, Sound => Sound.name == name);
        if (s == null)
        {
            Debug.LogWarning("Error : sound "+name+" not found");
            return;
        }

        switch (s.type)
        {
            case SoundType.ambiance:
                {
                    AmbianceSource.loop = s.loop;
                    AmbianceSource.volume = s.volume * HUDOptions._params[0];
                    AmbianceSource.clip = s.audioclip;
                    AmbianceSource.Play();
                    break;
                }
            case SoundType.character:
                {
                    CharacterSource.loop = s.loop;
                    CharacterSource.volume = s.volume * HUDOptions._params[0];
                    CharacterSource.clip = s.audioclip;
                    CharacterSource.Play();
                    break;
                }
            case SoundType.environement:
                {
                    break;
                }
            case SoundType.transition:
                {
                    TransitionSource.loop = s.loop;
                    TransitionSource.volume = s.volume * HUDOptions._params[0];
                    TransitionSource.clip = s.audioclip;
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
