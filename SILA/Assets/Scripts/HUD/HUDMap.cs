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
            _allZones.localScale = new Vector3(1, 1, 1);
            _allZones.localPosition = Vector3.zero;
            Time.timeScale = 1;
            _isZoomed = false;
            _player._isOnMap = false;
        }
        if (Input.GetButtonDown("A") && _isOpen)
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
