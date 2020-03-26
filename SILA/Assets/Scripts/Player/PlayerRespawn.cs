using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerRespawn : MonoBehaviour
{
    public PlayerMovement Player;

    [SerializeField] private float _actualise;
    private bool _save = true;
    private Vector3 _position;
    private Vector3 _checkPoint;

    private void Awake()
    {
        _checkPoint = Player.transform.position;
    }

    void Update()
    {
        if (_save)
        {
            if (Player.IsGrounded())
            {
                _position = transform.position;
                _save = false;
                Debug.Log("Last Pos === " + _position);
                StartCoroutine(Timer());
            }
        }
    }

    public void CheckPoint()
    {
        _checkPoint = Player.transform.position;
        Debug.Log("checkpoint === " + _checkPoint);
    }

    public void Death()
    {
        transform.position = _checkPoint;
    }

    public void Respawn()
    {
        transform.position = _position;
    }

    IEnumerator Timer()
    {
        yield return new WaitForSeconds(_actualise);
        _save = true;
    }


}
