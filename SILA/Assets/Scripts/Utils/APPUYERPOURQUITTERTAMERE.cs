using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class APPUYERPOURQUITTERTAMERE : MonoBehaviour
{

    void Update()
    {
       if(Input.GetButtonDown("Start"))
       {
            Application.Quit();
       }
    }
}
