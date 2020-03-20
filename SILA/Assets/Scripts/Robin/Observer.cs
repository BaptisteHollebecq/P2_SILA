using UnityEngine;

public class Observer : MonoBehaviour
{
	public Transform pos;

	public bool showDebug;

	void PlayFootStepSound ()
	{
		// ici ajouter condition pv
		Debug.Log("Playing sound");
		transform.position = pos.position;
	}

	void Awake ()
	{
		if (pos != null)
			Debug.LogWarning("(Observer) pos is null");

		//Observable.FootStepped += PlayFootStepSound;
		// add feedback
	}
}