using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDInGame : MonoBehaviour
{
    [Header("Scripts")]
    [SerializeField] private PlayerLifeManager _lifeManager;
    [SerializeField] private PlayerCollectibles _collectibles;
    [SerializeField] private CanvasGroup _visibility;
    [SerializeField] private float transitionTime;

    [Header("TimeOfDays")]
    [SerializeField] private Sprite _todDay;
    [SerializeField] private Sprite _todNigh;
    [SerializeField] private Sprite _todDawn;
    [SerializeField] private Sprite _todTwilight;

    [Header("Masks")]
    [SerializeField] private Sprite _mask0;
    [SerializeField] private Sprite _mask1;
    [SerializeField] private Sprite _mask2;
    [SerializeField] private Sprite _mask3;

    [Header("Life")]
    [SerializeField] private Sprite _hp;
    [SerializeField] private Sprite _hpLosed;
    [SerializeField] private Image _placeHolderLife;

    [Header("PlaceHolders")]
    [SerializeField] private Image _placeHolderMask;
    [SerializeField] private Image _placeHolderTod;
    [SerializeField] private Image _placeHolderFirstHp;
    [SerializeField] private Text _placeHolderCollectiblesCount;

    private List<Image> _healthBar = new List<Image>();

    private int _checkLifeChangement = 0;

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
        //Debug.Log("PlayerLife == " + _lifeManager.Life);
        CleanList();
        Vector3 ImgPos = new Vector3(260,980,0);
        int i = 0;
        while (i < _lifeManager.Life)
        {
            Image Hp = Instantiate(_placeHolderLife, ImgPos, Quaternion.identity, transform.GetChild(0).transform);
            ImgPos.x += 70;
            Hp.overrideSprite = _hp;
            _healthBar.Add(Hp);
            i++;
        }
        while (i < _lifeManager.MaxLife)
        {
            Image Hp = Instantiate(_placeHolderLife, ImgPos, Quaternion.identity, transform.GetChild(0).transform);
            ImgPos.x += 70;
            Hp.overrideSprite = _hpLosed;
            _healthBar.Add(Hp);
            i++;
        }
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
                    break;
                }
            case 1:
                {
                    _placeHolderMask.overrideSprite = _mask1;
                    break;
                }
            case 2:
                {
                    _placeHolderMask.overrideSprite = _mask2;
                    break;
                }
            case 3:
                {
                    _placeHolderMask.overrideSprite = _mask3;
                    break;
                }
        }
    }

    private void ActualiseCollectibleCount()
    {
        _placeHolderCollectiblesCount.text = _collectibles.GetCollectibles().ToString();
    }

    private void ActualiseTODIcon()
    {
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Day:
                {
                    _placeHolderTod.overrideSprite = _todDay;
                    break;
                }
            case TimeOfDay.Morning:
                {
                    _placeHolderTod.overrideSprite = _todDawn;
                    break;
                }
            case TimeOfDay.Night:
                {
                    _placeHolderTod.overrideSprite = _todNigh;
                    break;
                }
            case TimeOfDay.Noon:
                {
                    _placeHolderTod.overrideSprite = _todTwilight;
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
