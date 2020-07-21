using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUDCollectible : MonoBehaviour
{
    public Transform jauge;
    public Transform cursor;
    public Text CollectibleNumber;

    public Color valided;

    public HUDInGame hud;
    private PlayerCollectibles _collectibles;

    private void Awake()
    {
        _collectibles = hud._collectibles;
    }

    private void Update()
    {
        int collectible = _collectibles.GetCollectibles();

        CollectibleNumber.text = collectible.ToString();

        float pourcentage = Mathf.FloorToInt((collectible * 100) / _collectibles.maxCollec);
        if (pourcentage > 100)
            pourcentage = 100;
        float posYCursor = -220 + (320 * (pourcentage/100));

        cursor.localPosition = new Vector3(cursor.localPosition.x, posYCursor, cursor.localPosition.z);

        float scaleYJauge = 1 * (pourcentage / 100);
        jauge.localScale = new Vector3(jauge.localScale.x, scaleYJauge, jauge.localScale.z);

        if (pourcentage > 80)
        {
            jauge.GetComponent<Image>().color = valided;
        }

    }
}
