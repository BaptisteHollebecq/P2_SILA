using UnityEngine;

public class Stele : MonoBehaviour
{
	public static event System.Action<Transform> SteleInteracted;

	public Transform cameraPivotOnInteract;
    public SpriteRenderer ySprite;

    private PlayerRespawn _respawn;

	public void Interact ()
	{
		SteleInteracted?.Invoke(cameraPivotOnInteract);
        _respawn.CheckPoint();
	}

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            ySprite.enabled = true;
            _respawn = other.GetComponent<PlayerRespawn>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Player")
        {
            ySprite.enabled = false;
            _respawn = null;
        }
    }
}