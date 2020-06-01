using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerLifeManager : MonoBehaviour
{
    public PlayerControllerV2 Player;
	public Animator Animator;

    [SerializeField] private int _playerLife = 3;
    [HideInInspector] public int Life { get { return _playerLife; } set { _playerLife = value; } }

    public float timingRespawn;
    private bool die = false;


    private int _maxlife;
    [HideInInspector] public int MaxLife { get { return _maxlife; } }

    [SerializeField] private float _actualise;

    private bool _save = true;
    private Vector3 _position;
    private Vector3 _checkPoint;

    private void Awake()
    {
        _checkPoint = Player.transform.position;
        _maxlife = _playerLife;
    }

	void Update()
    {
        if (_save)
        {
            if (Player.IsGrounded())
            {
                _position = transform.position;
                _save = false;
                StartCoroutine(Timer());
            }
        }
    }

    public void CheckPoint()
    {
        _checkPoint = Player.transform.position;
    }


    public void DeathWater()
    {
		Animator.SetBool("DeathWater", true);
        //bloquer les controller et jouer anim mort dans l'eau 
        Death();
    }

    public void DeathPykes()
    {
		Animator.SetBool("DeathPykes", true);
		//bloquer les controller et jouer l'anim de mort sur les piques
		Death();
    }


    public void Death()
    {    
        StartCoroutine(SwitchCanDie()); // a la fin de l acoroutine die=true et le jouer respawn
    }

    private IEnumerator SwitchCanDie()
    {
        yield return new WaitForSeconds(timingRespawn); // timingRespawn a modifier pour laisser le temsp a l'anim de se jouer
        Respawn();
    }

    public void Respawn()
    {
        _playerLife--;
        if (_playerLife != 0)
            transform.position = _position;
        else
        {
            _playerLife = _maxlife;
            transform.position = _checkPoint;
        }
        //rendre les controls au joueur qqpart par ici normalement
    }

    IEnumerator Timer()
    {
        yield return new WaitForSeconds(_actualise);
        _save = true;
    }


}
