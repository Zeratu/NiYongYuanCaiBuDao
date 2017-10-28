using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CusMatrixUpdating : MonoBehaviour
{
    public int m_numberOfLines = 10;
    public Material[] lineRendererMat = null;
    public float m_speed = 1f;
    private Matrix4x4 _lastModelMatrix = Matrix4x4.identity;
    private Vector3 tempPosition = Vector3.zero;
    private Quaternion tempRotation = Quaternion.identity; 

    // Use this for initialization
    void Start()
    {
        tempPosition = transform.position;
        tempRotation = transform.rotation;
    }

    void Update()
    {
        Matrix4x4 curModelMatrix = Matrix4x4.TRS(transform.position, transform.rotation, Vector3.one);

        for (int i = 0; i < lineRendererMat.Length; i++)
        {
            lineRendererMat[i].SetMatrix("_CustomCurrentObject2World", curModelMatrix);
            lineRendererMat[i].SetMatrix("_CustomLastObject2World", _lastModelMatrix);
            lineRendererMat[i].SetFloat("_NumberOfLines", m_numberOfLines);
        }

        tempPosition = Vector3.Lerp(tempPosition, transform.position, Time.deltaTime * m_speed);
        tempRotation = Quaternion.Slerp(tempRotation, transform.rotation, Time.deltaTime * m_speed);
        _lastModelMatrix = Matrix4x4.TRS(tempPosition, tempRotation, Vector3.one);
    }
}
