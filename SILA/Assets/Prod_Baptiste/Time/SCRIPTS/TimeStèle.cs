using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimeStèle : MonoBehaviour
{
    [Header("Camera Settings")]
    [SerializeField] private bool _debug = false;
    [SerializeField] private Transform _cameraTarget;
    [SerializeField] private float _cameraHighness = 1f;
    [SerializeField] private float _cameraDistance = 1f;
    private Vector3 _cameraPosition;

    [SerializeField] private bool _isActive; // hide it when finish
    [SerializeField] private float _transition = 3f;
    private Vector3 _oldCameraPosition = Vector3.zero;
    private Quaternion _oldCameraRotation = Quaternion.identity;

    private void Start()
    {

    }

    private void Update()
    {
        if (_isActive)
        {
            if (_oldCameraPosition == Vector3.zero && _oldCameraRotation == Quaternion.identity)
            {
                _oldCameraPosition = Camera.main.transform.position;
                _oldCameraRotation = Camera.main.transform.rotation;
            }
            if (Camera.main.transform.position != _cameraPosition && Camera.main.transform.rotation != )
                Camera.main.transform.position = Vector3.Lerp(Camera.main.transform.position, _cameraPosition, _transition*Time.deltaTime);

        }
        else
        {
            if (_oldCameraPosition != Vector3.zero && Vector3.Distance(Camera.main.transform.position, _oldCameraPosition) > 0.05f)
                Camera.main.transform.position = Vector3.Lerp(Camera.main.transform.position, _oldCameraPosition, _transition*Time.deltaTime);
            else
                _oldCameraPosition = Vector3.zero;
        }
        Debug.Log(_oldCameraPosition);
    }

    private void OnDrawGizmos()
    {
        Vector3 _test = new Vector3(transform.position.x, _cameraTarget.position.y, transform.position.z);
        _cameraPosition = ((_cameraTarget.position - _test) * -1);
        Vector2 _tmp = new Vector2(_cameraPosition.x, _cameraPosition.z).normalized;
        _cameraPosition = new Vector3(_tmp.x, _cameraPosition.y+_cameraHighness, _tmp.y);
        _cameraPosition *= _cameraDistance;

        if (_debug)
        {
            // Draws a blue line from this transform to the target
            Gizmos.color = Color.red;
            Gizmos.DrawLine(_cameraPosition, _cameraTarget.position);
            Gizmos.DrawIcon(_cameraPosition, "camera_icon", true);

        }
    }
}
