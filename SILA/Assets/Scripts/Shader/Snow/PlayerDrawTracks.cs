using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerDrawTracks : MonoBehaviour
{

    public bool debug;

    



    private RenderTexture[] _splatMap = new RenderTexture[3];
    [Header("Components")]
    public Shader drawShader;
    public Shader snowTrack_Shader;
    private Material[] _drawMaterial = new Material[3];
    
    public GameObject[] terrain;
    private Material[] _snowMaterial = new Material[3];

    public Transform[] ObjectsTracing;
    RaycastHit _groundHit;
    int _layerMask;

    private GameObject tempgameobject;

    [Header("Properties")]
    [Range(1, 500)]
    public float brushSize;
    [Range(0, 1)]
    public float brushStrenght;
    // Start is called before the first frame update
    [ContextMenu("Get Every _ground layer")]

    [ContextMenu("Je récup les layers sa meurse")]
    void FindGameObjectWithTags()
    {
        terrain = GameObject.FindGameObjectsWithTag("Ground");
    }
    void Start()
    {
        _layerMask = LayerMask.GetMask("Ground");
        

        for (int i = 0; i < terrain.Length; i++)
        {
            
            _drawMaterial[i] = new Material(drawShader);
            _snowMaterial[i] = terrain[i].GetComponent<MeshRenderer>().material;
            


            _snowMaterial[i].SetTexture("_Splat", _splatMap[i] = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));
        }

        _snowMaterial[0].SetColor("_SnowColor", Color.red);
    }

    // Update is called once per frame
    void Update()
    {
        
        

        for (int j = 0; j < terrain.Length; j++)
        {
            for (int i = 0; i < ObjectsTracing.Length; i++)
            {

                if (Physics.Raycast(ObjectsTracing[i].position, Vector3.down, out _groundHit, 1f, _layerMask))
                {
                    tempgameobject = _groundHit.transform.gameObject;
                    if (terrain[j] == tempgameobject)
                    {
                        _drawMaterial[j].SetVector("_Coordinate", new Vector4(_groundHit.textureCoord.x, _groundHit.textureCoord.y, 0, 0));
                        _drawMaterial[j].SetFloat("Strenght", brushStrenght);
                        _drawMaterial[j].SetFloat("Size", brushSize);
                        RenderTexture temp = RenderTexture.GetTemporary(_splatMap[j].width, _splatMap[j].height, 0, RenderTextureFormat.ARGBFloat);
                        Graphics.Blit(_splatMap[j], temp);
                        Graphics.Blit(temp, _splatMap[j], _drawMaterial[j]);
                        RenderTexture.ReleaseTemporary(temp);

                    }
                    


                }
            }

        }


    }

    private void OnGUI()
    {

        if (debug)
        {
            Debug.DrawRay(ObjectsTracing[0].position, Vector3.down, Color.red);
            GUI.DrawTexture(new Rect(0, 0, 256, 256), _splatMap[0], ScaleMode.ScaleToFit, false, 1);
            GUI.DrawTexture(new Rect(0, 280, 256, 256), _splatMap[1], ScaleMode.ScaleToFit, false, 1);

        }
    }
}

