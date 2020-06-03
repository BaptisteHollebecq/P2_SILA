using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteleFragment : MonoBehaviour
{
    private PlayerCollectibles _player;

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            _player = other.gameObject.GetComponent<PlayerCollectibles>();

            _player.repair++;
            //Debug.Log("Le player a " + _player.repair + " morceau de stele sur lui");
            Destroy(gameObject);
        }
    }

}
