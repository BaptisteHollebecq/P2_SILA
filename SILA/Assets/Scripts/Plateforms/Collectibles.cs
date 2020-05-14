using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Collider))]
public class Collectibles : MonoBehaviour
{
    PlayerCollectibles _collectibles;
    public int Zone;

    private HUDMap map;

    private void Awake()
    {
        map = GameObject.Find("HUDMap").GetComponent<HUDMap>();
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
