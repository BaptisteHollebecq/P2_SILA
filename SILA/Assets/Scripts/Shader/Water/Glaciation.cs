using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Glaciation : MonoBehaviour
{
    public float currentTime;
    float glace;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        glace = Mathf.Abs(2 * (TimeSystem.currentTime - 0.25f));

        if (glace < 1)
        {
            glace = (Mathf.Repeat(glace, 1));
        }
        else
        {
            glace = 1 - (Mathf.Repeat(glace, 1));
        }
        
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Glaciation", glace);
    }
}
