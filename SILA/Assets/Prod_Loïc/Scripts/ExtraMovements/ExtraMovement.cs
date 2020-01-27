using UnityEngine;

public class ExtraMovement
{
	public readonly Vector3 ExtraPosition = Vector3.zero;
	public readonly Quaternion ExtraRotation = Quaternion.identity;

	public bool HasPosition { get { return ExtraPosition.x != 0 && ExtraPosition.y != 0 && ExtraPosition.z != 0; } }
	public bool HasRotation { get { return ExtraRotation.x != 0 && ExtraRotation.y != 0 && ExtraRotation.z != 0 && ExtraRotation.w != 0; } }

	public ExtraMovement (Vector3 extraPosition)
	{
		ExtraPosition = extraPosition;
	}
	public ExtraMovement (Quaternion extraRotation)
	{
		ExtraRotation = extraRotation;
	}
	public ExtraMovement (Vector3 extraPosition, Quaternion extraRotation)
	{
		ExtraPosition = extraPosition;
		ExtraRotation = extraRotation;
	}
}