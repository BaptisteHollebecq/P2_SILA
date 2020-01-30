namespace Milestone
{
	using UnityEngine;

	public class Observable : MonoBehaviour
	{
		public static event System.Action FootStepped;
		public static event System.Action<AudioClip> SoundPlayed;

		void Update()
		{
			if (Input.GetKeyDown(KeyCode.R))
			{
				// Play sound foot step
				FootStepped?.Invoke();
				Debug.Log("test");
			}
		}
	}
}

namespace Test
{

	using UnityEngine;

	public class Observable : MonoBehaviour
	{
		public static event System.Action FootStepped;
		public static event System.Action<AudioClip> SoundPlayed;

		void Update()
		{
			if (Input.GetKeyDown(KeyCode.R))
			{
				// Play sound foot step
				FootStepped?.Invoke();
				Debug.Log("test");
			}
		}
	}
}