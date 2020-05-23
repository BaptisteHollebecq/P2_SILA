using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
public class TriggerHUD : MonoBehaviour
{
    public HUDInGame Hud;
    [Header("")]
    public bool hideHud;
    public bool showHud;

    private void Awake()
    {
        if (hideHud && showHud)
        {
            showHud = false;
        }
        else if (!hideHud && !showHud)
        {
            showHud = true;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.tag == "Player")
        {
            if (hideHud)
            {
                Hud.Hide();
            }
            else if (showHud)
            {
                Hud.Show();
            }
        }
    }

}
