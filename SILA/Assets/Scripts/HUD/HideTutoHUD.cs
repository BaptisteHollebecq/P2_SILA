using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideTutoHUD : MonoBehaviour
{
    public static event System.Action<string> EnteredZoneHide;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            EnteredZoneHide?.Invoke("");
        }
    }
}
