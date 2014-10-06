package com.khapunk.fx.programs ;
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
class Convolution extends Program
{

 
	var resolution:ConstantLocation;
	var kernel:ConstantLocation;
	var texture:TextureUnit;
	var resvec:Vector2;
	
	var division:ConstantLocation;
	var bias:ConstantLocation;
	
	var graphic:Graphics;

	
	public function new() 
	{
		super();
		setVertexShader(new VertexShader(Loader.the.getShader("standard-vertex.vert")));
		setFragmentShader(new FragmentShader(Loader.the.getShader("convolution.frag")));
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		link(structure);
		
		resolution = getConstantLocation("resolution");
		kernel = getConstantLocation("kernel");
		texture = getTextureUnit("tex");
		
		division = getConstantLocation("division");
		bias = getConstantLocation("bias");
		
		resvec = new Vector2();
		
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
	
	public function setTextUnit(img:Image) : Void {
		if (graphic == null) return;
		graphic.setTexture(texture, img);
	}
	
	public function setKernel(kernel:Array<Float>) {
		if (graphic == null) return;
		graphic.setFloats(this.kernel, kernel);
	}
	
	public function setDivision(div:Float) {
		if (graphic == null) return;
		graphic.setFloat(division, div);
	}
	
	public function setBias(bias:Float) {
		if (graphic == null) return;
		graphic.setFloat(this.bias, bias);
	}
	
	
}