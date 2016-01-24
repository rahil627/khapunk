package com.khapunk.fx.programs ;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.math.FastVector2;
import kha.Shaders;

/**
 * ...
 * @author Sidar Talei
 */
class CRT extends PipelineState
{

	var resolution:ConstantLocation;
	var resvec:FastVector2;
	var graphic:Graphics;
	
	public function new() 
	{
		super();
		
		
		
		vertexShader = Shaders.non_color_vertex_vert;
		fragmentShader = Shaders.crt_scanlines_frag;
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		inputLayout = [structure];
		
		compile();
		
		resolution = getConstantLocation("resolution");
		
		resvec = new FastVector2();
		
	}
	
	public function setGraphic(?g:Graphics) : Void {
		graphic = g;
	}
	
	
	public function setResolution(x:Float, y:Float) : Void {
		if (graphic == null) return;
		resvec.x = x;
		resvec.y = y;
		graphic.setVector2(resolution, resvec);
	}
	
}