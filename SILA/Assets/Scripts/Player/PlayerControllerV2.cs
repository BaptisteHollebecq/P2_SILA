
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Rigidbody))]
public class PlayerControllerV2 : MonoBehaviour
{ 
    
	[Header("Setup Manuel")]
	public Animator animator;
	public GameObject player;
	public Camera camera;
	public GameObject feet;
	public PlayerLifeManager lifeManager;

	public Rigidbody _playerRb { get; private set; }

	Collider _collider;
	PlayerControllerV2 _scriptOnPlayer;
	FSMSystem _fsm;

	//public Collider c { get { return _collider; } }
	[SerializeField]
	StateID _currentStateID;

    public SoundManager sound;

	[HideInInspector]
	public float speedStore;

	[HideInInspector]
	public bool isGrounded;
	[HideInInspector]
	public bool isOnMap;
	[HideInInspector]
	public bool canDash;
	[HideInInspector]
	public float dashTimer;

    [Header("Particle System")]
    [SerializeField]
    private ParticleSystem _stepParticle_L;
    [SerializeField]
    private ParticleSystem _stepParticle_R;
    [SerializeField]
    private float _fieldOfView = 60;

    [Header("Player")]
	public float moveSpeed;
	public float airSpeed;
	public float jumpForce;
	public float dashSpeed;
	public float dashDuration;
	public float dashReset;
	public float flySpeed;
	public float flyGravityScale;
	public float jumpGravity;
	public float smoothTime;
	public float gravityScale;
	public float lowerJumpFall;
	public float airRotation;
	public float groundedRotation;
	public float jumpBufferTimer;
	public float jumpWallTimer;
	public LayerMask whatIsGround;
	public LayerMask whatIsSnow;
	public float maxAngle;
	public Transform transformRotator;

	float _distToGround;
    bool _isGrounded;
    //float speedStore;

    //VARIABLE WIND INERTIE
    private Vector3 windDirection;
    private float windForce;
    private float initialWindForce;
    private float windDuration;
    private bool activeWind;

    [HideInInspector]
    public bool onstele = false;
    [HideInInspector]
    public Stele zeStele;
	[HideInInspector]
	public bool NearRessources = false;
	[HideInInspector]
	public bool harvesting = false;

	public static bool inverted = false;
    [HideInInspector] public bool onG = false;

    public void SetTransition(Transition t) { _fsm.PerformTransition(t); }
	public void Start()
	{
		lifeManager = GetComponent<PlayerLifeManager>();
		_playerRb = GetComponent<Rigidbody>();
		_scriptOnPlayer = GetComponent<PlayerControllerV2>();
		_collider = GetComponent<Collider>();
		speedStore = moveSpeed;
		_distToGround = _collider.bounds.extents.y - 0.8f;
		dashTimer = dashReset + 1;
		MakeFSM();
        
    }
	private void Update()
	{
        if (!isOnMap)
        {
            _fsm.CurrentState.Reason();
            _fsm.CurrentState.Act();
        }
        
		_currentStateID = _fsm.CurrentID;

		isGrounded = IsGrounded();
        if (isGrounded == true)
            activeWind = false;


        if (dashTimer > dashReset && isGrounded)
		{
			canDash = true;
		}

		if(canDash == false)
		{
			DashReset();
		}
    }


    private void FixedUpdate()
    {
		if (!isOnMap)
		{
			_fsm.CurrentState.FixedReason();	
			_fsm.CurrentState.FixedAct();		
		}										
												
		if (activeWind)							
        {										
            Debug.Log("inertie wind");			
            _playerRb.AddForce(windDirection * windForce);
            windForce -= (initialWindForce * Time.fixedDeltaTime) / windDuration;
            if (windForce <= 0)
                activeWind = false;
        }

        camera.fieldOfView = _fieldOfView;
    }

    public void StepSound()
    {
        int rand = Random.Range(0, 9);
        string step = "step";
        step += rand.ToString();
        sound.Play(step);
    }
	public void StepSoundSnow()
	{
		int rand = Random.Range(0, 9);
		string step = "step";
		step += rand.ToString();
		sound.Play(step);

		_stepParticle_L.Emit(100);
		_stepParticle_R.Emit(100);

	}

	public void WindInertie(Vector3 direction , float force, float duration)
    {
        windDirection = direction;
        windForce = force;
        initialWindForce = force;
        windDuration = duration;
        activeWind = true;
    }

	public void DashReset()
	{
		dashTimer += Time.deltaTime;
		if (dashTimer > dashReset)
			dashTimer = dashReset + 1;
	}

	public bool IsGrounded()
	{
		return Physics.Raycast(player.transform.position, -Vector3.up, _distToGround + 0.12f, whatIsGround);
	}

    public IEnumerator EndIsOnMap()
    {
        yield return new WaitForSeconds(0.05f);
        isOnMap = false;
    }

	private void MakeFSM()
	{
		BasicState basicState = new BasicState(player, _scriptOnPlayer, player.transform, camera, _collider, whatIsGround, animator, whatIsSnow);
		basicState.AddTransition(Transition.Dashing, StateID.Dash);
		basicState.AddTransition(Transition.Death, StateID.Death);
		basicState.AddTransition(Transition.Stele, StateID.OnStele);
		basicState.AddTransition(Transition.Zooming, StateID.Zoom);
		basicState.AddTransition(Transition.Flying, StateID.Fly);

		DashState dashState = new DashState(_playerRb, _scriptOnPlayer, player.transform, camera, animator);
		dashState.AddTransition(Transition.Basic, StateID.Basic);
		dashState.AddTransition(Transition.Death, StateID.Death);
		dashState.AddTransition(Transition.Flying, StateID.Fly);

		FlyState flyState = new FlyState(_playerRb, _scriptOnPlayer, player.transform, camera, _collider, whatIsGround, animator, transformRotator);
		flyState.AddTransition(Transition.Basic, StateID.Basic);
		flyState.AddTransition(Transition.Death, StateID.Death);
		flyState.AddTransition(Transition.Dashing, StateID.Dash);

		DeathState fallState = new DeathState(_scriptOnPlayer);
		fallState.AddTransition(Transition.Basic, StateID.Basic);

		OnSteleState steleState = new OnSteleState(_scriptOnPlayer, player, animator);
		steleState.AddTransition(Transition.Basic, StateID.Basic);

		ZoomState zoomState = new ZoomState(_playerRb, _scriptOnPlayer, player);
		zoomState.AddTransition(Transition.Basic, StateID.Basic);




		_fsm = new FSMSystem();
		_fsm.AddState(basicState);
		_fsm.AddState(dashState);
		_fsm.AddState(flyState);
		_fsm.AddState(fallState);
		_fsm.AddState(steleState);
		_fsm.AddState(zoomState);
	}

}
