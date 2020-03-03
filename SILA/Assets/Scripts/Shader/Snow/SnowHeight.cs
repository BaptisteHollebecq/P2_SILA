using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowHeight : MonoBehaviour
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
        //Debug.Log(Mathf.Repeat(-0.25f, 1));
        

        heighsnow = Mathf.Abs(2 * (TimeSystem.currentTime - 0.25f));

        if (heighsnow < 1)
        {
            heighsnow = (Mathf.Repeat(heighsnow, 1));
        }
        else
        {
            heighsnow = 1 - (Mathf.Repeat(heighsnow, 1));
        }
       
        //heighsnow /= 2;

        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("Time", heighsnow);
    }
}
