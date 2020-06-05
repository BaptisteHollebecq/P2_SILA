using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SelectActive : MonoBehaviour
{
    public bool dawn;
    public bool day;
    public bool twilight;
    public bool night;

    public List<GameObject> _list;

    private void Update()
    {
        foreach(GameObject obj in _list)
        {
            if (TimeSystem.actualTime == TimeOfDay.Morning && dawn)
                obj.SetActive(true);
            else if (TimeSystem.actualTime == TimeOfDay.Day && day)
                obj.SetActive(true);
            else if (TimeSystem.actualTime == TimeOfDay.Noon && twilight)
                obj.SetActive(true);
            else if (TimeSystem.actualTime == TimeOfDay.Night && night)
                obj.SetActive(true);
            else
                obj.SetActive(false);
        }
    }
}
