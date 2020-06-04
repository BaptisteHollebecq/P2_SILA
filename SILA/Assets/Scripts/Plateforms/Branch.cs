using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Branch : MonoBehaviour
{
    private void Awake()
    {
        TimeSystem.StatedMorningToDay += BranchRise;
        TimeSystem.StatedDayToNoon += BranchDown;
    }

    private void OnDestroy()
    {
        TimeSystem.StatedMorningToDay -= BranchRise;
        TimeSystem.StatedDayToNoon -= BranchDown;
    }


    private void BranchDown()
    {
        //lancer animation down
    }

    private void BranchRise()
    {
        // lancer animation rise
    }

}
