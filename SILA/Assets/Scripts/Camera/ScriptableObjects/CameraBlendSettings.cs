using UnityEngine;

[CreateAssetMenu (fileName = "SO_CameraBlendSettings_[NAME]", menuName = "Camera Blend Settings")]
public class CameraBlendSettings : ScriptableObject, System.ICloneable
{
	[Range (0, 5)] public float Duration = 0.5f;
	[Range (0, 3)] public float Easing = 1;
	[Range (0, 10)] public float WaitBeforeBlend = 0;
	public bool Priority = true;

	public static CameraBlendSettings Default
	{
		get
		{
			CameraBlendSettings defaultBlendSettings = CreateInstance ("CameraBlendSettings") as CameraBlendSettings;
			defaultBlendSettings.Reset ();
			return defaultBlendSettings;
		}
	}

	/// <summary>
	/// Must NEVER be used in code (it only exists for editor purpose).
	/// </summary>
	public void Reset ()
	{
		Duration = 0.5f;
		Easing = 1;
		WaitBeforeBlend = 0;
		Priority = true;
	}

	public override string ToString () { return name; }

	public object Clone ()
	{
		var clone = CreateInstance<CameraBlendSettings> ();

		clone.Duration = this.Duration;
		clone.Easing = this.Easing;
		clone.WaitBeforeBlend = this.WaitBeforeBlend;
		clone.Priority = this.Priority;

		return clone;
	}
}