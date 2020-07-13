using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDInGame : MonoBehaviour
{
    [Header("Scripts")]
    [SerializeField] private PlayerLifeManager _lifeManager;
    public PlayerCollectibles _collectibles;
    public CanvasGroup _visibility;
    [SerializeField] private float transitionTime;

    [Header("TimeOfDays")]
    [SerializeField] private Sprite _todDay;
    [SerializeField] private Sprite _todNigh;
    [SerializeField] private Sprite _todDawn;
    [SerializeField] private Sprite _todTwilight;

    [SerializeField] private Sprite _todDayColo;
    [SerializeField] private Sprite _todNighColo;
    [SerializeField] private Sprite _todDawnColo;
    [SerializeField] private Sprite _todTwilightColo;

    [Header("Masks")]
    [SerializeField] private Sprite _mask0;
    [SerializeField] private Sprite _mask1;
    [SerializeField] private Sprite _mask2;
    [SerializeField] private Sprite _mask3;

    [SerializeField] private Sprite _mask0Colo;
    [SerializeField] private Sprite _mask1Colo;
    [SerializeField] private Sprite _mask2Colo;
    [SerializeField] private Sprite _mask3Colo;

    [Header("Life")]
    [SerializeField] private Sprite _hp;
    [SerializeField] private Sprite _hpColo;
    [SerializeField] private Sprite _hpLosed;
    [SerializeField] private Sprite _hpLosedColo;
    [SerializeField] private Image _placeHolderLife;
    [SerializeField] private Image _placeHolderLifeColo;

    [Header("PlaceHolders")]
    [SerializeField] private Image _placeHolderMask;
    [SerializeField] private Image _placeHolderMaskColo;
    [SerializeField] private Image _placeHolderTod;
    [SerializeField] private Image _placeHolderTodColo;
    [SerializeField] private Image _placeHolderFirstHp;
    [SerializeField] private Text _placeHolderCollectiblesCount;
    [SerializeField] private CanvasGroup canvasGraine;
    [SerializeField] private float timingShow;
    [SerializeField] private float timingStay;
    [SerializeField] private float timingHide;

    private List<Image> _healthBar = new List<Image>();

    private int _checkLifeChangement = -1;
    private bool _isShowed = true;

    private Text textEndGame;

    private void Awake()
    {
        transform.GetChild(1).GetComponent<CanvasGroup>().alpha = 0;
        transform.GetChild(2).GetComponent<CanvasGroup>().alpha = 0;
        textEndGame = transform.GetChild(2).GetChild(1).GetComponent<Text>();
        canvasGraine.alpha = 0;
    }

    private void Update()
    {
        ActualiseTODIcon();
        ActualiseCollectibleCount();
        ActualiseMaskIcon();

        if (_checkLifeChangement != _lifeManager.Life)
        {
            ActualiseLife();
            _checkLifeChangement = _lifeManager.Life;
        }
        
        if(Input.GetButtonDown("JRight"))
        {
            if (_isShowed)
            {
                Hide();
                _isShowed = false;
            }
            else
            {
                Show();
                _isShowed = true;
            }

        }
    }

    public void Hide()
    {
        StartCoroutine(FadeHud(_visibility, _visibility.alpha, 0, transitionTime)) ;
    }

    public void Show()
    {
        StartCoroutine(FadeHud(_visibility, _visibility.alpha, 1, transitionTime));
    }


    private void ActualiseLife()
    {
        CleanList();
        Vector3 ImgPos = new Vector3(260,980,0);
        int i = 0;
        while (i < _lifeManager.Life)
        {
            Image HpColor = Instantiate(_placeHolderLifeColo, ImgPos, Quaternion.identity, transform.GetChild(0).transform);
            Image Hp = Instantiate(_placeHolderLife, ImgPos, Quaternion.identity, HpColor.transform);
            
            Hp.gameObject.SetActive(true);
            HpColor.gameObject.SetActive(true);
            ImgPos.x += 70;
            Hp.overrideSprite = _hp;
            HpColor.overrideSprite = _hpColo;
            _healthBar.Add(Hp);
            _healthBar.Add(HpColor);
            i++;
        }
        while (i < _lifeManager.MaxLife)
        {
            Image HpColor = Instantiate(_placeHolderLifeColo, ImgPos, Quaternion.identity, transform.GetChild(0).transform);
            Image Hp = Instantiate(_placeHolderLife, ImgPos, Quaternion.identity, HpColor.transform);
            
            ImgPos.x += 70;
            Hp.overrideSprite = _hpLosed;
            HpColor.overrideSprite = _hpLosedColo;
            _healthBar.Add(Hp);
            _healthBar.Add(HpColor);
            i++;
        }
    }

    public void ShowJauge()
    {
        StartCoroutine(FadeHud(canvasGraine, canvasGraine.alpha, 1, timingShow));
        StartCoroutine(HideGraine());
    }

    IEnumerator HideGraine()
    {
        yield return new WaitForSeconds(timingShow + timingStay);
        StartCoroutine(FadeHud(canvasGraine, canvasGraine.alpha, 0, timingHide));
    }

    private void CleanList()
    {
        foreach (Image img in _healthBar)
        {
            Destroy(img.gameObject);
        }
        _healthBar = new List<Image>();
    }

    private void ActualiseMaskIcon()
    {
        switch(_collectibles.GetMask())
        {
            case 0:
                {
                    _placeHolderMask.overrideSprite = _mask0;
                    _placeHolderMaskColo.overrideSprite = _mask0Colo;
                    break;
                }
            case 1:
                {
                    _placeHolderMask.overrideSprite = _mask1;
                    _placeHolderMaskColo.overrideSprite = _mask1Colo;
                    break;
                }
            case 2:
                {
                    _placeHolderMask.overrideSprite = _mask2;
                    _placeHolderMaskColo.overrideSprite = _mask2Colo;
                    break;
                }
            case 3:
                {
                    _placeHolderMask.overrideSprite = _mask3;
                    _placeHolderMaskColo.overrideSprite = _mask3Colo;
                    break;
                }
        }
    }

    private void ActualiseCollectibleCount()
    {
        string s = "You collected ";

        float collectible = _collectibles.GetCollectibles();
        float pourcentage = Mathf.FloorToInt((collectible * 100) / _collectibles.maxCollec);

        s += pourcentage.ToString();
        s += "% of all collectibles\n";

        int dead = Mathf.FloorToInt( 70 * (1-(pourcentage / 100)));
        float saved = 347 - dead;

        s += dead.ToString() + " peoples died\n";
        s += saved.ToString();
        s += " people from your tribe remains";

        textEndGame.text = s;
    }


    private void ActualiseTODIcon()
    {
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Day:
                {
                    _placeHolderTod.overrideSprite = _todDay;
                    _placeHolderTodColo.overrideSprite = _todDayColo;
                    break;
                }
            case TimeOfDay.Morning:
                {
                    _placeHolderTod.overrideSprite = _todDawn;
                    _placeHolderTodColo.overrideSprite = _todDawnColo;
                    break;
                }
            case TimeOfDay.Night:
                {
                    _placeHolderTod.overrideSprite = _todNigh;
                    _placeHolderTodColo.overrideSprite = _todNighColo;
                    break;
                }
            case TimeOfDay.Noon:
                {
                    _placeHolderTod.overrideSprite = _todTwilight;
                    _placeHolderTodColo.overrideSprite = _todTwilightColo;
                    break;
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
