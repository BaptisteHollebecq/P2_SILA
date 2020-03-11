using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowRegeneration : MonoBehaviour
{
    public Shader _snowRegenShader;
    private Material _snowRegenMat;
    private MeshRenderer _meshRenderer;
    [Range(0.001f, 0.1f)]
    public float _flakeAmount;
    [Range(0f, 1f)]
    public float _flakeOpacity;
    // Start is called before the first frame update
    void Start()
    {
        _meshRenderer = GetComponent<MeshRenderer>();
        _snowRegenMat = new Material(_snowRegenShader);
    }

    // Update is called once per frame
    void Update()
    {
        _snowRegenMat.SetFloat("_FlakeAmount", _flakeAmount);
        _snowRegenMat.SetFloat("_FlakeOpacity", _flakeOpacity);
        RenderTexture snow = (RenderTexture)_meshRenderer.material.GetTexture("_RenderTexture");
        RenderTexture temp = RenderTexture.GetTemporary(snow.width, snow.height, 0, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(snow, temp, _snowRegenMat);
        Graphics.Blit(temp, snow);
        _meshRenderer.material.SetTexture("_Splat", snow);
        RenderTexture.ReleaseTemporary(temp);
    }
}
