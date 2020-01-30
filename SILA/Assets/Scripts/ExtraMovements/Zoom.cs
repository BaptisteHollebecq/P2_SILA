using System;
using UnityEngine;
using RSTools;

public enum ZoomAxis : byte
{
	X,
	Y,
	Z
}

public class Zoom : ExtraMovementCalculator
{
	[Serializable]
	public struct ZoomSettings
	{
		public ZoomAxis Axis;
		[Range (0, 0.5f)] public float Duration;
		public float Distance;
		[Range (0, 5)] public float Easing;
		public AnimationCurve Curve;

		public static ZoomSettings Default
		{
			get
			{
				return new ZoomSettings ()
				{
					Axis = ZoomAxis.Z,
					Duration = 0.15f,
					Distance = 0.4f,
					Easing = 1
				};
			}
		}
	}

	public float Duration { get; private set; }
	public ZoomSettings Settings { get; private set; }

	public Zoom ()
	{
		Settings = ZoomSettings.Default;
	}
	public Zoom (ZoomSettings settings)
	{
		Settings = settings;
	}

	public void Trigger ()
	{
		Duration = Settings.Duration;
	}
	public void SetSettings (ZoomSettings settings)
	{
		Settings = settings;
	}

	public override ExtraMovement CalculateExtraMovement (Transform transform)
	{
		if (Duration == 0)
			return null;

		var offsetPos = Vector3.zero;

		if (Settings.Axis == ZoomAxis.X)
			offsetPos += transform.right * Settings.Distance * Settings.Curve.Evaluate (EasedLerp.EaseLerp (Mathf.Lerp (0, 1, Duration / Settings.Duration), Settings.Easing));
		else if (Settings.Axis == ZoomAxis.Y)
			offsetPos += transform.up * Settings.Distance * Settings.Curve.Evaluate (EasedLerp.EaseLerp (Mathf.Lerp (0, 1, Duration / Settings.Duration), Settings.Easing));
		else if (Settings.Axis == ZoomAxis.Z)
			offsetPos += transform.forward * Settings.Distance * Settings.Curve.Evaluate (EasedLerp.EaseLerp (Mathf.Lerp (0, 1, Duration / Settings.Duration), Settings.Easing));

		Duration -= Time.deltaTime;
		if (Duration < 0)
			Duration = 0;

		return new ExtraMovement (offsetPos);
	}
}