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
<<<<<<< HEAD
    private Material _drawMaterial;

    public GameObject[] terrain;
    private Material _snowMaterial;
=======
    private Material[] _drawMaterial = new Material[3];
    
    public GameObject[] terrain;
    private Material[] _snowMaterial = new Material[3];

	public List<GameObject> terrainRender = new List<GameObject>();
	SphereCollider sphereCollid;
	RaycastHit hitObject;
	public float checkRadius;
	public float maxDistance;
	public LayerMask whatIsRender;
>>>>>>> LD

    public Transform[] ObjectsTracing;
    RaycastHit _groundHit;
    int _layerMask;

    private GameObject tempgameobject;

    [Header("Properties")]
<<<<<<< HEAD
    [Range(1, 1500)]
=======
    [Range(1, 500)]
>>>>>>> LD
    public float brushSize;
    [Range(0, 10)]
    public float brushStrenght;
    // Start is called before the first frame update
<<<<<<< HEAD

    public Vector2 float0;

    public Vector3 tempCoordinates;

    PlayerController playercontroller;

    public Vector3 moveDirection;

    public SnowHeight snowHeight;

    [ContextMenu("Get Every _ground layer")]
=======
    [ContextMenu("Get Every _ground layer")]

    [ContextMenu("Je récup les layers sa meurse")]
>>>>>>> LD
    void FindGameObjectWithTags()
    {
        terrain = GameObject.FindGameObjectsWithTag("Ground");
    }
<<<<<<< HEAD

    void Start()
    {
        _layerMask = LayerMask.GetMask("Ground");


        _drawMaterial = new Material(drawShader);
        for (int i = 0; i < terrain.Length; i++)
        {
            _snowMaterial = terrain[i].GetComponent<MeshRenderer>().material;

        }

        _snowMaterial.SetTexture("_RenderTexture", _splatMap = new RenderTexture(2048, 2048, 0, RenderTextureFormat.ARGBFloat));

        playercontroller = GetComponentInParent<PlayerController>();

        //debug -   _snowMaterial[0].SetColor("_SnowColor", Color.red);
    }
=======
    void Start()
    {
        _layerMask = LayerMask.GetMask("Ground");
        

        for (int i = 0; i < terrain.Length; i++)
        {
            
            _drawMaterial[i] = new Material(drawShader);
            _snowMaterial[i] = terrain[i].GetComponent<MeshRenderer>().material;
            

>>>>>>> LD

            _snowMaterial[i].SetTexture("_Splat", _splatMap[i] = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));
        }

        _snowMaterial[0].SetColor("_SnowColor", Color.red);

		sphereCollid = GetComponent<SphereCollider>();

	}

	void Update()
    {
<<<<<<< HEAD
        Vector2 playerPos = new Vector2(-transform.position.x, -transform.position.z);
        
        _snowMaterial.SetVector("_PositionPlayer", playerPos);

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
            _snowMaterial.SetTexture("_RenderTexture", _splatMap = new RenderTexture(1024, 1024, 0, RenderTextureFormat.ARGBFloat));
=======
		sphereCollid.radius = checkRadius;

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
>>>>>>> LD
        }
    }

    private void OnGUI()
    {

        if (debug)
        {
            Debug.DrawRay(ObjectsTracing[0].position, Vector3.down, Color.red);
<<<<<<< HEAD
            GUI.DrawTexture(new Rect(0, 0, 256, 256), _splatMap, ScaleMode.ScaleToFit, false, 1);
=======
            GUI.DrawTexture(new Rect(0, 0, 256, 256), _splatMap[0], ScaleMode.ScaleToFit, false, 1);
            GUI.DrawTexture(new Rect(0, 280, 256, 256), _splatMap[1], ScaleMode.ScaleToFit, false, 1);
>>>>>>> LD

        }
    }

	void OnDrawGizmosSelected()
	{
		if(debug)
		{
			Gizmos.color = Color.red;
			Gizmos.DrawSphere(transform.position, checkRadius);
		}
	}
}

