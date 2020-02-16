using System;
using System.Collections;
using UnityEngine;
using EasedLerp = RSTools.EasedLerp;

public class CameraMaster : LockModeStateMachine
{
	#region Variables

	public static event Action MovedToPivot;

    ICameraExtraMovement[] _extraMovements;
	Camera m_Camera;
	Transform m_Transform;
	float _mouseX;
	float _mouseY;

	Vector3[] _corners;
	float _xRotation;
	float _yRotation;
	float _currentDistance;
	Vector3 _currentPosition;
	Quaternion _currentRotation;

	float _runTimer;
	float _noRunTimer;

	[Header ("TARGET")]
	[SerializeField] Transform _target = null;

	Transform _lookAtPivot;

	#region Behaviour Settings

	float _height;
	float _maxDistance;
	Vector3 _localOffset;
	Vector3 _localRotation;
	float _lastHeight;
	float _lastMaxDistance;
	Vector3 _lastLocalOffset;
	Vector3 _lastLocalRotation;

	bool _isTransitingBehaviours = false;
	IEnumerator _behavioursTransitionCoroutine;

	bool _isMovingToPivot = false;
	[SerializeField] float _moveToPivotDuration = 1;

	CameraBehaviour _behaviour;
	public CameraBehaviour Behaviour
	{
		get { return _behaviour; }
		private set
		{
			if (value == null)
				return;
			if (_behaviour == value)
				return;

			var awake = _behaviour == null;
			_behaviour = value;

			if (_isTransitingBehaviours)
			{
				RegisterTransitionValues ();
				StopCoroutine (_behavioursTransitionCoroutine);
			}

			_behavioursTransitionCoroutine = TransitionToBehaviour (_behaviour, awake);
			StartCoroutine (_behavioursTransitionCoroutine);
		}
	}

	[Header ("BEHAVIOURS ARRAY")]
	[SerializeField] CameraBehaviour[] _behaviours = null;

	#endregion

	[Header ("DEBUG")]
	public bool ShowDebug = false;

	#endregion

	#region Initialization

	void Initialize ()
	{
		_corners = new Vector3[4]
		{
			new Vector3 (0, 0),
			new Vector3 (0, 1),
			new Vector3 (1, 0),
			new Vector3 (1, 1)
		};

		m_Transform = transform;
		m_Camera = GetComponentInChildren<Camera> ();
		_extraMovements = GetComponents<ICameraExtraMovement> ();
		Behaviour = _behaviours[0];

		Pto_PlayerController.PlayerStateChanged += UpdateLockState;
		Stele.SteleInteracted += SetCameraLookPivot;

		UpdateLockState (CameraLockState.Idle);
	}

	#endregion

	#region Lock Mode State Machine

	protected override void OnLockStateEnter ()
	{
		switch (LockState)
		{
			case CameraLockState.Idle:
				Behaviour = _behaviours[0];
				break;

			case CameraLockState.Fight:
				Behaviour = _behaviours[1];
				break;

			case CameraLockState.Flight:
				Behaviour = _behaviours[2];
				break;

			case CameraLockState.Eyes:
				Behaviour = _behaviours[3];
				break;
		}
	}

	protected override void OnLockStateExit ()
	{
		switch (LockState)
		{
			case CameraLockState.LookAtPlayer:
				_lookAtPivot = null;
				_isMovingToPivot = false;
				break;
		}
	}

	IEnumerator TransitionToBehaviour (CameraBehaviour newBehaviour, bool awake = false)
	{
		if (ShowDebug)
		{
			Debug.Log ("(Camera Master) Blending behaviors.");
			if (!newBehaviour.BlendOnEnter)
				Debug.Log ("No blend settings, using Default");
		}

		if (awake)
		{
			SetNewBehaviourValues (newBehaviour);
			yield break;
		}

		CameraBlendSettings blend = newBehaviour.BlendOnEnter ? newBehaviour.BlendOnEnter : CameraBlendSettings.Default;

		_isTransitingBehaviours = true;

		for (float f = 0; f < 1; f += Time.deltaTime / blend.Duration)
		{
			_height = Mathf.Lerp (_lastHeight, newBehaviour.Height, EasedLerp.EaseLerp (f, blend.Easing));
			_maxDistance = Mathf.Lerp (_lastMaxDistance, newBehaviour.MaxDistance, EasedLerp.EaseLerp (f, blend.Easing));
			_localOffset = Vector3.Lerp (_lastLocalOffset, newBehaviour.LocalOffset, EasedLerp.EaseLerp (f, blend.Easing));
			_localRotation = Vector3.Lerp (_lastLocalRotation, newBehaviour.LocalRotation, EasedLerp.EaseLerp (f, blend.Easing));

            yield return null;
        }

		SetNewBehaviourValues (newBehaviour);
		_isTransitingBehaviours = false;
	}
			
	void SetNewBehaviourValues (CameraBehaviour newBehaviour)
	{
		_height = newBehaviour.Height;
		_maxDistance = newBehaviour.MaxDistance;
		_localOffset = newBehaviour.LocalOffset;
		_localRotation = newBehaviour.LocalRotation;

		RegisterTransitionValues ();
	}

	void RegisterTransitionValues ()
	{
		_lastHeight = _height;
		_lastMaxDistance = _maxDistance;
		_lastLocalOffset = _localOffset;
		_lastLocalRotation = _localRotation;
	}

