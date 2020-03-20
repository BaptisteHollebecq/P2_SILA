using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(MeshRenderer))]

public class SelectVisibility : MonoBehaviour
{
    private MeshRenderer _renderer;

    public bool Aube = false;
    public bool Jour = false;
    public bool Crepuscule = false;
    public bool Nuit = false;

    private void Awake()
    {
        _renderer = GetComponent<MeshRenderer>();
    }

    private void Update()
    {
        switch(TimeSystem.actualTime)
        {
            case TimeOfDay.Day:
            {
                if (Jour)
                {
                    _renderer.enabled = true;
                }
                else
                {
                    _renderer.enabled = false;
                }
                break;
            }
            case TimeOfDay.Morning:
            {
                    if (Aube)
                    {
                        _renderer.enabled = true;
                    }
                    else
                    {
                        _renderer.enabled = false;
                    }
                    break;
            }
            case TimeOfDay.Night:
            {
                    if (Nuit)
                    {
                        _renderer.enabled = true;
                    }
                    else
                    {
                        _renderer.enabled = false;
                    }
                    break;
            }
            case TimeOfDay.Noon:
            {
                    if (Crepuscule)
                    {
                        _renderer.enabled = true;
                    }
                    else
                    {
                        _renderer.enabled = false;
                    }
                    break;
            }
        }
    }

}
