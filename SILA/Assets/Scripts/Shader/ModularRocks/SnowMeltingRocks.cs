using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowMeltingRocks : MonoBehaviour
{
    //public float currentTime;
    public float heighsnow;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {



        heighsnow = Mathf.Abs(2 * (TimeSystem.currentTime - 0.25f));


        if (heighsnow < 1)
        {
            heighsnow = (Mathf.Repeat(heighsnow, 1));
        }
        else
        {
            heighsnow = 1 - (Mathf.Repeat(heighsnow, 1));
        }

        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_SnowHeight", heighsnow);
    }
}