	#endregion

	#region Positionning

	void Recenter ()
	{
		ResetRotation ();
		Rotate (_target.localEulerAngles.x, _target.localEulerAngles.y);
	}
	void ResetPosition ()
	{
		_currentPosition = _target.position;
	}
	void ResetRotation ()
	{
		Rotate (-_xRotation, -_yRotation);
	}

	void Rotate (float x, float y)
	{
		_xRotation -= x;
		_yRotation += y;
		_xRotation = Mathf.Clamp (_xRotation, Behaviour.MinPitch, Behaviour.MaxPitch);
	}

	void GoToPivotPosition ()
	{
		_currentPosition += Vector3.up * _height;
		m_Transform.position = Vector3.Lerp (m_Transform.position, _currentPosition, 0.85f);
	}

	void GoToRotation ()
	{
		_currentRotation = Quaternion.Euler (_xRotation, _yRotation, 0);
		m_Transform.rotation = Quaternion.Lerp (m_Transform.rotation, _currentRotation, Behaviour.RotationDamping);
	}

	void GoBack ()
	{
		_currentDistance = Mathf.Lerp (_currentDistance, GetCollisionDistance (), Behaviour.DistanceDamping);
		m_Transform.position -= m_Transform.forward * _currentDistance;
	}

	float GetCollisionDistance ()
	{
		for (int i = 0; i < _corners.Length; i++)
		{
			if (ShowDebug)
				Debug.DrawRay (m_Camera.ViewportToWorldPoint (_corners[i]), -m_Transform.forward, Color.yellow);
			if (Physics.Raycast (m_Camera.ViewportToWorldPoint (_corners[i]), -m_Transform.forward, out RaycastHit hit, _maxDistance, Behaviour.CollisionMask))
				return hit.distance;
		}

		return _maxDistance;
	}

	void ApplyLocalOffset ()
	{
		m_Transform.position += m_Transform.TransformDirection (_localOffset);
	}

	/// <summary>
	/// Requires the actual camera to be in a child gameObject.
	/// </summary>
	void ApplyLocalRotation ()
	{
		m_Camera.transform.localEulerAngles = _localRotation;
	}

	void ApplyExtraMovements ()
	{
		if (_extraMovements == null || _extraMovements.Length == 0)
			return;

		foreach (ICameraExtraMovement extraMovement in _extraMovements)
		{
			if (!extraMovement.Enabled)
				continue;

			ExtraMovement movement = extraMovement.GetExtraMovement (m_Transform);

			if (movement == null) continue;
			if (movement.HasPosition) m_Transform.position += movement.ExtraPosition;
			if (movement.HasRotation) m_Transform.rotation *= movement.ExtraRotation;
		}
	}

	#endregion

	void UpdateCameraPosition ()
	{
		switch (LockState)
		{
			case CameraLockState.Idle:

			case CameraLockState.Flight:
				_mouseX = Input.GetAxis ("HorizontalCamera") * Behaviour.Sensitivity.x;
				_mouseY = Input.GetAxis("VerticalCamera") * Behaviour.Sensitivity.y;
				if (_mouseX != 0 || _mouseY != 0)
					Rotate (_mouseY, _mouseX);
				break;

			case CameraLockState.Fight:
				Recenter();
				break;

			case CameraLockState.Rail:
				// transform.position = RailController.GetPoint ().position;
				return;

			case CameraLockState.LookAtPlayer:
				//Debug.Log(_lookAtPivot);
				if (!_isMovingToPivot)
					StartCoroutine(MoveToPivot());
				return;

			case CameraLockState.Eyes:
				_mouseX = Input.GetAxis("HorizontalCamera") * Behaviour.Sensitivity.x;
				_mouseY = Input.GetAxis("VerticalCamera") * Behaviour.Sensitivity.y;
				if (_mouseX != 0 || _mouseY != 0)
					Rotate(_mouseY, _mouseX);
				break;
		}

		ResetPosition ();
		GoToPivotPosition ();
		GoToRotation ();
		GoBack ();

		ApplyLocalOffset ();
		ApplyLocalRotation ();
		ApplyExtraMovements ();
	}

	IEnumerator MoveToPivot ()
	{
		_isMovingToPivot = true;
		var initPos = m_Transform.position;
		var initRot = m_Transform.rotation;

		for (float f = 0; f < 1; f += Time.deltaTime / _moveToPivotDuration)
		{
			var lerp = EasedLerp.EaseLerp(f, 1);
			m_Transform.position = Vector3.Lerp(initPos, _lookAtPivot.position, lerp);
			m_Transform.rotation = Quaternion.Lerp(initRot, _lookAtPivot.rotation, lerp);
			yield return null;
		}

		m_Transform.position = _lookAtPivot.position;
		m_Transform.rotation = _lookAtPivot.rotation;

		MovedToPivot?.Invoke ();
	}

    void UpdateOutOfFightBehaviours ()
	{

	}

	void SetCameraLookPivot (Transform pivot)
	{
		_lookAtPivot = pivot;
		UpdateLockState(CameraLockState.LookAtPlayer);
	}

	void Awake ()
	{
		Initialize ();
	}

	void Update ()
	{
		UpdateOutOfFightBehaviours ();
	}

	void FixedUpdate ()
	{
		UpdateCameraPosition ();
	}
}
