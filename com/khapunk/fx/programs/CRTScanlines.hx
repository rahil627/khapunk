package com.khapunk.fx.programs ;
import kha.graphics4.ConstantLocation;
import kha.graphics4.FragmentShader;
import kha.graphics4.Graphics;
import kha.graphics4.Program;
import kha.graphics4.TextureUnit;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.Loader;
import kha.math.Vector2;

/**
 * ...
 * @author Sidar Talei
 */
class CRTScanlines extends Program
{

	var time:ConstantLocation;
	
	var resvec:Vector2;
	var graphic:Graphics;
	public function new() 
	{
		super();
		setVertexShader(new VertexShader(Loader.the.getShader("non-color-vertex.vert")));
		setFragmentShader(new FragmentShader(Loader.the.getShader("crt-scanlines.frag")));
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		link(structure);

		time = getConstantLocation("time");
		
		resvec = new Vector2();
		
	}
	
	public function setGraphic(?g:Graphics) : Void {
		graphic = g;
	}
	
	
	public function setTime(t:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(time, t);
	}
	
}