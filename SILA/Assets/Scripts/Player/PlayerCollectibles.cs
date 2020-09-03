using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerCollectibles : MonoBehaviour
{
    private int _collectibles = 0;
    private int _maskCollectibles = 0;
    private PlayerLifeManager _life;

    public DontDestroyCollectibles save;

    public HUDMap hud;
    [HideInInspector] public int maxCollec = 0;

    private AudioSource _source;
    public AudioClip take;

    [HideInInspector] public int repair = 0;

    private bool _change = false;
    private int soundNumber = 0;
    public List<AudioClip> sounds = new List<AudioClip>();

    private void Awake()
    {
        _source = GetComponent<AudioSource>();
        _life = GetComponent<PlayerLifeManager>();

        foreach(Zone z in hud._zones)
        {
            maxCollec += z._collectibles;
        }
    }

    private void Update()
    {
        if (_maskCollectibles == 3 && !_change)
        {
            _change = true;
            StartCoroutine(Reset());
        }
    }

    IEnumerator Reset()
    {
        yield return new WaitForSeconds(1.5f);
        _maskCollectibles = 0;
        _life.MaxLife += 1;
        _life.Life += _life.MaxLife;

        soundNumber = 0;

        _change = false;
    }

    public void AddCollectibles(int nbr)
    {
        _collectibles+=nbr;
        _life.ShowJauge();
        _source.PlayOneShot(take);
    }

    public void AddMask(int nbr)
    {
        _maskCollectibles += nbr;

        _source.PlayOneShot(sounds[soundNumber]);
        soundNumber++;

    }



    public int GetCollectibles()
    {
        return _collectibles;
    }

    private void OnDestroy()
    {
        save.collectiblesCount = _collectibles;
        save.maxCollectiblesCount = maxCollec;
    }

    public int GetMask()
    {
        return _maskCollectibles;
    }
}
