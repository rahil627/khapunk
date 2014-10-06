package Shaders.programs ;
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
class Grain extends Program
{

	var resolution:ConstantLocation;
	var time:ConstantLocation;
	var texture:TextureUnit;
	
	var graphic:Graphics;
	var resvec:Vector2;
	
	public function new() 
	{
		super();
		setVertexShader(new VertexShader(Loader.the.getShader("non-color-vertex.vert")));
		setFragmentShader(new FragmentShader(Loader.the.getShader("grain.frag")));
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		link(structure);

		resolution = getConstantLocation("resolution");
		texture = getTextureUnit("tex");
		time = getConstantLocation("time");
		
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
	
	public function setTime(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(time, value);
	}
	
	public function setTextUnit(img:Image) : Void {
		if (graphic == null) return;
		graphic.setTexture(texture, img);
	}
	
}