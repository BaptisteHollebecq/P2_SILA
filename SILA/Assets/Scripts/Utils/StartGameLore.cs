using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class StartGameLore : MonoBehaviour
{
    public CanvasGroup textCanvas;
    public CanvasGroup imageCanvas;
    public CanvasGroup remainingCanvas;
    public Text text;
    [Header("")]
    [Tooltip("temps pour que le texte soit completement invisible")] 
    public float fadeOutText;

    [Tooltip("temps pour que l'image soit completement invisible")]
    public float fadeOutImage;

    [Tooltip("temps pour que le texte soit completement visible")]
    public float fadeInText;            

    [Tooltip("temps pour que l'image soit completement visible")]
    public float fadeInImage;         

    [Tooltip("temps avant que l'image A COMMENCE  a s'afficher")]
    public float timingImage;           

    [Tooltip("temps entre le moment ou le text est efface et celui d'apres COMMENCE a s'afficher")]
    public float timingBeforeShowText;

    [Tooltip("liste de tout les textes a afficher")]
    public List<string> Lore = new List<string>();


    private int _index;
    private bool _canpass;
    private bool _endit;

    void Start()
    {
        _index = 0;
        _canpass = false;
        _endit = false;
        StartCoroutine(NextText());
    }


    IEnumerator NextText()
    {
        StartCoroutine(FadeHud(imageCanvas, imageCanvas.alpha, 0, fadeOutImage));
        StartCoroutine(FadeHud(textCanvas, textCanvas.alpha, 0, fadeOutText));
        yield return new WaitForSeconds(timingBeforeShowText);
        text.text = Lore[_index];
        _index++;
        StartCoroutine(FadeHud(textCanvas, textCanvas.alpha, 1, fadeInText));
        yield return new WaitForSeconds(timingImage+ fadeInText);
        StartCoroutine(FadeHud(imageCanvas, imageCanvas.alpha, 1, fadeInImage));
        yield return new WaitForSeconds(fadeInImage);
        _canpass = true;
    }

    IEnumerator StartGame()
    {
        StartCoroutine(FadeHud(imageCanvas, imageCanvas.alpha, 0, fadeOutImage));
        StartCoroutine(FadeHud(textCanvas, textCanvas.alpha, 0, fadeOutText));
        yield return new WaitForSeconds(timingBeforeShowText);
        StartCoroutine(FadeHud(remainingCanvas, remainingCanvas.alpha, 1, fadeInText));
        yield return new WaitForSeconds(timingImage + fadeInText);
        StartCoroutine(FadeHud(imageCanvas, imageCanvas.alpha, 1, fadeInImage));
        yield return new WaitForSeconds(fadeInImage);
        _endit = true;
    }


    void Update()
    {
        if (Input.GetButtonDown("A"))
        {
            if (_canpass)
            {
                _canpass = false;
                if (!(_index > Lore.Count - 1))
                    StartCoroutine(NextText());
                else
                    StartCoroutine(StartGame());
            }
            else if (_endit)
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
            }
        }
    }

    public IEnumerator FadeHud(CanvasGroup cg, float start, float end, float lerpTime = 0.5f)
    {
        float _timeStartedLerping = Time.time;
        float timeSinceStarted = Time.time - _timeStartedLerping;
        float percentageComplete = timeSinceStarted / lerpTime;

        while (true)
        {
            timeSinceStarted = Time.time - _timeStartedLerping;
            percentageComplete = timeSinceStarted / lerpTime;

            float currenValue = Mathf.Lerp(start, end, percentageComplete);

            cg.alpha = currenValue;

            if (percentageComplete >= 1) break;

            yield return new WaitForEndOfFrame();
        }
    }
}
