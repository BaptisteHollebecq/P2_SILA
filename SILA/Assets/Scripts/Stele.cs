using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stele : MonoBehaviour
{
	public static event System.Action<Transform> SteleInteracted;

	public Transform cameraPivotOnInteract;
    public SpriteRenderer ySprite;
    public TimeMenu timeMenu;
    [Header("BrokenTime")]
    protected bool isBroken = false;
    protected int brokenPart = 0;
    [SerializeField] public bool brokenDay = false;
    [SerializeField] public bool brokenNight = false;
    [SerializeField] public bool brokenMorning = false;
    [SerializeField] public bool brokenNoon = false;

    protected PlayerLifeManager _respawn;

    private void Awake()
    {
        if (brokenDay || brokenMorning || brokenNight || brokenNoon)
            isBroken = true;

        TimeMenu.MenuDisplayed += HideBill;
        TimeMenu.MenuQuited += ShowBill;
    }

    private void OnDestroy()
    {
        TimeMenu.MenuDisplayed -= HideBill;
        TimeMenu.MenuQuited -= ShowBill;
    }
    protected void HideBill()
    {
        ySprite.gameObject.SetActive(false);
    }
    protected void ShowBill()
    {
        ySprite.gameObject.SetActive(true);
    }

    private void Update()
    {
        if (!brokenDay && !brokenNight && !brokenMorning && !brokenNoon)
            isBroken = false;
        if (brokenPart == 0)
            isBroken = false;
    }

    public void Interact ()
	{
        if (isBroken)
        {
            timeMenu.isBroken = true;
        }
		SteleInteracted?.Invoke(cameraPivotOnInteract);
        _respawn.CheckPoint();
	}


    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            ySprite.gameObject.SetActive(true);
            _respawn = collision.transform.GetComponent<PlayerLifeManager>();
        }
    }

    private void OnCollisionExit(Collision collision)
    {
        if (collision.transform.tag == "Player")
        {
            ySprite.gameObject.SetActive(false);
            _respawn = null;
        }
    }

    public virtual void Repair(GameObject obj)
    {

    }
}