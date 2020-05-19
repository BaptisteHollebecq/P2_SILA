using UnityEngine;

public class Stele : MonoBehaviour
{
	public static event System.Action<Transform> SteleInteracted;

	public Transform cameraPivotOnInteract;
    public SpriteRenderer ySprite;
    public TimeMenu timeMenu;
    [Header("BrokenTime")]
    private bool isBroken = false;
    [SerializeField] private bool brokenDay = false;
    [SerializeField] private bool brokenNight = false;
    [SerializeField] private bool brokenMorning = false;
    [SerializeField] private bool brokenNoon = false;

    private PlayerLifeManager _respawn;

    private void Awake()
    {
        if (brokenDay || brokenMorning || brokenNight || brokenNoon)
            isBroken = true;
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