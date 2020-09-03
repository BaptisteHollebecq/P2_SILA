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
        //glace = Mathf.Clamp(TimeSystem.currentTime,0.5f,1);

        if (TimeSystem.currentTime > 0.5f && TimeSystem.currentTime < 0.75f)
        {
            glace = TimeSystem.currentTime;
        }
        else if (TimeSystem.currentTime >= 0.75f && TimeSystem.currentTime < 1)
        {
            glace = 1.5f - TimeSystem.currentTime;
        }
       
        glace = (glace - 0.5f) * 4;

        glace = Mathf.Clamp(glace, 0, 1);

        //glace = Mathf.Abs(2 * (TimeSystem.currentTime - 0.25f));

        //if (glace < 1)
        //{
        //    glace = (Mathf.Repeat(glace, 1));
        //}
        //else
        //{
        //    glace = 1 - (Mathf.Repeat(glace, 1));
        //}
        
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Glaciation", glace);
    }
}
