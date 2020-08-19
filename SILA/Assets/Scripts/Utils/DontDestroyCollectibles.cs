using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DontDestroyCollectibles : MonoBehaviour
{
    public int collectiblesCount;

    private void Awake()
    {
        DontDestroyOnLoad(this.gameObject);
    }
}
