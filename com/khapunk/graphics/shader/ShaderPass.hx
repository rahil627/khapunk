package com.khapunk.graphics.shader;
import kha.Canvas;
import kha.Color;
import kha.graphics4.BlendingOperation;
import kha.graphics4.Program;
import kha.graphics4.TextureFormat;
import kha.Image;

/**
 * ...
 * @author Sidar Talei
 */
class ShaderPass
{

	var programs:Array<Program>;
	var shaderConstants:Array<ShaderConstants>;
	var sampleSource:Array<Bool>;
	var _blend:Bool = false;
	
	public var sourceBlend:BlendingOperation;
	public var destinationBlend:BlendingOperation;
	
	static var buffer:Image;
	static var bufferB:Image;
	
	public function new() {
		sourceBlend = BlendingOperation.SourceAlpha;
		destinationBlend = BlendingOperation.BlendOne;
		
		if (buffer == null) {
			buffer = Image.createRenderTarget(KP.width, KP.height,TextureFormat.RGBA32);
			bufferB = Image.createRenderTarget(KP.width, KP.height,TextureFormat.RGBA32);
		}
		
	}
	
	public static function resize(w:Int, h:Int) : Void {
		//buffer.unload();
		//bufferB.unload();
		
		//buffer = Image.createRenderTarget(w, h);
		//bufferB = Image.createRenderTarget(w, h);
	}
	
	public function Count() {
		if (programs == null)  return 0;
		return programs.length;
	}
	
	/**
	 * Sets the properties containing the shader programs and their constants.
	 * @param	Array<Program>
	 * @param	Array<Canvas>
	 * @param	blend Whether the source should be rendered first with processed buffer on top with the blending setting.
	 * @param	sampleSource<Bool> Whether the current iteration should sample from the original source input.
	 */
	public function setPrograms(programs:Array<Program>, shaderConstants:Array<ShaderConstants>, sampleSource:Array<Bool>, blend:Bool): Void {
		this.programs = programs;
		this.shaderConstants = shaderConstants;
		this.sampleSource = sampleSource;
		_blend = blend;
	}
	
	public var blend(get, set): Bool;
	function get_blend() : Bool {
		return _blend;
	}
	function set_blend(value:Bool) : Bool {
		_blend = value;
		return _blend;
	}
	
	public function addProgram(p:Program, sc:ShaderConstants, ss:Bool) {
			if (this.programs == null) this.programs = new Array();
			if (this.shaderConstants == null) this.shaderConstants = new Array<ShaderConstants>();
			if (this.sampleSource == null) this.sampleSource = new Array<Bool>();
			
			this.programs.push(p);
			this.shaderConstants.push(sc);
			this.sampleSource.push(ss);
	}
	
	public function removeProgram(p:Program) {
		var index:Int  = programs.indexOf(p);
		
		programs.splice(index, 1);
		shaderConstants.splice(index, 1);
		sampleSource.splice(index, 1);
	}
	
	public function execute(source:Image, target:Image, x:Float = 0, y:Float = 0, sx:Float = 0, sy:Float = 0, sw:Float = 0, sh:Float = 0) : Void {
		
		buffer.g2.begin(true, Color.fromFloats(0, 0, 0, 0));
		
		for (i in 0...programs.length)
		{
			//should only happen if sampling from source?
			if(sampleSource[i]){
				buffer.g2.program = programs[i];
				setConstants(shaderConstants[i], programs[i], buffer);
			
			//if (i == 1) buffer.g2.setBlendingMode(BlendingOperation.BlendOne, BlendingOperation.BlendOne);

				buffer.g2.drawSubImage(source, 0, 0, sx, sy, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
			}
			else {
				
				//Do blending here?
				buffer.g2.end();
				bufferB.g2.begin(true, Color.fromFloats(0, 0, 0, 0));
				bufferB.g2.program = programs[i];
				setConstants(shaderConstants[i], programs[i],bufferB);
				bufferB.g2.drawSubImage(buffer, 0, 0, sx, sy, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
				bufferB.g2.program = null;
				bufferB.g2.end();
				
				buffer.g2.begin();
				buffer.g2.program = null; 
				buffer.g2.drawSubImage(bufferB, 0, 0, sx, sy, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
			}
			
			
		}
		buffer.g2.end();
		
		target.g2.begin(false);

		if (blend)
		{
			target.g2.drawSubImage(source, x, y,0,0,(sw == 0 ? source.width:sw),(sh == 0 ? source.height:sh));
			target.g2.setBlendingMode(sourceBlend, destinationBlend);
		}
		//else target.g2.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.InverseSourceAlpha);
		target.g2.drawSubImage(buffer, x, y, 0, 0, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
		
		target.g2.end();
	}
	
	function setConstants(const:ShaderConstants, prog:Program, buff:Canvas)  : Void
	{
		const.hasChanged = false;
		if (const.hasFloatArr()) {
			for (key in const.floatsArrConstants.keys()) {
				buff.g4.setFloats(prog.getConstantLocation(key), const.floatsArrConstants.get(key));
			}
		}
		
		if (const.hasFloats()) {
			for (key in const.floatConstants.keys()) {
				buff.g4.setFloat(prog.getConstantLocation(key), const.floatConstants.get(key));
			}
		}
		
		if (const.hasVec2()) {
			for (key in const.vec2Constants.keys()) {
				buff.g4.setVector2(prog.getConstantLocation(key), const.vec2Constants.get(key));
			}
		}
		
		if (const.hasTextures()) {
			for (key in const.textureConstant.keys()) {
				buff.g4.setTexture(prog.getTextureUnit(key), const.textureConstant.get(key));
			}
		}
		
		if (const.hasInts()) {
			for (key in const.intConstants.keys()) {
				buff.g4.setInt(prog.getConstantLocation(key), const.intConstants.get(key));
			}
		}
		
		
	}
	
}