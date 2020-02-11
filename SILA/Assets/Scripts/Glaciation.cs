using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Glaciation : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Glaciation", TimeSystem.currentTime);
    }
}
