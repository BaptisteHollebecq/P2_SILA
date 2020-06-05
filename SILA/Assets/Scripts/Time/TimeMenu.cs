using UnityEngine;

public class TimeMenu : MonoBehaviour
{
    public static event System.Action MenuDisplayed;
    public static event System.Action MenuQuited;

    private bool _isActive = false;
    private float _deadZone = 0.25f;
    private bool _isChanging = false;

    private Transform _arrow;
    private float _arrowAngle;
    private TimeOfDay _actualTime;
    private TimeSystem _timeManager;

	private CanvasGroup CanvasGroup;
    public HUDInGame Hud;
    public SoundManager sound;

    [HideInInspector] public bool isBroken = false;
    [HideInInspector] public bool brokenDay = false;
    [HideInInspector] public bool brokenNight = false;
    [HideInInspector] public bool brokenMorning = false;
    [HideInInspector] public bool brokenNoon = false;

    private Transform _daySprite;
    private Transform _nightSprite;
    private Transform _morningSprite;
    private Transform _noonSprite;

    private void Awake()
    {
        Initialize();
        _daySprite = transform.GetChild(1);
        _nightSprite = transform.GetChild(2);
        _morningSprite = transform.GetChild(3);
        _noonSprite = transform.GetChild(4);

    }

    private void Initialize()
    {
        CameraMaster.MovedToPivot += DisplayMenu;
        TimeSystem.EndedTransition += EndTransitionTime;

        CanvasGroup = transform.GetComponent<CanvasGroup>();
		CanvasGroup.alpha = 0;
		_arrow = transform.GetChild(transform.childCount - 1);
        _timeManager = GetComponentInParent<TimeSystem>();
    }

    private void OnDestroy()
    {
        CameraMaster.MovedToPivot -= DisplayMenu;
        TimeSystem.EndedTransition -= EndTransitionTime;
    }

    private void EndTransitionTime()
    {
        _isChanging = false;
        switch (TimeSystem.actualTime)
        {
            case TimeOfDay.Morning:
                _arrow.rotation = new Quaternion(0,0,.7f,.7f);
                break;
            case TimeOfDay.Day:
                _arrow.rotation = new Quaternion(0, 0, 0, 1);
                break;
            case TimeOfDay.Noon:
                _arrow.rotation = new Quaternion(0, 0, -.7f, .7f);
                break;
            case TimeOfDay.Night:
                _arrow.rotation = new Quaternion(0, 0, -1, 0);
                break;
        }
        CanvasGroup.alpha = 1;
    }

    private void DisplayMenu()
    {
        if (!_isActive)
        {
            
            if (isBroken)
            {
                if (isBroken)
                    _daySprite.gameObject.SetActive(false);
                if (isBroken)
                    _nightSprite.gameObject.SetActive(false);
                if (isBroken)
                    _noonSprite.gameObject.SetActive(false);
                if (isBroken)
                    _morningSprite.gameObject.SetActive(false);
            }
                MenuDisplayed?.Invoke();
            _isActive = true;
			CanvasGroup.alpha = 1;
            Hud.Hide();
            switch (TimeSystem.actualTime)
            {
                case TimeOfDay.Morning:
                    _arrow.rotation = new Quaternion(0, 0, .7f, .7f);
                    break;
                case TimeOfDay.Day:
                    _arrow.rotation = new Quaternion(0, 0, 0, 1);
                    break;
                case TimeOfDay.Noon:
                    _arrow.rotation = new Quaternion(0, 0, -.7f, .7f);
                    break;
                case TimeOfDay.Night:
                    _arrow.rotation = new Quaternion(0, 0, -1, 0);
                    break;
            }
        }
    }

    private void Update()
    {

        if (_isActive)
        {
            Vector2 stickInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
            if (stickInput.magnitude < _deadZone)
                stickInput = Vector2.zero;
            else
            {
                if (!_isChanging)
                    TurnArrow(stickInput); 
            }
            //Debug.Log(_arrow.rotation);

            if (Input.GetButtonDown("B") && _isActive)
            {
                if (!_isChanging)
                {
                    _isActive = false;
                    CanvasGroup.alpha = 0;
                    Hud.Show();
                    MenuQuited?.Invoke();
                    ResetBrokenTime();
                }
            }
            if (Input.GetButtonDown("A"))
            {
                CheckTime();
            }
        }
    }

    private void ResetBrokenTime()
    {
        isBroken = false;
        brokenDay = false;
        brokenMorning = false;
        brokenNight = false;
        brokenNoon = false;
        _daySprite.gameObject.SetActive(true);
        _nightSprite.gameObject.SetActive(true);
        _morningSprite.gameObject.SetActive(true);
        _noonSprite.gameObject.SetActive(true);
    }

    private void CheckTime()
    {
        sound.Play("Transition");

        if (_arrowAngle > -45f && _arrowAngle <= 45f)
        {
            if (TimeSystem.actualTime != TimeOfDay.Day && !isBroken)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Day;
                StartCoroutine(_timeManager.ChangeTimeV2());
                CanvasGroup.alpha = 0;
            }
        }
        else if (_arrowAngle > 45f && _arrowAngle <= 135f)
        {
            if (TimeSystem.actualTime != TimeOfDay.Morning && !isBroken)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Morning;
                StartCoroutine(_timeManager.ChangeTimeV2());
                CanvasGroup.alpha = 0;
            }
        }
        else if (_arrowAngle > 135f || _arrowAngle <= -135f)
        {
            if (TimeSystem.actualTime != TimeOfDay.Night && !isBroken)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Night;
                StartCoroutine(_timeManager.ChangeTimeV2());
                CanvasGroup.alpha = 0;
            }
        }
        else
        {
            if (TimeSystem.actualTime != TimeOfDay.Noon && !isBroken)
            {
                _isChanging = true;
                _timeManager.targetTime = TimeOfDay.Noon;
                StartCoroutine(_timeManager.ChangeTimeV2());
                CanvasGroup.alpha = 0;
            }
        }
    }


    public void TurnArrow(Vector2 stickInput)
    {

        float horizontal = stickInput.x;
        float vertical = stickInput.y;
        

        Vector3 aim = new Vector3(horizontal, vertical, 0f);
        _arrowAngle = (Mathf.Atan2(aim.y, aim.x) * Mathf.Rad2Deg) - 90f;

        _arrow.rotation = Quaternion.AngleAxis(_arrowAngle, Vector3.forward);

    }
}
