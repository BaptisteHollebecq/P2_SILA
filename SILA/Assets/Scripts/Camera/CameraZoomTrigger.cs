public class CameraZoomTrigger : UnityEngine.MonoBehaviour
{
	public event System.Action ZoomTriggered;

	public void TriggerZoom ()
	{
		ZoomTriggered?.Invoke ();
	}
}