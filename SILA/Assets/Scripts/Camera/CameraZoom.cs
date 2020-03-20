using UnityEngine;
using ZoomSettings = Zoom.ZoomSettings;

public class CameraZoom : MonoBehaviour, ICameraExtraMovement
{
	#region Variables

	public ExtraMovementCalculator Calculator { get; private set; }
	public Zoom Zoom { get { return Calculator as Zoom; } }

	public bool Enabled { get; private set; }

	[SerializeField] bool _enabledOnAwake = true;
	[SerializeField] bool _getZoomersOnAwake = false;

	[Space (5)]
	[SerializeField] ZoomSettings _zoomSettings = ZoomSettings.Default;
	[SerializeField] CameraZoomTrigger[] _zoomers = null;

	#endregion

	#region Methods

	public ExtraMovement GetExtraMovement (Transform transform)
	{
		return Zoom.CalculateExtraMovement (transform);
	}

	void ZoomCamera ()
	{
		Zoom.Trigger ();
	}

	[ContextMenu ("Find active Zoomers")]
	void GetAllZoomers ()
	{
		_zoomers = FindObjectsOfType<CameraZoomTrigger> ();
		Debug.Log ($"(CameraShake) Located and added { _zoomers.Length } shakers to array.");
	}

	void Awake ()
	{
		Calculator = new Zoom (_zoomSettings);
		Enabled = _enabledOnAwake;

		if (_getZoomersOnAwake)
			GetAllZoomers ();
		foreach (CameraZoomTrigger zoomer in _zoomers)
			zoomer.ZoomTriggered += ZoomCamera;
	}

	#endregion
}