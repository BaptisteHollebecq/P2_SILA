using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lac : MonoBehaviour
{
    public float Depth = -0.01f;
    private Transform _collision;

    private void Awake()
    {
        _collision = transform.GetChild(0);
        Debug.Log(_collision);
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log(TimeSystem.actualTime);
        if (TimeSystem.actualTime == TimeOfDay.Night)
            _collision.localPosition = new Vector3(0, 0, 0);
        else
            _collision.localPosition = new Vector3(0, Depth, 0);
    }
}
