using UnityEngine;

public class PublicAccessor : MonoBehaviour
{
	[SerializeField] int _someInt;

	public int ReadableInt { get { return _someInt; } }
}