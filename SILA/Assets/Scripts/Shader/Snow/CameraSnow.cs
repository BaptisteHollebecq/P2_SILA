using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSnow : MonoBehaviour
{
    [SerializeField]
    private GameObject _player;

    private Shader _snowShader;

    [SerializeField]
    private GameObject _terrain;

    private Material _snowMaterial;

    [SerializeField]
    private float SnowCameraHeight;
    // Start is called before the first frame update
    void Start()
    {
        
        _snowMaterial = _terrain.GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 playerpositiontemp = _player.transform.position;
        playerpositiontemp.y += SnowCameraHeight;
        transform.position = playerpositiontemp;
        Vector2 playerPos = new Vector2(-transform.position.x, -transform.position.z);
        _snowMaterial.SetVector("_PositionPlayer", playerPos);
    }
}
