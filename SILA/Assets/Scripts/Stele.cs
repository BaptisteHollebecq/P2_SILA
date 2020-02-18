using UnityEngine;

public class Stele : MonoBehaviour
{
	public static event System.Action<Transform> SteleInteracted;

	public Transform cameraPivotOnInteract;
    public SpriteRenderer ySprite;

	public void Interact ()
	{
		SteleInteracted?.Invoke(cameraPivotOnInteract);
	}

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            ySprite.enabled = true;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            ySprite.enabled = false;
        }
    }
}