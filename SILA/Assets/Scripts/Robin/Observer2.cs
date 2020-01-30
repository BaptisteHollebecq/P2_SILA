using UnityEngine;

public class Observer2 : MonoBehaviour
{
	public void PlaySound (AudioClip clip)
	{
		Debug.Log("Playing sound 2");
	}

	void Awake()
	{
		Milestone.Observable.SoundPlayed += PlaySound;
	}
}