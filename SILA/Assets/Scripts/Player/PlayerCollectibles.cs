using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollectibles : MonoBehaviour
{
    private int _collectibles = 0;

    public void Add(int nbr)
    {
        _collectibles+=nbr;
    }
}
