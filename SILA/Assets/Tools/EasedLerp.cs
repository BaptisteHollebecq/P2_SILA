namespace RSTools
{
	using UnityEngine;

	sealed class EasedLerp
	{
		/// <summary>
		/// Returns an eased value between 0 and 1. Ease amount shall most of the time be between 0 (no ease) and something like 2 or 3.
		/// (If used with an Unity lerp method, pass in the t parameter as x and the desired ease amount).
		/// </summary>
		public static float EaseLerp (float x, float easeAmount)
		{
			float a = Mathf.Clamp (easeAmount + 1, 0, float.MaxValue);
			float xPowA = Mathf.Pow (x, a);
			return xPowA / (xPowA + Mathf.Pow (1 - x, a));
		}
	}
}