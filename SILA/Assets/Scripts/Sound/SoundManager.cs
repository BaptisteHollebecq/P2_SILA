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
    public bool oneShot;
    public float DecreaseTime;
}


public class SoundManager : MonoBehaviour
{
    public Sound[] sounds;

    public AudioSource AmbianceSource;
    [HideInInspector] public float AmbianceVolume;
    public AudioSource CharacterSource;
    [HideInInspector] public float CharacterVolume;
    public AudioSource EnvironementSource;
    [HideInInspector] public float EnvironementVolume;
    public AudioSource TransitionSource;
    [HideInInspector] public float TransitionVolume;

    private void Start()
    {
        AmbianceVolume = HUDOptions._params[0] * HUDOptions._params[1];
        CharacterVolume = HUDOptions._params[0] * HUDOptions._params[2];
        EnvironementVolume = HUDOptions._params[0] * HUDOptions._params[1];
        TransitionVolume = HUDOptions._params[0] * HUDOptions._params[1];
    }

    public void ChangeVolume()
    {
        AmbianceVolume = HUDOptions._params[0] * HUDOptions._params[1];
        CharacterVolume = HUDOptions._params[0] * HUDOptions._params[2];
        EnvironementVolume = HUDOptions._params[0] * HUDOptions._params[1];
        TransitionVolume = HUDOptions._params[0] * HUDOptions._params[1];

        if (AmbianceSource.clip != null)
        {
            Sound s = Array.Find(sounds, Sound => Sound.audioclip.name == AmbianceSource.clip.name);
            if (s == null)
                return;
            AmbianceSource.volume = s.volume * AmbianceVolume;
        }
        if (CharacterSource.clip != null)
        {
            Sound s = Array.Find(sounds, Sound => Sound.audioclip.name == CharacterSource.clip.name);
            if (s == null)
                return;
            CharacterSource.volume = s.volume * CharacterVolume;
        }
        if (EnvironementSource.clip != null)
        {
            Sound s = Array.Find(sounds, Sound => Sound.audioclip.name == EnvironementSource.clip.name);
            if (s == null)
                return;
            EnvironementSource.volume = s.volume * EnvironementVolume;
        }
        if (TransitionSource.clip != null)
        {
            Sound s = Array.Find(sounds, Sound => Sound.audioclip.name == TransitionSource.clip.name);
            if (s == null)
                return;
            TransitionSource.volume = s.volume * TransitionVolume;
        }
    }

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
