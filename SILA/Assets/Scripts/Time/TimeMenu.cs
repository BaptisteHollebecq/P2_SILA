using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour
{


    private void Awake()
    {
        CameraMaster.DisplayTimeMenu += Methode;
    }

    private void Methode()
    {
        
    }
}
