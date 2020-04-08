using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDrawTracks : MonoBehaviour
{

    public bool debug;

    private RenderTexture _splatMap;
    [Header("Components")]
    public Shader drawShader;
    public Shader snowTrack_Shader;
    private Material _drawMaterial;

    public GameObject[] terrain;
    public Material[] _snowMaterial;

    public Transform[] ObjectsTracing;
    RaycastHit _groundHit;
    int _layerMask;

    private GameObject tempgameobject;

    [Header("Properties")]
    [Range(1, 1500)]
    public float brushSize;
    [Range(0, 10)]
    public float brushStrenght;
    // Start is called before the first frame update

    public Vector2 float0;

    public Vector3 tempCoordinates;

    PlayerController playercontroller;

    public Vector3 moveDirection;

    public SnowHeight snowHeight;

    [ContextMenu("Get Every _ground layer")]
    void FindGameObjectWithTags()
    {
        terrain = GameObject.FindGameObjectsWithTag("Ground");
        
        
    }

    void Start()
    {
        
        _layerMask = LayerMask.GetMask("Ground");


        _drawMaterial = new Material(drawShader);

        _splatMap = new RenderTexture(2048, 2048, 0, RenderTextureFormat.ARGBFloat);
        for (int i = 0; i < terrain.Length; i++)
        {
            _snowMaterial[i] = terrain[i].GetComponent<MeshRenderer>().material;
            _snowMaterial[i].SetTexture("_RenderTexture", _splatMap);

        }


        playercontroller = GetComponentInParent<PlayerController>();

        //debug -   _snowMaterial[0].SetColor("_SnowColor", Color.red);
    }

    // Update is called once per frame
    void Update()
    {
        Vector2 playerPos = new Vector2(-transform.position.x, -transform.position.z);

        for (int i = 0; i < terrain.Length; i++)
        {
            _snowMaterial[i].SetVector("_PositionPlayer", playerPos);

        }
        
       

        moveDirection = (transform.position - tempCoordinates) * 0.07f / 20;
        tempCoordinates = transform.position;

        for (int i = 0; i < ObjectsTracing.Length; i++)
        {

            if (Physics.Raycast(ObjectsTracing[i].position, Vector3.down, out _groundHit, 0.4f, _layerMask))
            {
                tempgameobject = _groundHit.transform.gameObject;

                //_drawMaterial[j].SetVector("_Coordinate", new Vector4(_groundHit.textureCoord.x,_groundHit.textureCoord.y, 0, 0));
                
                _drawMaterial.SetVector("_Center", new Vector4(0.5f, 0.5f, 0, 0));
                _drawMaterial.SetVector("_moveDirection", new Vector4(moveDirection.x, moveDirection.z, 0, 0));

                //Debug.Log(new Vector4(Mathf.InverseLerp(0, 1, playercontroller.moveDirection.x), Mathf.InverseLerp(0, 1, playercontroller.moveDirection.y), 0, 0));

                //tempCoordinates = _groundHit.textureCoord;

                _drawMaterial.SetFloat("Strenght", brushStrenght);
                _drawMaterial.SetFloat("Size", 100/brushSize);
                RenderTexture temp = RenderTexture.GetTemporary(_splatMap.width, _splatMap.height, 0, RenderTextureFormat.ARGBFloat);
                Graphics.Blit(_splatMap, temp);
                Graphics.Blit(temp, _splatMap, _drawMaterial);
                RenderTexture.ReleaseTemporary(temp);

            }
            else
            {
                _drawMaterial.SetFloat("Strenght", 0);
                _drawMaterial.SetVector("_moveDirection", new Vector4(moveDirection.x, moveDirection.z, 0, 0));
                RenderTexture temp = RenderTexture.GetTemporary(_splatMap.width, _splatMap.height, 0, RenderTextureFormat.ARGBFloat);
                Graphics.Blit(_splatMap, temp);
                Graphics.Blit(temp, _splatMap, _drawMaterial);
                RenderTexture.ReleaseTemporary(temp);
            }
            

        }

        if (TimeSystem.currentTime >= 0.24f && TimeSystem.currentTime <= 0.245f)
        {
            for (int i = 0; i < terrain.Length; i++)
            {
                _snowMaterial[i].SetTexture("_RenderTexture", _splatMap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));

            }
            
        }
    }

    private void OnGUI()
    {

        if (debug)
        {
            Debug.DrawRay(ObjectsTracing[0].position, Vector3.down * 5, Color.red);
            GUI.DrawTexture(new Rect(0, 0, 256, 256), _splatMap, ScaleMode.ScaleToFit, false, 1);

        }
    }
}

