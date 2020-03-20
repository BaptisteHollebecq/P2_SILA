using System.Collections.Generic;
using UnityEngine;
using ShakeSettings = Shake.ShakeSettings;

/// <summary>
/// Used to shake the camera. Monobehaviour shall be added on same gameObject as CameraMaster.
/// </summary>
public class CameraShake : MonoBehaviour, ICameraExtraMovement
{
	#region Variables

	int _shakeCountPerFrame = 0;

	public ExtraMovementCalculator Calculator { get; private set; }
	public Shake Shake { get { return Calculator as Shake; } }

	public bool Enabled { get; private set; }

	[SerializeField] bool _enabledOnAwake = true;
	[SerializeField] bool _getShakersOnAwake = false;

	[Space (5)]
	[SerializeField] ShakeSettings _shakeSettings = ShakeSettings.Default;
	[SerializeField] CameraShakeTrigger[] _shakers = null;

	[Space (5)]
	[SerializeField] bool _dividedOnSameFrame = true;

	#endregion

	#region Methods

	public ExtraMovement GetExtraMovement (Transform transform)
	{
		return Shake.CalculateExtraMovement (transform);
	}

	void ShakeCamera (float trauma)
	{
		_shakeCountPerFrame++;
		Shake.AddTrauma (trauma / (_dividedOnSameFrame ? _shakeCountPerFrame : 1));
	}

	[ContextMenu ("Find active Shakers")]
	void GetAllShakers ()
	{
		_shakers = FindObjectsOfType<CameraShakeTrigger> ();
		Debug.Log ($"(CameraShake) Located and added { _shakers.Length } shakers to array.");
	}

	void Awake ()
	{
		Calculator = new Shake (_shakeSettings);
		Enabled = _enabledOnAwake;

		if (_getShakersOnAwake)
			GetAllShakers ();
		foreach (CameraShakeTrigger shaker in _shakers)
			shaker.ShakeTriggered += ShakeCamera;
	}

	void LateUpdate ()
	{
		_shakeCountPerFrame = 0;
	}

	#endregion
}