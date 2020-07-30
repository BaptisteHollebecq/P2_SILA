using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSnow : MonoBehaviour
{
    [SerializeField]
    private GameObject _player;

    private Shader _snowShader;

    [SerializeField]
    private GameObject[] _terrain;

    [SerializeField]
    private Material[] _snowMaterial;

    [SerializeField]
    private float SnowCameraHeight;

    [SerializeField]
    private GameObject _snowTracksParticle_L;
    [SerializeField]
    private GameObject _snowTracksParticle_R;
    [SerializeField]
    private GameObject _snowDashTracksParticle;

    [ContextMenu("Get Every _ground ")]
    void FindGameObjectWithTags()
    {
        _terrain = GameObject.FindGameObjectsWithTag("Ground");


    }
    // Start is called before the first frame update
    void Start()
    {
        
        for (int i = 0; i < _terrain.Length; i++)
        {
            _snowMaterial[i] = _terrain[i].GetComponent<MeshRenderer>().material;
            

        }
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 playerpositiontemp = _player.transform.position;
        playerpositiontemp.y += SnowCameraHeight;
        transform.position = playerpositiontemp;
        Vector2 playerPos = new Vector2(-transform.position.x, -transform.position.z);

        for (int i = 0; i < _terrain.Length; i++)
        {
            _snowMaterial[i].SetVector("_PositionPlayer", playerPos);


        }

        if (TimeSystem._transitionSlide > 0.9f)
        {
            _snowTracksParticle_L.active = false;
            _snowTracksParticle_R.active = false;
            _snowDashTracksParticle.active = false;
        }
        else
        {
            _snowTracksParticle_L.active = true;
            _snowTracksParticle_R.active = true;
            _snowDashTracksParticle.active = true;
        }

    }
}
