using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DontDestroyCollectibles : MonoBehaviour
{
    public int collectiblesCount;
    public int maxCollectiblesCount;

    private static DontDestroyCollectibles _instance;

    void Awake()
    {

        if (_instance == null)
        {
            _instance = this;
            DontDestroyOnLoad(this.gameObject);
        }
        else
        {
            Destroy(this);
        }
    }
}
