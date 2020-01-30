using UnityEngine;

public class Stele : MonoBehaviour
{
	public static event System.Action<Transform> SteleInteracted;

	public Transform cameraPivotOnInteract;

	public void Interact ()
	{
		SteleInteracted?.Invoke(cameraPivotOnInteract);
	}
}