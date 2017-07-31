package com.khapunk.fx.programs;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Graphics;
import kha.graphics4.PipelineState;
import kha.graphics4.TextureUnit;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.math.FastVector2;
import kha.Shaders;

/**
 * ...
 * @author Sidar Talei
 */
class TubeEdgeNoise extends PipelineState
{

	var resolution:ConstantLocation;
	var time:ConstantLocation;
	var texture:TextureUnit;
	
	var graphic:Graphics;
	var resvec:FastVector2;
	
	public function new() 
	{
		super();
		vertexShader = Shaders.non_color_vertex_vert;
		//fragmentShader = Shaders.tube_edge_noise_frag;
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		inputLayout = [structure];
		
		compile();

		resolution = getConstantLocation("resolution");
		time = getConstantLocation("time");
		
		texture = getTextureUnit("tex");
		
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
	
	
	public function setTime(t:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(time, t);
	}
	
	
	public function setTextUnit(img:Image) : Void {
		if (graphic == null) return;
		graphic.setTexture(texture, img);
	}
	
	
	
	
}