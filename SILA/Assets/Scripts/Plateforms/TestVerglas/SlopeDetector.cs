using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SlopeDetector : MonoBehaviour
{
    private Vector3 _underPlayerPoint;
    private Vector3 _underPlayerNormal;
    private Collider _underPlayerCollider;

    [SerializeField] private float _checkDistance;

    private Vector3 _checkingPoint;

    private Vector3 _oneNormalPoint;

    [HideInInspector] public float slopeAngles;

    [HideInInspector] public Vector3 slopeDirection;

    [HideInInspector] public bool isOnSlope = false;

    [HideInInspector] public bool checkForSlope = false;

    public bool debugRayCast = true;


    private void Update()
    {
        if (checkForSlope)
        {
            CheckForSlops();
            Debug.Log(slopeAngles);
        }
    }

    void CheckForSlops()
    {
        RaycastHit hitUnderPlayer;
        RaycastHit hitCheckSlope;

        if (Physics.Raycast(transform.position, Vector3.down, out hitUnderPlayer))
        {
            _underPlayerPoint = hitUnderPlayer.point;
            _underPlayerNormal = hitUnderPlayer.normal;
            _underPlayerCollider = hitUnderPlayer.collider;

            _oneNormalPoint = _underPlayerPoint + (_underPlayerNormal.normalized * _checkDistance);

            Physics.Raycast(transform.position, _oneNormalPoint - transform.position, out hitCheckSlope);

            if (hitCheckSlope.collider == _underPlayerCollider)
                _checkingPoint = hitCheckSlope.point;
            else
                _checkingPoint = _underPlayerPoint;

            slopeDirection = ((_checkingPoint - _underPlayerPoint).normalized * 1);
            slopeAngles = Mathf.Abs(Vector3.Angle(Vector3.down, slopeDirection) - 90);

            if (slopeAngles <= 10)
                isOnSlope = false;
            else
                isOnSlope = true;
        }
    }

    private void OnDrawGizmos()
    {
        if (debugRayCast && checkForSlope)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawRay(transform.position, _underPlayerPoint - transform.position);

            if (isOnSlope)
            {
                Gizmos.color = Color.blue;
                Gizmos.DrawRay(_underPlayerPoint, _underPlayerNormal);

                Gizmos.color = Color.green;
                Gizmos.DrawRay(transform.position, _oneNormalPoint - transform.position);

                Gizmos.color = Color.black;
                Gizmos.DrawRay(_underPlayerPoint, slopeDirection);
            }
        }   
    }
}
