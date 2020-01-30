public interface ICameraExtraMovement
{
	bool Enabled { get; }
	ExtraMovementCalculator Calculator { get; }

	ExtraMovement GetExtraMovement (UnityEngine.Transform transform);
}