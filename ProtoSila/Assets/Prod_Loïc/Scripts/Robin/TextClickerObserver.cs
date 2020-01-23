using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextClickerObserver : MonoBehaviour
{
	private void Awake()
	{
		TextClicker.TextClicked += OnTextClicked;
	}

	void OnTextClicked(string text)	
	{
		Debug.Log(text);
	}
}
