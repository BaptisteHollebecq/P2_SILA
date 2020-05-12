using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Zone : MonoBehaviour
{
    [SerializeField] private bool discovered = false;
    [SerializeField] private bool playerIsIn = false;

    [SerializeField] private Sprite HidZone;
    [SerializeField] private Sprite RevZone;
    [SerializeField] private GameObject PlayerPosInZone;

    private Image ZoneImg;

    private bool seen = false;

    private void Awake()
    {
        ZoneImg = transform.GetChild(0).GetComponent<Image>();
        if (!discovered)
            ZoneImg.overrideSprite = HidZone;
        else
            ZoneImg.overrideSprite = RevZone;

        if (!playerIsIn)
            PlayerPosInZone.SetActive(false);
        else
            PlayerPosInZone.SetActive(true);
    }

    private void Update()
    {
        //mettre en place le systeme de comptage des collectibles #bordel
    }

    public void Entered()
    {
        if (!discovered)
        {
            Discovered();
            discovered = true;
        }
        PlayerEntered();
    }

    private void PlayerEntered()
    {
        playerIsIn = true;
        PlayerPosInZone.SetActive(true);
    }

    public void PlayerExit()
    {
        playerIsIn = false;
        PlayerPosInZone.SetActive(false);
    }

    private void Discovered()
    {
        ZoneImg.overrideSprite = RevZone;
        foreach(Transform child in transform)
        {
            child.gameObject.SetActive(true);
        }
    }
}
