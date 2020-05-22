using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteleFragment : MonoBehaviour
{
    public Stele stele;

    public bool repairDay;
    public bool repairNight;
    public bool repairNoon;
    public bool repairMorning;

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            if (repairDay)
            {
                stele.brokenDay = false;
            }
            if (repairNight)
            {
                stele.brokenNight = false;
            }
            if (repairNoon)
            {
                stele.brokenNoon = false;
            }
            if (repairMorning)
            {
                stele.brokenMorning = false;
            }


            Destroy(gameObject);
        }
    }

}
