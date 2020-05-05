using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[RequireComponent(typeof(Collider))]
public class Collectibles : MonoBehaviour
{
    PlayerCollectibles _collectibles;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _collectibles = other.GetComponent<PlayerCollectibles>();
            _collectibles.AddCollectibles(1);
            gameObject.SetActive(false);
        }
    }
}
