using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class ZoneChanging : MonoBehaviour
{
    public int EnteredZone;
    public int ExitedZone;
    public HUDMap map;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
            map.ChangeZone(EnteredZone, ExitedZone);
    }
}
