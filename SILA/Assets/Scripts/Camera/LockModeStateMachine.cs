public enum CameraLockState
{
	NA,
	Idle,
	Fight,
	Flight,
	Rail,
	LookAtPlayer,
	Eyes
}

public abstract class LockModeStateMachine : UnityEngine.MonoBehaviour
{
	protected CameraLockState LockState { get; private set; } = CameraLockState.NA;

	protected abstract void OnLockStateEnter ();
	protected abstract void OnLockStateExit ();

	protected void UpdateLockState (CameraLockState newLockState)
	{
		if (newLockState == LockState)
			return;
		OnLockStateExit ();
		LockState = newLockState;
		OnLockStateEnter ();
	}
}