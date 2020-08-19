using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDScore : MonoBehaviour
{
    public CanvasGroup blackScreenCanvas;
    public CanvasGroup Collectibles;
    public Image collectibleIcon;
    public Text CollectibleCount;
    //public Text OhowakLost;
    //public Text OhowakNbr;

    private void Start()
    {
        Collectibles.alpha = 0;
        CollectibleCount.text = "0";
        StartCoroutine(FadeHud(blackScreenCanvas, blackScreenCanvas.alpha, .5f, 1));
        StartCoroutine(FadeHud(Collectibles, Collectibles.alpha, 1, 1));
        StartCoroutine(MoveToPivot(collectibleIcon.transform, new Vector3(-360, 200, 0), 1.5f));
    }




    IEnumerator MoveToPivot(Transform start, Vector3 end, float duration)
    {
        var initPos = start.localPosition;

        for (float f = 0; f < 1; f += Time.deltaTime / duration)
        {
            start.localPosition = Vector3.Lerp(initPos, end, f);
            yield return null;
        }

        start.localPosition = end;
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
