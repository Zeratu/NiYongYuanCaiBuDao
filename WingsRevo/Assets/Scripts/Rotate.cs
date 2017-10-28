using UnityEngine;
using System.Collections;
namespace HSCK
{


public class Rotate : MonoBehaviour {

	public float speed = 20; 

	public bool isParent = true;

	void Update () {

		if(isParent)
			transform.Rotate(new Vector3(0, 0, -Time.deltaTime*speed));
		else
			transform.RotateAround (transform.parent.position, transform.parent.forward, Time.deltaTime*speed);
	}
}

}
