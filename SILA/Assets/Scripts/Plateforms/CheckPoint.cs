using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckPoint : MonoBehaviour
{

    private PlayerLifeManager _lifeManager;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _lifeManager = other.GetComponent<PlayerLifeManager>();
            _lifeManager.CheckPoint();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _lifeManager = null;
        }
    }
}
