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
}
