using UnityEngine;

public class Stele : MonoBehaviour
{
	public static event System.Action<Transform> SteleInteracted;

	public Transform cameraPivotOnInteract;
    public SpriteRenderer ySprite;
    public TimeMenu timeMenu;
    [Header("BrokenTime")]
    private bool isBroken = false;
    [SerializeField] public bool brokenDay = false;
    [SerializeField] public bool brokenNight = false;
    [SerializeField] public bool brokenMorning = false;
    [SerializeField] public bool brokenNoon = false;

    private PlayerLifeManager _respawn;

    private void Awake()
    {
        if (brokenDay || brokenMorning || brokenNight || brokenNoon)
            isBroken = true;
    }


    private void Update()
    {
        if (!brokenDay && !brokenNight && !brokenMorning && !brokenNoon)
            isBroken = false;
    }

    public void Interact ()
	{
        if (isBroken)
        {
            timeMenu.isBroken = true;
            if (brokenDay)
                timeMenu.brokenDay = true;
            if (brokenNight)
                timeMenu.brokenNight = true;
            if (brokenMorning)
                timeMenu.brokenMorning = true;
            if (brokenNoon)
                timeMenu.brokenNoon = true;

        }
		SteleInteracted?.Invoke(cameraPivotOnInteract);
        _respawn.CheckPoint();
	}

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            ySprite.enabled = true;
            _respawn = other.GetComponent<PlayerLifeManager>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            ySprite.enabled = false;
            _respawn = null;
        }
    }
}