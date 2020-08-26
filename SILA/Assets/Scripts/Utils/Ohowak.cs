using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Ohowak : MonoBehaviour
{
    public Sprite Ohowak1;
    public Sprite Ohowak2;
    public Sprite Ohowak3;
    public Sprite OhowakDead;
    public Sprite Cross;

    public float speed;

    [HideInInspector] public bool dead = false;
    [HideInInspector] public bool _isAlive = true;

    private Image _image;
    private Animator animator;

    private void Start()
    {
        animator = GetComponent<Animator>();
        _image = GetComponent<Image>();
        int x = Random.Range(0, 3);
        if (dead)
        {
            _image.sprite = OhowakDead;
            _isAlive = false;
        }
        else
        {
            switch (x)
            {
                case 0:
                    {
                        _image.sprite = Ohowak1;
                        break;
                    }
                case 1:
                    {
                        _image.sprite = Ohowak2;
                        break;
                    }
                case 2:
                    {
                        _image.sprite = Ohowak3;
                        break;
                    }
            }
        }
    }

    private void Update()
    {
        if (transform.localPosition.x > 1025)
            Destroy(gameObject);
    }

    private void FixedUpdate()
    {
        if (_isAlive)
        {
            transform.Translate(Vector3.right * speed);
        }
    }
    
    public void Kill()
    {
        _isAlive = false;
        animator.Play("DeathOhowak");
    }

    public void Death()
    {
        var inst = Instantiate(this.gameObject, new Vector3(0, 0, 0), Quaternion.identity);
        inst.transform.parent = transform.parent;
        inst.transform.localPosition = transform.localPosition;
        inst.GetComponent<Ohowak>().dead = true;
        Destroy(gameObject);
    }
}



