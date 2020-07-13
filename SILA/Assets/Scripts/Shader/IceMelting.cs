using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IceMelting : MonoBehaviour
{
    private float melting;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        melting = Mathf.Abs(2 * (TimeSystem.currentTime - 0.25f));

        if (melting < 1)
        {
            melting = (Mathf.Repeat(melting, 1));
        }
        else
        {
            melting = 1 - (Mathf.Repeat(melting, 1));
        }

        //heighsnow /= 2;

        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Melting", (1-(2*melting)));
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_SnowCavity", (1-melting)*-20f);
    }
}
