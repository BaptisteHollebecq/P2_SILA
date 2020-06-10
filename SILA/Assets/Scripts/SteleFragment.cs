using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteleFragment : MonoBehaviour
{
    private PlayerCollectibles _player;

    public int delta = 100;

    private void FixedUpdate()
    {
        float i = Mathf.Sin(Time.time);

        transform.localPosition = new Vector3(transform.localPosition.x, transform.localPosition.y + (i / delta), transform.localPosition.z);
        transform.Rotate(Vector3.up);


    }


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
