package com.khapunk.fx.programs;
import kha.Image;
import kha.graphics4.ConstantLocation;
import kha.graphics4.FragmentShader;
import kha.graphics4.Graphics;
import kha.graphics4.Program;
import kha.graphics4.TextureUnit;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Loader;
import kha.math.Vector2;

/**
 * ...
 * @author Sidar Talei
 */
class CrossStitch extends Program
{

	 
	var stitchSize:ConstantLocation;
	var resolution:ConstantLocation;
	var invert:ConstantLocation;
	
	
	var graphic:Graphics;
	var resvec:Vector2;
	
	public function new() 
	{
		super();
		setVertexShader(new VertexShader(Loader.the.getShader("non-color-vertex.vert")));
		setFragmentShader(new FragmentShader(Loader.the.getShader("cross-stitching.frag")));
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		link(structure);
		
		stitchSize = getConstantLocation("stitching_size");
		invert = getConstantLocation("invert");
		resolution = getConstantLocation("resolution");
		
		resvec = new Vector2();
		
	}
	
	public function setGraphic(?g:Graphics) : Void {
		graphic = g;
	}
	
	public function setSize(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(stitchSize, value);
	}
	
	public function setInvert(value:Bool) : Void {
		if (graphic == null) return;
		graphic.setInt(invert, value ? 1:0);
	}
	
	public function setResolution(x:Float, y:Float) : Void {
		if (graphic == null) return;
		resvec.x = x;
		resvec.y = y;
		graphic.setVector2(resolution, resvec);
	}
	
	
	
}