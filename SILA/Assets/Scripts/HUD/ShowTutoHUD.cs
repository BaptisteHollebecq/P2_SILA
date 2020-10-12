using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShowTutoHUD : MonoBehaviour
{
    public static event System.Action<string> EnteredZoneShow;

    public string tutoText;
    public SoundManager sound;

    public float emissiveValue = 20;
    public float fadeDuration = 1;
    private Material mat;

    private bool _used = false;

    private void Awake()
    {
        mat = GetComponent<Renderer>().material;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player" && !_used)
        {
            _used = true;
            EnteredZoneShow?.Invoke(tutoText);
            sound.Play("tuto");
            StartCoroutine(Fade(mat.GetFloat("_EmissiveInt"), emissiveValue, fadeDuration));
        }
    }
    IEnumerator Fade(float start, float end, float duration)
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
}
