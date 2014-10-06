package com.khapunk.graphics.primitives;

import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Program;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Loader;
import kha.math.Vector3;
import kha.Sys;



class Geometry {

	public var vertexBuffer:VertexBuffer;
	public var indexBuffer:IndexBuffer;
    public var vertices:Array<Float>;
    public var indices:Array<Int>;

    public var aabbMin:Vector3;
	public var aabbMax:Vector3;
	public var size:Vector3;

	var data:Array<Float>;
	var ids:Array<Int>;
	static var structure:VertexStructure;
	public static var meshProgram:Program;
	public var usage:Usage;

	var structSize:Int = 0;
	
	public function new(data:Array<Float>, indices:Array<Int>, usage:Usage = null) {

		if (usage == null) usage = Usage.StaticUsage;

		this.data = data;
		this.ids = indices;
		this.usage = usage;
	}

	public function build() {
		
		if(structure == null){
			
			structure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float2);
			structure.add("normalPosition", VertexData.Float3);
			structure.add("vertexColor", VertexData.Float4);
			
			structSize = 12;
			
			meshProgram = new Program();
			meshProgram.setFragmentShader(new FragmentShader(Loader.the.getShader("mesh.frag")));
			meshProgram.setVertexShader(new VertexShader(Loader.the.getShader("mesh.vert")));
			
			meshProgram.link(structure);
			
		}
		
		vertexBuffer = new VertexBuffer(Std.int(data.length / structSize),
													   structure, usage);
		vertices = vertexBuffer.lock();
	
		for (i in 0...vertices.length) {
			vertices[i] = data[i];
		}
		vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(ids.length, Usage.StaticUsage);
		this.indices = indexBuffer.lock();
		
		for (i in 0...this.indices.length) {
			this.indices[i] = ids[i];
		}
		indexBuffer.unlock();
		
		calculateAABB();
	}

	function calculateAABB() {

		aabbMin = new Vector3(-0.1, -0.1, -0.1);
		aabbMax = new Vector3(0.1, 0.1, 0.1);
		size = new Vector3();

		var i:Int = 0;
		while (i < vertices.length) {

			if (vertices[i] > aabbMax.x)		aabbMax.x = vertices[i];
			if (vertices[i + 1] > aabbMax.y)	aabbMax.y = vertices[i + 1];
			if (vertices[i + 2] > aabbMax.z)	aabbMax.z = vertices[i + 2];

			if (vertices[i] < aabbMin.x)		aabbMin.x = vertices[i];
			if (vertices[i + 1] < aabbMin.y)	aabbMin.y = vertices[i + 1];
			if (vertices[i + 2] < aabbMin.z)	aabbMin.z = vertices[i + 2];

			i += structSize;
		}

		size.x = Math.abs(aabbMin.x) + Math.abs(aabbMax.x);
		size.y = Math.abs(aabbMin.y) + Math.abs(aabbMax.y);
		size.z = Math.abs(aabbMin.z) + Math.abs(aabbMax.z);
	}

	public function getVerticesCount():Int {
		return Std.int(vertices.length / structSize);
	}
}