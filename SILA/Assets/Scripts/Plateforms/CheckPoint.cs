using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{
    public AudioSource audioSource;
    public AudioClip sound;

    private PlayerLifeManager _lifeManager;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _lifeManager = other.GetComponent<PlayerLifeManager>();
            _lifeManager.CheckPoint();

            audioSource.PlayOneShot(sound);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _lifeManager = null;
        }
    }
}
