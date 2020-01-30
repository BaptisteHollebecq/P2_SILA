using UnityEngine;

[CreateAssetMenu (fileName = "SO_CameraBehaviour_[NAME]", menuName = "Camera Behaviour")]
public class CameraBehaviour : ScriptableObject, System.ICloneable
{
	public float Height;
	public float MaxDistance;
	public int MinPitch;
	public int MaxPitch;
	public Vector3 LocalOffset;
	public Vector3 LocalRotation;
	public Vector2 Sensitivity;
	public float RotationDamping;
	public float DistanceDamping;
	public LayerMask CollisionMask;
	public CameraBlendSettings BlendOnEnter;

	/// <summary>
	/// Must NEVER be used in code (it only exists for editor purpose).
	/// </summary>
	public void Reset ()
	{
		Height = 1.5f;
		MaxDistance = 1.5f;
		MinPitch = 0;
		MaxPitch = 0;
		LocalOffset = Vector3.zero;
		LocalRotation = Vector3.zero;
		Sensitivity = Vector2.one;
		RotationDamping = 0.3f;
		DistanceDamping = 0.8f;
		CollisionMask = 0;
		BlendOnEnter = null;
	}

	public override string ToString () { return name; }

	public object Clone ()
	{
		var clone = CreateInstance<CameraBehaviour> ();

		clone.Height = this.Height;
		clone.MaxDistance = this.MaxDistance;
		clone.MinPitch = this.MinPitch;
		clone.MaxPitch = this.MaxPitch;
		clone.LocalOffset = this.LocalOffset;
		clone.LocalRotation = this.LocalRotation;
		clone.Sensitivity = this.Sensitivity;
		clone.RotationDamping = this.RotationDamping;
		clone.DistanceDamping = this.DistanceDamping;
		clone.CollisionMask = this.CollisionMask;
		clone.BlendOnEnter = this.BlendOnEnter;

		return clone;
	}
}