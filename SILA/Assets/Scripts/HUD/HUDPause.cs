using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class HUDPause : MonoBehaviour
{
    [SerializeField] private PlayerControllerV2 _player;
    public bool HorizontalMenu;
    public Transform allButtons;
    public List<string> titles = new List<string>();

    public HUDMap map;

    private int _index = 0;
    private bool _canswitch = true;

    private Transform _canvasButtons;
    private Transform _canvasCommands;
    private Transform _canvasOptions;

    private CanvasGroup _groupButtons;
    private CanvasGroup _groupCommands;
    private CanvasGroup _groupOptions;

    private HUDOptions hudOptions;

    List<Text> buttons = new List<Text>();
    private string _inputParam;
    private bool _invert = false;

    private bool _isOpen = false;

    private bool _isOnCommands = false;
    private bool _isOnOptions = false;
    private bool _isOnMap = false;

    private void Awake()
    {
        if (HorizontalMenu)
            _inputParam = "Horizontal";
        else
        { 
            _inputParam = "Vertical";
            _invert = true;
        }

        _canvasButtons = transform.GetChild(0);
        _canvasOptions = transform.GetChild(1);
        _canvasCommands = transform.GetChild(2);

        _groupOptions = _canvasOptions.GetComponent<CanvasGroup>();
        _groupCommands = _canvasCommands.GetComponent<CanvasGroup>();
        _groupButtons = _canvasButtons.GetComponent<CanvasGroup>();

        _groupOptions.alpha = 0;
        _groupCommands.alpha = 0;
        _groupButtons.alpha = 0;

        hudOptions = transform.GetChild(1).GetComponent<HUDOptions>();

        foreach (Transform child in allButtons)
        {
            Text txt = child.GetComponent<Text>();
            buttons.Add(txt);
        }

        ResetButtons();
    }

    private void Update()
    {
        if (_canswitch && _isOpen && !_isOnMap && !_isOnOptions)
        {
            float _input = Input.GetAxis(_inputParam);
            if (_invert)
                _input *= -1;
            if (_input == 1)
            {
                _index++;
                if (_index == allButtons.transform.childCount)
                    _index = 0;
                _canswitch = false;
                StartCoroutine(ResetSwitch());
                ResetButtons();
            }
            else if (_input == -1)
            {
                _index--;
                if (_index == -1)
                    _index = allButtons.transform.childCount - 1;
                _canswitch = false;
                StartCoroutine(ResetSwitch());
                ResetButtons();
            }
        }

        if (Input.GetButtonDown("Start"))
        {
            if (!_isOpen)
            {
                _isOpen = true;
                _groupButtons.alpha = 1;
                _player.isOnMap = true;
                Time.timeScale = 0;
            }
            else
            {             
                CloseAll();
            }
        }

        if (Input.GetButtonDown("B") && _isOpen)
        {
            if (_isOnCommands)
            {
                _isOnCommands = false;
                _groupCommands.alpha = 0;
                _groupButtons.alpha = 1;
            }
            else if (_isOnOptions)
            {
                _isOnOptions = false;
                hudOptions._isActive = false;
                _groupOptions.alpha = 0;
                _groupButtons.alpha = 1;
            }
            else if (_isOnMap)
            {
                _isOnMap = false;
                map.CloseMap();
                _groupButtons.alpha = 1;
            }
            else
            {
                CloseAll();
            }
        }

        if (Input.GetButtonDown("A") && _isOpen && !_isOnOptions && !_isOnMap)
        {
            switch(titles[_index])
            {
                case "Resume":
                    {
                        CloseAll();
                        break;
                    }
                case "Options":
                    {
                        _isOnOptions = true;
                        hudOptions._isActive = true;
                        _groupOptions.alpha = 1;
                        _groupButtons.alpha = 0;
                        break;
                    }
                case "Commands":
                    {
                        _isOnCommands = true;
                        _groupCommands.alpha = 1;
                        _groupButtons.alpha = 0;
                        break;
                    }
                case "Map":
                    {
                        _isOnMap = true;
                        map._isInPause = true;
                        map.OpenMap();
                        _groupButtons.alpha = 0;
                        break;
                    }
                case "Quit":
                    {
                        SceneManager.LoadScene(0);
                        break;
                    }
            }
        }
    }

    private void CloseAll()
    {
        _isOpen = false;
        if (_isOnMap)
            map.CloseMap();
        _groupOptions.alpha = 0;
        _groupCommands.alpha = 0;
        _groupButtons.alpha = 0;
        _isOnCommands = false;
        _isOnOptions = false;
        _isOnMap = false;
        _index = 0;
        Time.timeScale = 1;
        StartCoroutine(_player.EndIsOnMap());
        ResetButtons();
    }

    IEnumerator ResetSwitch()
    {
        yield return new WaitForSecondsRealtime(0.15f);
        _canswitch = true;
    }

    private void ResetButtons()
    {
        for (int i = 0; i < allButtons.transform.childCount; i++)
        {
            if (i < titles.Count)
                buttons[i].text = titles[i];
            else
                buttons[i].text = "/!\\/!\\/!\\";
        }
        if (_index < titles.Count)
            buttons[_index].text = "=" + titles[_index] + "=";
        else
            buttons[_index].text = "=/!\\/!\\=";
    }

}
