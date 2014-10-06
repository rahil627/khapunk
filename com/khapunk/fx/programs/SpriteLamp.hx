package Shaders.programs ;
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
import kha.math.Matrix3;
import kha.math.Matrix4;
import kha.math.Vector2;
import kha.math.Vector3;

/**
 * ...
 * @author Sidar Talei
 */
class SpriteLamp extends Program
{

	var celLevel:ConstantLocation;
	var shininess:ConstantLocation;
	var wrapAroundLevel:ConstantLocation;
	var aoStrength:ConstantLocation;
	var emissiveStrength:ConstantLocation;

	var amplifyDepth:ConstantLocation;
	var upperAmbientColour:ConstantLocation;
	var lowerAmbientColour:ConstantLocation;
	var lights:ConstantLocation;
	var lightCount:ConstantLocation;
	var resolution:ConstantLocation;
	var position:ConstantLocation;
	var rotationMatrix:ConstantLocation;
	var lightPos:ConstantLocation;
	var lightColour:ConstantLocation;
	
	var graphic:Graphics;
	
	var normalDepthMap:TextureUnit;
	var specGlossMap:TextureUnit;
	var aoMap:TextureUnit;
	var emissiveMap:TextureUnit;
	
	var resvec:Vector2;
	
	public function new() 
	{
		super();
		setVertexShader(new VertexShader(Loader.the.getShader("sprite-lamp.vert")));
		setFragmentShader(new FragmentShader(Loader.the.getShader("sprite-lamp.frag")));
		
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
		link(structure);
		
		
		position 		=  getConstantLocation("position");
		rotationMatrix 	=  getConstantLocation("rotationMatrix");
		
		lightPos = getConstantLocation("lightPos");
		lightColour = getConstantLocation("lightColour");
		
		normalDepthMap 	= getTextureUnit("normalDepthMap");
		specGlossMap 	= getTextureUnit("specGlossMap");
		aoMap 			= getTextureUnit("aoMap");
		emissiveMap 	= getTextureUnit("emissiveMap");
		
		celLevel 		= getConstantLocation("celLevel");
		shininess 		= getConstantLocation("shininess");
		wrapAroundLevel = getConstantLocation("wrapAroundLevel");
		aoStrength 		= getConstantLocation("aoStrength");
		emissiveStrength = getConstantLocation("emissiveStrength");
		amplifyDepth 	= getConstantLocation("amplifyDepth");
		
		upperAmbientColour = getConstantLocation("upperAmbientColour");
		lowerAmbientColour = getConstantLocation("lowerAmbientColour");
			
		resolution 		= getConstantLocation("resolution");
		
		lightCount 		= getConstantLocation("lightCount");
		

	
		
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
	
	public function setCelLevel(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(celLevel, value);
	}
	
	public function setShininess(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(shininess, value);
	}
	
	public function setWrapAroundLevel(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(wrapAroundLevel, value);
	}
	public function setAOStrength(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(aoStrength, value);
	}	
	
	public function setEmissiveStrength(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(emissiveStrength, value);
	}	
	
	public function setAmplifyDepth(value:Float) : Void {
		if (graphic == null) return;
		graphic.setFloat(amplifyDepth, value);
	}	
	
	public function setUpperAmbientColour(value:Vector3) : Void {
		if (graphic == null) return;
		graphic.setVector3(upperAmbientColour, value);
	}
	
	public function setLowerAmbientColour(value:Vector3) : Void {
		if (graphic == null) return;
		graphic.setVector3(lowerAmbientColour, value);
	}

	
	public function setLightColor(index:Int, value:Vector3) : Void
	{
		if (graphic == null) return;
		graphic.setVector3(lightColour, value);
	}
	
	public function setLightPos(index:Int, value:Vector3) : Void
	{
		if (graphic == null) return;
		graphic.setVector3(lightPos, value);
	}
	
	
	public function setLightCount(value:Int) : Void
	{
		if (graphic == null) return;
		graphic.setInt(lightCount, value);
	}
	
	public function setRotationMatrix(value:Matrix4) : Void
	{
		if (graphic == null) return;
		graphic.setMatrix(rotationMatrix, value);
	}
	
	public function setPosition(value:Vector3) : Void {
		if (graphic == null) return;
		graphic.setVector3(position, value);
	}
	
	public function setNormalMap(value:Image) : Void
	{
		if (graphic == null) return;
		graphic.setTexture(normalDepthMap, value);
	}
	
	public function setSpecMap(value:Image) : Void
	{
		if (graphic == null) return;
		graphic.setTexture(specGlossMap, value);
	}
	
	public function setEmissiveMap(value:Image) : Void
	{
		if (graphic == null) return;
		graphic.setTexture(emissiveMap, value);
	}
	
		
	public function setAOMap(value:Image) : Void
	{
		if (graphic == null) return;
		graphic.setTexture(aoMap, value);
	}

	
}