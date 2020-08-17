using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowTutoHUD : MonoBehaviour
{
    public static event System.Action<string> EnteredZoneShow;

    public string tutoText;
    public SoundManager sound;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            EnteredZoneShow?.Invoke(tutoText);
            sound.Play("tuto");
        }
    }
}
