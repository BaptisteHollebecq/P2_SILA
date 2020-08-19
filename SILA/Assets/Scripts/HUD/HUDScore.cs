using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDScore : MonoBehaviour
{
    public CanvasGroup blackScreenCanvas;
    public CanvasGroup CollectiblesCanvas;
    public CanvasGroup OhowakCanvas;
    public Text collectibleIcon;
    public Text CollectibleCount;
    private int _collectibles;
    public Text OhowakLost;
    public Text OhowakNbr;

    public float growthDuration = 1;

    private void Start()
    {
        CollectiblesCanvas.alpha = 0;
        OhowakCanvas.alpha = 0;
        _collectibles = FindObjectOfType<DontDestroyCollectibles>().GetComponent<DontDestroyCollectibles>().collectiblesCount;
        CollectibleCount.text = "0";
        OhowakNbr.text = "0";
        StartCoroutine(FadeHud(blackScreenCanvas, blackScreenCanvas.alpha, .5f, 1));
        StartCoroutine(FadeHud(CollectiblesCanvas, CollectiblesCanvas.alpha, 1, 1));
        StartCoroutine(MoveToPivot(collectibleIcon.transform, new Vector3(-360, 200, 0), 1.5f));
        StartCoroutine(CollecAnim());
    }

    IEnumerator CollecAnim()
    {
        yield return new WaitForSeconds(1.5f);
        float i = 0;
        while (i <= _collectibles)
        {
            i++;
            CollectibleCount.text = Mathf.Floor(i).ToString();
            yield return new WaitForSeconds(growthDuration / _collectibles);
        }
        OhowakAnim();
    }

    void OhowakAnim()
    {
        StartCoroutine(FadeHud(OhowakCanvas, OhowakCanvas.alpha, 1, 1));
        StartCoroutine(MoveToPivot(OhowakLost.transform, new Vector3(360, 200, 0), 1.5f));
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
