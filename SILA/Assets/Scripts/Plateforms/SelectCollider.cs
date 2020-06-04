using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Collider))]
public class SelectCollider : MonoBehaviour
{
    private Collider _collider;

    public bool Aube = false;
    public bool Jour = false;
    public bool Crepuscule = false;
    public bool Nuit = false;

    private void Awake()
    {    
        _collider = GetComponent<Collider>();
    }

    private void Update()
    {
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Day:
                {
                    if (Jour)
                    {
                        _collider.enabled = true;
                    }
                    else
                    {
                        _collider.enabled = false;
                    }
                    break;
                }
            case TimeOfDay.Morning:
                {
                    if (Aube)
                    {
                        _collider.enabled = true;
                    }
                    else
                    {
                        _collider.enabled = false;
                    }
                    break;
                }
            case TimeOfDay.Night:
                {
                    if (Nuit)
                    {
                        _collider.enabled = true;
                    }
                    else
                    {
                        _collider.enabled = false;
                    }
                    break;
                }
            case TimeOfDay.Noon:
                {
                    if (Crepuscule)
                    {
                        _collider.enabled = true;
                    }
                    else
                    {
                        _collider.enabled = false;
                    }
                    break;
                }
        }
    }
}
