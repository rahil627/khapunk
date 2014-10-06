package com.khapunk.graphics.primitives;

/**
 * ...
 * @author Sidar Talei
 */
class Triangle extends Geometry
{

	public function new(size:Float) {

		 

		var vertices = [
			 
			-size,-size, 0.0,
			size, -size, 0.0,
			0.0, size, 0.0
		];

		var uvs = [
			 
			0, 0,
			1, 1
		];

		var normals = [
			0, 0, 1,
			0, 0, 1,
			0, 0, 1
		];

		var indices = [0,1,2];


		var data:Array<Float> = new Array();
		
		data.push(vertices[0]);
		data.push(vertices[1]);
		data.push(vertices[2]);
		data.push(uvs[0]);
		data.push(uvs[1]);
		data.push(normals[0]);
		data.push(normals[1]);
		data.push(normals[2]);		

    	super(data, indices);
	}
}