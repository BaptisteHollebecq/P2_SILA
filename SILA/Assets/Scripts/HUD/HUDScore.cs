using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class HUDScore : MonoBehaviour
{
    public CanvasGroup blackScreenCanvas;
    public CanvasGroup CollectiblesCanvas;
    public CanvasGroup OhowakCanvas;
    public CanvasGroup AButton;
    public CanvasGroup EndPhrases;
    public Text collectibleIcon;
    public Text CollectibleCount;
    private int _collectibles;
    private int _maxCollec;
    public Text OhowakLost;
    public Text OhowakNbr;
    public Text EndPhrase;

    public GameObject member;

    public int OhowakNumber = 30;
    public float growthDuration = 1;
    public float CountDuration = 6;
    public float spawnRate = 0.2f;

    private List<GameObject> Tribu = new List<GameObject>();


    private float pourcentage;
    private int dead;
    private float saved;
    private int coef;
    private int y = 0;
    private int z = 6;
    private bool _canQuit = false;


    private void Start()
    {
        CollectiblesCanvas.alpha = 0;
        OhowakCanvas.alpha = 0;
        AButton.alpha = 0;
        EndPhrases.alpha = 0;

        _collectibles = FindObjectOfType<DontDestroyCollectibles>().GetComponent<DontDestroyCollectibles>().collectiblesCount;
        _maxCollec = FindObjectOfType<DontDestroyCollectibles>().GetComponent<DontDestroyCollectibles>().maxCollectiblesCount;
        CollectibleCount.text = "0";
        OhowakNbr.text = "0";
        StartCoroutine(Orga());


        pourcentage = Mathf.FloorToInt((_collectibles * 100) / _maxCollec);
        dead = Mathf.FloorToInt(70 * (1 - (pourcentage / 100)));
        saved = 347 - dead;
        coef = 347 / OhowakNumber;
    }

    private void Update()
    {
        if (Input.GetButtonDown("A") && _canQuit)
            SceneManager.LoadScene(0);


    }

    IEnumerator Quit()
    {
        StartCoroutine(FadeHud(EndPhrases, EndPhrases.alpha, 1, 1));
        yield return new WaitForSeconds(2);
        EndPhrase.text = "";
        EndPhrase.text += OhowakNbr.text;
        EndPhrase.text += " Ohowak Died...";
        StartCoroutine(FadeHud(AButton, AButton.alpha, 1, 1));
        yield return new WaitForSeconds(1);
        _canQuit = true;
    }

    IEnumerator Orga()
    {
        StartCoroutine(FadeHud(blackScreenCanvas, blackScreenCanvas.alpha, .5f, 1));
        yield return new WaitForSeconds(1);
        StartCoroutine(FadeHud(CollectiblesCanvas, CollectiblesCanvas.alpha, 1, 1));
        StartCoroutine(MoveToPivot(collectibleIcon.transform, new Vector3(-360, 200, 0), 0.0001f));
        StartCoroutine(CollecAnim());
    }

    void Delete()
    {
        Tribu.RemoveAt(0);
    }

    IEnumerator CollecAnim()
    {
        yield return new WaitForSeconds(1.5f);
        float i = 0;
        while (i < _collectibles)
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
        StartCoroutine(MoveToPivot(OhowakLost.transform, new Vector3(360, 200, 0), 0.0001f));
        StartCoroutine(SetOhowak());
        StartCoroutine(KillThem());

    }

    IEnumerator KillThem()
    {
        yield return new WaitForSeconds(1);
        int x = 0;
        for (int i = 0; i <= dead; i++)
        {
            if (x > coef)
            {
                KillOne();
                x = 0;
            }
            OhowakNbr.text = Mathf.Floor(i).ToString();
            x++;
            yield return new WaitForSeconds(CountDuration / dead);
        }
        yield return new WaitForSeconds(2);
        StartCoroutine(Quit());
    }

    void KillOne()
    {
        int x = Random.Range(y, z);
        y += 2;
        z += 2;
        Tribu[x].GetComponent<Ohowak>().Kill();
        Tribu.RemoveAt(x);
    }

    IEnumerator SetOhowak()
    {
        yield return new WaitForSeconds(0.0001f);
        for (int i = 0; i <= OhowakNumber; i++)
        {
            var inst = Instantiate(member, new Vector3(0, 0, 0), Quaternion.identity);
            inst.transform.parent = transform.GetChild(0).GetChild(3).transform;
            inst.transform.localPosition = new Vector3(-1200, -50, 0);
            Tribu.Add(inst);
            yield return new WaitForSeconds(spawnRate);
        }
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
