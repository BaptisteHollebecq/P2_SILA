using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollectibles : MonoBehaviour
{
    private int _collectibles = 0;
    private int _maskCollectibles = 0;

    private bool _change = false;

    private void Update()
    {
        if (_maskCollectibles == 3 && !_change)
        {
            _change = true;
            StartCoroutine(Reset());
        }
    }

    IEnumerator Reset()
    {
        yield return new WaitForSeconds(1.5f);
        _maskCollectibles = 0;
        //ajouter un point de vie
        _change = false;
    }

    public void AddCollectibles(int nbr)
    {
        _collectibles+=nbr;
    }

    public void AddMask(int nbr)
    {
        _maskCollectibles += nbr;
    }



    public int GetCollectibles()
    {
        return _collectibles;
    }

    public int GetMask()
    {
        return _maskCollectibles;
    }
}
