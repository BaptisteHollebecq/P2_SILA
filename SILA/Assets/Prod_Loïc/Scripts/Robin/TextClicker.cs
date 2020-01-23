using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextClicker : MonoBehaviour
{
	public static event System.Action<string> TextClicked;

	public string myText;

	void Update()
	{
		if (Input.GetKeyDown(KeyCode.T))
			TextClicked?.Invoke(myText);
	}
}