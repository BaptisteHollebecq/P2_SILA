using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GeyserShader : MonoBehaviour
{
    private float melting;

    [SerializeField]
    public float _geyserControl;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        melting = Mathf.Abs(2 * (_geyserControl/10));

        if (melting < 1)
        {
            melting = (Mathf.Repeat(melting, 1));
        }
        else
        {
            melting = 1 - (Mathf.Repeat(melting, 1));
        }

        //heighsnow /= 2;

        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_BottomStrenght", (2*melting) + 0.03f);
        
    }
}
