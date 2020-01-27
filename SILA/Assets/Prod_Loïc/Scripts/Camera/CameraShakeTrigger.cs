public class CameraShakeTrigger : UnityEngine.MonoBehaviour
{
	public event System.Action<float> ShakeTriggered;

	public void TriggerShake (float trauma)
	{
		ShakeTriggered?.Invoke (trauma);
	}
}