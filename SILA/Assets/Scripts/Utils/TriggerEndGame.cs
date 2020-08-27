using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class TriggerEndGame : MonoBehaviour
{
    public HUDInGame hud;
    public float timingFade;

    private PlayerControllerV2 _player;
    private bool isOnEnd = false;

    private void Update()
    {
        if (Input.GetButtonDown("A") || Input.GetButtonDown("Start"))
        {
            if (isOnEnd)
                SceneManager.LoadScene(3);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            isOnEnd = true;
            _player = other.GetComponent<PlayerControllerV2>();
            _player.isOnMap = true;

            StartCoroutine(Endit());

            HUDOptions._params[2] = 0;
        }
    }

    IEnumerator Endit()
    {
        CanvasGroup deadVisibility = hud.transform.GetChild(1).GetComponent<CanvasGroup>();
        StartCoroutine(hud.FadeHud(deadVisibility, deadVisibility.alpha, 1, timingFade));
        StartCoroutine(hud.FadeHud(hud._visibility, hud._visibility.alpha, 0, timingFade));
        yield return new WaitForSeconds(1);
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
}
