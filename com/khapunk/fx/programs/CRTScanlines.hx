package com.khapunk.fx.programs ;
import kha.graphics4.ConstantLocation;
import kha.graphics4.FragmentShader;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.math.Vector2;
import kha.Shaders;

/**
 * ...
 * @author Sidar Talei
 */
class CRTScanlines extends PipelineState
{

	var time:ConstantLocation;
	
	var resvec:Vector2;
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