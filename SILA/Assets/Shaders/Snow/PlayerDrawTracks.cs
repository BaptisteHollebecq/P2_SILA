using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDrawTracks : MonoBehaviour
{

    public bool debug;

    private RenderTexture _splatMap;
    [Header("Components")]
    public Shader drawShader;
    private Material _drawMaterial;
    private Material _snowMaterial;
    public GameObject terrain;
    public Transform Character;
    RaycastHit _groundHit;
    int _layerMask;

    [Header("Properties")]
    [Range(1, 500)]
    public float brushSize;
    [Range(0, 1)]
    public float brushStrenght;
    // Start is called before the first frame update
    void Start()
    {
        _layerMask = LayerMask.GetMask("Ground");
        _drawMaterial = new Material(drawShader);

        _snowMaterial = terrain.GetComponent<MeshRenderer>().material;

        _snowMaterial.SetTexture("_Splat", _splatMap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));
    }

    // Update is called once per frame
    void Update()
    {
        if (Physics.Raycast(Character.position, Vector3.down, out _groundHit, 1f, _layerMask))
        {
            _drawMaterial.SetVector("_Coordinate", new Vector4(_groundHit.textureCoord.x, _groundHit.textureCoord.y, 0, 0));
            _drawMaterial.SetFloat("Strenght", brushStrenght);
            _drawMaterial.SetFloat("Size", brushSize);
            RenderTexture temp = RenderTexture.GetTemporary(_splatMap.width, _splatMap.height, 0, RenderTextureFormat.ARGBFloat);
            Graphics.Blit(_splatMap, temp);
            Graphics.Blit(temp, _splatMap, _drawMaterial);
            RenderTexture.ReleaseTemporary(temp);
        }
    }

    private void OnGUI()
    {
        if (debug)
        {
            GUI.DrawTexture(new Rect(0, 0, 256, 256), _splatMap, ScaleMode.ScaleToFit, false, 1);

        }
    }
}
