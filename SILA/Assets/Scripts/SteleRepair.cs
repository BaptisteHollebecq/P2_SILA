using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteleRepair : MonoBehaviour
{
    public Stele stele;
    private PlayerCollectibles _player;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _player = other.gameObject.GetComponent<PlayerCollectibles>();
        }
        while (_player.repair > 0)
        {
            stele.Repair(_player.gameObject);
            _player.repair--;
        }
    }
}
