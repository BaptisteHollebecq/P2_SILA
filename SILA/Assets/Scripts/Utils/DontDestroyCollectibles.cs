using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DontDestroyCollectibles : MonoBehaviour
{
    public int collectiblesCount;
    public int maxCollectiblesCount;

    private void Awake()
    {
        if (FindObjectOfType<DontDestroyCollectibles>())
            Destroy(gameObject);
        DontDestroyOnLoad(this.gameObject);
    }
}
