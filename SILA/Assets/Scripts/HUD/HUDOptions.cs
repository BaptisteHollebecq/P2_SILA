using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HUDOptions : MonoBehaviour
{
    public List<GameObject> Options;
    private List<Transform> _cursors = new List<Transform>();
    [HideInInspector]
    static public List<float> _params = new List<float>();

    public Transform selectionIcon;

    private int _index = 0;
    private Vector3 _pos;

    private bool _canswitch = true;
    private bool _canchange = true;
    [HideInInspector] public bool _isActive = false;

    private void Awake()
    {
        foreach (GameObject obj in Options)
        {
            _cursors.Add(obj.transform.GetChild(0));
            _params.Add(1);
        }
        AdjustCursors();
        AdjustSelection();
    }

    private void Update()
    {
        if (_isActive)
        {
            if (_canswitch)
            {
                float _inputVertical = Input.GetAxis("Vertical");
                if (_inputVertical == 1)
                {
                    _index--;
                    if (_index == -1)
                        _index = Options.Count - 1;
                    _canswitch = false;
                    StartCoroutine(ResetSwitch());
                    AdjustSelection();
                }
                else if (_inputVertical == -1)
                {

                    _index++;
                    if (_index == Options.Count)
                        _index = 0;
                    _canswitch = false;
                    StartCoroutine(ResetSwitch());
                    AdjustSelection();
                }
            }
            if (_canchange)
            {
                float _inputHorizontal = Input.GetAxis("Horizontal");
                if (_inputHorizontal == 1)
                {
                    _params[_index] += 0.1f;
                    if (_params[_index] > 1)
                        _params[_index] = 1;
                    _canchange = false;
                    StartCoroutine(ResetChange());
                    AdjustCursors();
                }
                else if (_inputHorizontal == -1)
                {
                    _params[_index] -= 0.1f;
                    if (_params[_index] < 0)
                        _params[_index] = 0;
                    _canchange = false;
                    StartCoroutine(ResetChange());
                    AdjustCursors();
                }
            }
        }
    }

    private void AdjustSelection()
    {
        _pos = new Vector3(-500, ((140 - ((_index + 1) * 105))), 0);
        selectionIcon.localPosition = _pos;
    }

    private void AdjustCursors()
    {
        int i = 0;
        foreach (Transform cursor in _cursors)
        {
            cursor.localPosition = new Vector3((-310 + (_params[i] * 620)),0,0);
            i++;
        }
    }

    IEnumerator ResetChange()
    {
        yield return new WaitForSecondsRealtime(0.15f);
        _canchange = true;
    }

    IEnumerator ResetSwitch()
    {
        yield return new WaitForSecondsRealtime(0.15f);
        _canswitch = true;
    }
}
