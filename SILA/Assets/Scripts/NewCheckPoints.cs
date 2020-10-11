using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewCheckPoints : MonoBehaviour
{
    public float emissiveValue = 20;
    public float fadeDuration = 1;

    private PlayerLifeManager _life;
    private Material mat;

    private void Awake()
    {
        mat = GetComponent<Renderer>().material;
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Player")
        {
            _life = other.GetComponent<PlayerLifeManager>();
            if (_life.Player.isGrounded)
            {
                _life._position = other.transform.position;
                StartCoroutine(Fade(mat.GetFloat("_EmissiveInt"), emissiveValue, fadeDuration));
            }

           
        }
    }

    IEnumerator Fade(float start,float end, float duration)
    {
        float t = 0;
        float emissive = start;

        mat.SetFloat("_EmissiveInt", start);

        while (t < duration)
        {
            t += Time.fixedDeltaTime;
            float blend = Mathf.Clamp01(t / duration);

            emissive = Mathf.Lerp(start, end, blend);

            mat.SetFloat("_EmissiveInt", emissive);


            yield return new WaitForEndOfFrame();
        }
        mat.SetFloat("_EmissiveInt", end);
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            _life = null;
        }
    }

}
