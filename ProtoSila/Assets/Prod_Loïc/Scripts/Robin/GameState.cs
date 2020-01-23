using Test;
using Milestone;

public static class GameState
{
	public static event System.Action<State> StateEntered;
	public static event System.Action<State> StateExit;

	public enum State
	{
		MainMenu,
		Pause,
		Play,
		CraftMenu,
		CraftMenuTutorial
	}

	public static State CurrentState;

	public static void ChangeState (State state)
	{
		// warning
		StateExit(CurrentState);
		CurrentState = state;
		StateEntered(CurrentState);
	}
}