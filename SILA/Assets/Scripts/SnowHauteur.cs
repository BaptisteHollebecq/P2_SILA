using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowHauteur : MonoBehaviour
{
    // Start is called before the first frame update
    public Material mat;
    public float time;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log(TimeSystem.currentTime);
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("Time", TimeSystem.currentTime);

    }
}
