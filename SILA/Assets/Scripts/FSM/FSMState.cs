using System.Collections.Generic;
using UnityEngine;

public abstract class FSMState
{
	protected Dictionary<Transition, StateID> Map = new Dictionary<Transition, StateID> ();
	public StateID ID { get; protected set; }

	public void AddTransition (Transition transition, StateID id)
	{
		if (transition == Transition.NullTransition)
		{
			Debug.LogWarning ("(FSMState) NullTransition isn't allowed for a real transition.");
			return;
		}

		if (id == StateID.NullStateID)
		{
			Debug.LogWarning ("(FSMState) NullStateID isn't allowed for a real ID.");
			return;
		}

		if (Map.ContainsKey (transition))
		{
			Debug.LogWarning ("(FSMState) State " + ID.ToString () + " already has transition " + transition.ToString () + ". Impossible to assign to another state");
			return;
		}

		Map.Add (transition, id);
	}

	public void DeleteTransition (Transition transition)
	{
		if (transition == Transition.NullTransition)
		{
			Debug.LogWarning ("(FSMState) NullTransition isn't allowed.");
			return;
		}

		if (Map.ContainsKey (transition))
		{
			Map.Remove (transition);
			return;
		}

		Debug.LogWarning ("(FSMState) Transition " + transition.ToString () + " passed to " + ID.ToString () + " wasn't on the state's transition list.");
	}

	public StateID GetOutputState (Transition transition)
	{
		return Map.ContainsKey (transition) ? Map[transition] : StateID.NullStateID;
	}

	public virtual void DoBeforeEntering () { }
	public virtual void DoBeforeLeaving () { }

	public abstract void Reason ();
	public abstract void Act ();

	public virtual void FixedReason() { }
	public virtual void FixedAct() { }
}
