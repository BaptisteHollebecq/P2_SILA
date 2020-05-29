using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerLifeManager : MonoBehaviour
{
    public PlayerControllerV2 Player;
	public Animator PlayerAnimator;

    [SerializeField] private int _playerLife = 3;
    [HideInInspector] public int Life { get { return _playerLife; } }


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

	private void Start()
	{
		PlayerAnimator.GetComponent<Animator>();
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

        //Debug.Log("checkpoint === " + _checkPoint);
    }

    public void DeathWater()
    {
		PlayerAnimator.SetBool("", true);
        transform.position = _checkPoint;

        _playerLife = _maxlife;
    }
	public void DeathPikes()
	{
		PlayerAnimator.SetBool("", true);
		transform.position = _checkPoint;

		_playerLife = _maxlife;
	}
	public void DeathEnemy()
	{
		PlayerAnimator.SetBool("", true);
		transform.position = _checkPoint;

		_playerLife = _maxlife;
	}

	public void Respawn()
    {
        _playerLife--;
        if (_playerLife != 0)
            transform.position = _position;
        else
            DeathWater();
    }

    IEnumerator Timer()
    {
        yield return new WaitForSeconds(_actualise);
        _save = true;
    }


}
