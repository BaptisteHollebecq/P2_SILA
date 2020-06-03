﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Collider))]
public class Collectibles : MonoBehaviour
{
    PlayerCollectibles _collectibles;
    public int Zone;
    public int delta = 100;

    private HUDMap map;

    private void Awake()
    {
        map = GameObject.Find("HUDMap").GetComponent<HUDMap>();
    }

    private void Update()
    {
        float i = Mathf.Sin(Time.time);

        transform.localPosition = new Vector3(transform.localPosition.x, transform.localPosition.y+(i/delta), transform.localPosition.z);
        transform.Rotate(Vector3.up);


    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _collectibles = other.GetComponent<PlayerCollectibles>();
            _collectibles.AddCollectibles(1);
            map.Collect(Zone);
            gameObject.SetActive(false);
        }
    }
}
