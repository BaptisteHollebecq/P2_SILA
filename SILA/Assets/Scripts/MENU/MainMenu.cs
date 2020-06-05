using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public SceneField GameScene;
    [SerializeField] private Camera _camera;
    [SerializeField] private Transform _originalPos;
    [SerializeField] private Canvas LoadingScreen;
    [SerializeField] private float _transitionTime;


    public List<Transform> positions = new List<Transform>();

    List<Text> buttons = new List<Text>();

    public List<string> titles = new List<string>();

    public bool HorizontalMenu;
    private string _inputParam;

    private int _index = 0;
    private bool _canswitch = true;
    private float _input;

    
    private Transform _actualPos;
    private bool _canReturn = false;

    private Transform _canvas;
    private CanvasGroup _canvaGroup;

    private Transform _canvasback;
    private CanvasGroup _canvaGroupback;

    private AudioSource _source;
    public AudioClip sonMove;
    public AudioClip sonSelect;

    private bool _invert = false;

    private void Awake()
    {
        LoadingScreen.gameObject.SetActive(false);
        if (HorizontalMenu)
            _inputParam = "Horizontal";
        else
        {
            _inputParam = "Vertical";
            _invert = true;
        }
        _canvas = transform.GetChild(0);
        _canvaGroup = _canvas.GetComponent<CanvasGroup>();

        _canvasback = transform.GetChild(1);
        _canvaGroupback = _canvasback.GetComponent<CanvasGroup>();
        _canvaGroupback.alpha = 0;

        _source = GetComponent<AudioSource>();

        foreach (Transform child in _canvas)
        {
            Text txt = child.GetComponent<Text>();
            buttons.Add(txt);
        }
        ResetButtons();
    }

    private void ResetButtons()
    {
        for (int i = 0; i < _canvas.transform.childCount; i++)
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

    private void Update()
    {
        if (_canswitch)
        {
            float _input = Input.GetAxis(_inputParam);
            if (_invert)
                _input *= -1;
            if (_input == 1 )
            {
                _index++;
                if (_index == _canvas.transform.childCount)
                    _index = 0;
                _canswitch = false;
                StartCoroutine(ResetSwitch());
                _source.PlayOneShot(sonMove);
                
                ResetButtons();
            }
            else if (_input == -1)
            {
                _index--;
                if (_index == -1)
                    _index = _canvas.transform.childCount - 1;
                _canswitch = false;
                StartCoroutine(ResetSwitch());
                _source.PlayOneShot(sonMove);
                ResetButtons();
            }

        }

        if (Input.GetButtonDown("A"))
        {
            if (_index > positions.Count)
            {
                Debug.Log("Missing Positions in the list");
            }
            else
            {
                StartCoroutine(MoveToPivot(positions[_index], _transitionTime));
                _canvaGroup.alpha = 0;
                _source.PlayOneShot(sonSelect);
            }
        }
        if (Input.GetButtonDown("B"))
        {
            if (_canReturn)
            {
                StartCoroutine(MoveToPivot(_originalPos, _transitionTime));
                _canReturn = false;
                _canvaGroupback.alpha = 0;
                _source.PlayOneShot(sonSelect);
            }
        }
    }

    IEnumerator MoveToPivot(Transform pivot, float duration)
    {
        var initPos = _camera.transform.position;
        var initRot = _camera.transform.rotation;

        for (float f = 0; f < 1; f += Time.deltaTime / duration)
        {
            _camera.transform.position = Vector3.Lerp(initPos, pivot.position, f);
            _camera.transform.rotation = Quaternion.Lerp(initRot, pivot.rotation, f);
            yield return null;
        }

        _camera.transform.position = pivot.position;
        _camera.transform.rotation = pivot.rotation;

        _actualPos = pivot;
        CheckActualPos();
    }

    private void CheckActualPos()
    {
        //Debug.Log("actualpos == " + _actualPos.name);
        switch (_actualPos.name)
        {
            case "PosPlay":
                {
                    LoadingScreen.gameObject.SetActive(true);
                    SceneManager.LoadScene(GameScene.SceneName);
                    break;
                }
            case "PosQuit":
                {
                    Application.Quit();
                    break;
                }
            default:
                {
                    if (_actualPos != _originalPos)
                    {
                        _canReturn = true;
                        _canvaGroupback.alpha = 1;
                    }
                    else
                    {
                        _canvaGroup.alpha = 1;
                        _canvaGroupback.alpha = 0;
                    }
                    break;
                }
        }
    }

    IEnumerator ResetSwitch()
    {
        yield return new WaitForSeconds(0.15f);
        _canswitch = true;
    }
}
