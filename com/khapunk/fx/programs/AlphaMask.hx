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
class AlphaMask extends Program
{

	 
	var tex2:TextureUnit;
	var delta:ConstantLocation;
	var treshold:ConstantLocation;
	
	
	var graphic:Graphics;
	
	
	public function new() 
	{
		super();
		setVertexShader(new VertexShader(Loader.the.getShader("standard-vertex.vert")));
		setFragmentShader(new FragmentShader(Loader.the.getShader("alphamask.frag")));
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		link(structure);
		
		tex2 = getTextureUnit("tex2");
		delta = getConstantLocation("delta");
		treshold = getConstantLocation("treshold");
		
	}
	
	public function setGraphic(?g:Graphics) : Void {
		graphic = g;
	}
	
	public function setMaskTexture(value:Image) : Void {
		if (graphic == null) return;
		graphic.setTexture(tex2, value);
	}
	
	public function setDelta(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(delta, value);
	}
	
	public function setTreshold(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(treshold, value);
	}
	
	
	
}