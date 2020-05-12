using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDMap : MonoBehaviour
{
    [SerializeField] private PlayerControllerV2 _player;
    [SerializeField] private List<Zone> _zones;


    private Transform _canvas;
    private bool _isOpen = false;

    public void ChangeZone(int entered, int exited)
    {
        _zones[entered - 1].Entered();
        _zones[exited - 1].PlayerExit();
    }

    private void Awake()
    {
        _canvas = transform.GetChild(0);
        _canvas.gameObject.SetActive(false);
    }

    private void Update()
    {
        if (Input.GetButtonDown("Select") && !_isOpen)
        {
            _isOpen = true;
            _canvas.gameObject.SetActive(true);
            Time.timeScale = 0;
            _player._isOnMap = true;
        }
        if (Input.GetButtonDown("B") && _isOpen)
        {
            _isOpen = false;
            _canvas.gameObject.SetActive(false);
            Time.timeScale = 1;
            _player._isOnMap = false;
        }
    }
}
