using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RessourcesCollectibles : MonoBehaviour
{
    public int AddRessources = 1;

    public Transform Yflottant;
    public GameObject meshClean;
    public GameObject meshHarvested;

    private PlayerCollectibles collectibles;
    private bool isHarvested = false;

    private void Awake()
    {
        BasicState.Harvested += Harvest;
    }

    private void OnDestroy()
    {
        BasicState.Harvested -= Harvest;
    }

    private void Harvest()
    {
        if (collectibles != null && !isHarvested)
        {
            collectibles.AddCollectibles(AddRessources);
            Yflottant.gameObject.SetActive(false);
            meshClean.SetActive(false);
            meshHarvested.SetActive(true);
            isHarvested = true;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player" && !isHarvested)
        {
            Yflottant.gameObject.SetActive(true);
            other.GetComponent<PlayerControllerV2>().NearRessources = true;
            collectibles = other.GetComponent<PlayerCollectibles>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            Yflottant.gameObject.SetActive(false);
            other.GetComponent<PlayerControllerV2>().NearRessources = false;
            collectibles = null;
        }
    }
}
