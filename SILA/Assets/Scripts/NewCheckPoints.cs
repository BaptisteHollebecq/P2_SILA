using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewCheckPoints : MonoBehaviour
{
    private PlayerLifeManager _life;


    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _life = other.GetComponent<PlayerLifeManager>();
            _life._position = other.transform.position;
            _life.checkPoints.Add(this);
            //CHANGER APPARENCE TOTEM
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _life = null;
        }
    }

    public void TurnOff()
    {
        //REMETTRE L'APPARENCE DE BASE
    }
}
