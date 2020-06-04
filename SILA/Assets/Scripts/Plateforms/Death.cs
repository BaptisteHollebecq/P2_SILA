﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Death : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            Debug.Log("player on water");
            collision.transform.GetComponent<PlayerLifeManager>().DeathWater();
        }
    }
}
