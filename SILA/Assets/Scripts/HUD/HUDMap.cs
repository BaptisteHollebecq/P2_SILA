using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDMap : MonoBehaviour
{
    [SerializeField] private PlayerControllerV2 _player;
    [SerializeField] private List<Zone> _zones;
    [SerializeField] private Transform _allZones;


    private Transform _canvas;
    private bool _isOpen = false;
    private bool _isZoomed = false;
    [HideInInspector] public bool _isInPause = false;

    private bool _canZoom = false;

    public void ChangeZone(int entered, int exited)
    {
        _zones[entered - 1].Entered();
        _zones[exited - 1].PlayerExit();
    }

    public void Collect(int zone)
    {
        _zones[zone - 1]._collectibles--;
    }

    private void Awake()
    {
        _canvas = transform.GetChild(0);
        _canvas.gameObject.SetActive(false);
        
    }

    private IEnumerator ActiveZoom()
    {
        yield return new WaitForSecondsRealtime(0.1f);
        _canZoom = true;
    }

    public void OpenMap()
    {
        _isOpen = true;
        _canvas.gameObject.SetActive(true);
        Time.timeScale = 0;
        _player.isOnMap = true;
        StartCoroutine(ActiveZoom());
    }

    public void CloseMap()
    {
        _isOpen = false;
        _canvas.gameObject.SetActive(false);
        _allZones.localScale = new Vector3(1, 1, 1);
        _allZones.localPosition = Vector3.zero;
        if (!_isInPause)
        {
            Time.timeScale = 1;
            StartCoroutine(_player.EndIsOnMap());
        }
        _isZoomed = false;
        _isInPause = false;
        _canZoom = false;
    }

    private void Update()
    {
        if (Input.GetButtonDown("Select") && !_isOpen)
        {
            OpenMap();
        }

        if (Input.GetButtonDown("B") && _isOpen)
        {
            CloseMap();
        }

        if (Input.GetButtonDown("A") && _isOpen && _canZoom)
        {
            if (!_isZoomed)
            {
                _isZoomed = true;
                _allZones.localScale = new Vector3(2, 2, 2);
            }
            else
            {
                _isZoomed = false;
                _allZones.localScale = new Vector3(1, 1, 1);
                _allZones.localPosition = Vector3.zero;
            }
        }

        if (_isZoomed && _isOpen)
        {
            Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
            if (stickInput.magnitude < 0.25f)
                stickInput = Vector2.zero;
            else
            {
                Vector3 tmp = _allZones.localPosition - (new Vector3(stickInput.x, stickInput.y, 0) * 15);
                tmp.x = Mathf.Clamp(tmp.x, -500, 500);
                tmp.y = Mathf.Clamp(tmp.y, -500, 500);
                _allZones.localPosition = tmp;
            }
        }
    }
}
