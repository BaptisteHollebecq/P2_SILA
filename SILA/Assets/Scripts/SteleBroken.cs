using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SteleBroken : Stele
{
    public static new event System.Action<Transform> SteleInteracted;

    public GameObject stelePart1;
    public Transform originPart1;
    public GameObject stelePart2;
    public Transform originPart2;
    public GameObject stelePart3;
    public Transform originPart3;
    public GameObject stelePart4;
    public Transform originPart4;
    public float repairtime;

    private void Awake()
    {
        if (brokenDay)
        {
            brokenPart++;
            isBroken = true;
        }
        if (brokenMorning)
        {
            brokenPart++;
            isBroken = true;
        }
        if (brokenNight)
        {
            brokenPart++;
            isBroken = true;
        }
        if (brokenNoon)
        {
            brokenPart++;
            isBroken = true;
        }
        
        if (brokenPart == 1)
        {
            stelePart4.SetActive(false);
        }
        else if (brokenPart == 2)
        {
            stelePart4.SetActive(false);
            stelePart3.SetActive(false);
        }
        else if (brokenPart == 3)
        {
            stelePart4.SetActive(false);
            stelePart3.SetActive(false);
            stelePart2.SetActive(false);
        }
        else if (brokenPart == 4)
        {
            stelePart4.SetActive(false);
            stelePart3.SetActive(false);
            stelePart2.SetActive(false);
            stelePart1.SetActive(false);
        }
    }

   public override void Repair(GameObject player)
    {
        switch (brokenPart)
        {
            case 4:
                {
                    StartCoroutine(RepairMe(stelePart1, originPart1, player));
                    brokenPart--;
                    break;
                }
            case 3:
                {
                    StartCoroutine(RepairMe(stelePart2, originPart2, player));
                    brokenPart--;
                    break;
                }
            case 2:
                {
                    StartCoroutine(RepairMe(stelePart3, originPart3, player));
                    brokenPart--;
                    break;
                }
            case 1:
                {
                    StartCoroutine(RepairMe(stelePart4, originPart4, player));
                    brokenPart--;
                    break;
                }

        }
    }

    IEnumerator RepairMe(GameObject obj, Transform origin, GameObject player)
    {
        Debug.Log(obj + "se trouve en " + obj.transform.position + " et a pour origin " + origin.position);
        Debug.Log("tandis que le player se trouve en " + player.transform.position);

        obj.transform.localPosition = player.transform.position;
        obj.transform.localRotation = player.transform.rotation;

        obj.SetActive(true);


        var initPos = player.transform.position;
        var initRot = player.transform.rotation;

        for (float f = 0; f < 1; f += Time.deltaTime / repairtime)
        {
            obj.transform.position = Vector3.Lerp(initPos, origin.position, f);
            obj.transform.rotation = Quaternion.Lerp(initRot, origin.rotation, f);
            yield return null;
        }

        obj.transform.position = origin.position;
        obj.transform.rotation = origin.rotation;
    }
}