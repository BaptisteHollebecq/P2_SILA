using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteleRepair : MonoBehaviour
{
    public Stele stele;
    private PlayerCollectibles _player;
    private PlayerControllerV2 _controller;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _player = other.gameObject.GetComponent<PlayerCollectibles>();
            _controller = other.gameObject.GetComponent<PlayerControllerV2>();

                while (_player.repair > 0 && _controller.isGrounded)
                {
                    stele.Repair(_player.gameObject);
                    _player.repair--;
                }
        }
    }
}
