using UnityEngine;

public enum CoordinateAxes : byte
{
	X = 1,
	Y = 2,
	Z = 4,
	XY = X | Y,
	XZ = X | Z,
	YZ = Y | Z,
	XYZ = X | Y | Z
}

public class Shake : ExtraMovementCalculator
{
	[System.Serializable]
	public struct ShakeSettings
	{
		public CoordinateAxes PosAxes;
		public CoordinateAxes RotAxes;
		public float Speed;
		public float Radius;
		public float XRotMax;
		public float YRotMax;
		public float ZRotMax;

		public static ShakeSettings Default
		{
			get
			{
				return new ShakeSettings ()
				{
					PosAxes = CoordinateAxes.XY,
					RotAxes = CoordinateAxes.XYZ,
					Speed = 15,
					Radius = 0.3f,
					XRotMax = 15,
					YRotMax = 15,
					ZRotMax = 15
				};
			}
		}
	}

	public float Trauma { get; private set; }
	public ShakeSettings Settings { get; private set; }

	public Shake ()
	{
		Settings = ShakeSettings.Default;
	}
	public Shake (ShakeSettings settings)
	{
		Settings = settings;
	}

	public void SetSettings (ShakeSettings settings)
	{
		Settings = settings;
	}
	public void SetTrauma (float newTrauma)
	{
		Trauma = Mathf.Clamp01 (newTrauma);
	}
	public void AddTrauma (float newTrauma)
	{
		Trauma = Mathf.Clamp01 (Trauma + newTrauma);
	}

	public override ExtraMovement CalculateExtraMovement (Transform transform)
	{
		if (Trauma == 0)
			return null;

		var offsetPos = Vector3.zero;

		if ((Settings.PosAxes & CoordinateAxes.X) == CoordinateAxes.X)
			offsetPos += transform.right * (Mathf.PerlinNoise (Time.time * Settings.Speed, 0) - 0.5f) * 2;
		if ((Settings.PosAxes & CoordinateAxes.Y) == CoordinateAxes.Y)
			offsetPos += transform.up * (Mathf.PerlinNoise (0, (Time.time + 5) * Settings.Speed) - 0.5f) * 2;
		if ((Settings.PosAxes & CoordinateAxes.Z) == CoordinateAxes.Z)
			offsetPos += transform.forward * (Mathf.PerlinNoise (0, (Time.time + 10) * Settings.Speed) - 0.5f) * 2;

		var sqrTrauma = Trauma * Trauma;
		offsetPos *= Settings.Radius * sqrTrauma;

		var offsetRot = Quaternion.Euler (
				(Settings.RotAxes & CoordinateAxes.X) != CoordinateAxes.X ? 0 : (Mathf.PerlinNoise (Time.time * Settings.Speed, 0) - 0.5f) * 2 * Settings.XRotMax * sqrTrauma,
				(Settings.RotAxes & CoordinateAxes.Y) != CoordinateAxes.Y ? 0 : (Mathf.PerlinNoise (Time.time * Settings.Speed + 2, 0) - 0.5f) * 2 * Settings.YRotMax * sqrTrauma,
				(Settings.RotAxes & CoordinateAxes.Z) != CoordinateAxes.Z ? 0 : (Mathf.PerlinNoise (Time.time * Settings.Speed + 4, 0) - 0.5f) * 2 * Settings.ZRotMax * sqrTrauma);

		Trauma -= Time.deltaTime;
		if (Trauma < 0)
			Trauma = 0;

		return new ExtraMovement (offsetPos, offsetRot);
	}
}