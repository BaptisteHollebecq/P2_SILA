using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainMenu : MonoBehaviour
{
    [Header("Scene Management")]
    public SceneField GameScene;
    public SceneField OptionScene;

    [Header("Menu Management")]
    public Sprite Play;
    public Sprite PlaySelected;
    [Header("")]
    public Sprite Options;
    public Sprite OptionsSelected;
    [Header("")]
    public Sprite Quit;
    public Sprite QuitSelected;

    private int _index = 0;
    private bool _canswitch = true;
    //private float _

    private void Update()
    {
        ActualiseButton();

       /* if (Input.GetAxis("Horizontal") && _canswitch)
        {

        }*/
    }

    private void ActualiseButton()
    {
        throw new NotImplementedException();
    }
}
