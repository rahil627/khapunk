package com.khapunk.graphics.shader;
import kha.Canvas;
import kha.graphics4.BlendingOperation;
import kha.graphics4.Program;
import kha.Image;

/**
 * ...
 * @author Sidar Talei
 */
class ShaderPass
{

	var programs:Array<Program>;
	var _blend:Bool = false;

	var previousBuffer:Image;
	var buffer:Image;
	var shaderConstants:Array<ShaderConstants>;
	public var sourceBlend:BlendingOperation;
	public var destinationBlend:BlendingOperation;
	
	static var bufferA:Image;
	static var bufferB:Image;
	
	public function new() {
		sourceBlend = BlendingOperation.SourceAlpha;
		destinationBlend = BlendingOperation.BlendOne;
		
		if (bufferA == null) {
			bufferA = Image.createRenderTarget(KP.width, KP.height);
			bufferB = Image.createRenderTarget(KP.width, KP.height);
		}
		
	}
	
	public static function resize(w:Int, h:Int) : Void {
		bufferA.unload();
		bufferB.unload();
		
		bufferA = Image.createRenderTarget(KP.width, KP.height);
		bufferB = Image.createRenderTarget(KP.width, KP.height);
	}
	
	/**
	 * Sets
	 * @param	Array<Program>
	 * @param	Array<Canvas>
	 * @param	blend
	 */
	public function setPrograms(programs:Array<Program>, shaderConstants:Array<ShaderConstants>, blend:Bool): Void {
		this.programs = programs;
		_blend = blend;
		this.shaderConstants = shaderConstants;
	}
	
	public var blend(get, null): Bool;
	function get_blend() : Bool {
		return _blend;
	}
	
	public function execute(source:Image, target:Image, x:Float = 0, y:Float = 0, sx:Float = 0, sy:Float = 0, sw:Float = 0, sh:Float = 0) : Void {
		
		buffer = bufferA;
		
		for (i in 0...programs.length)
		{
			
			buffer.g2.begin();
			buffer.g2.program = programs[i];
			
			if(shaderConstants[i] != null && shaderConstants[i].hasChanged) setConstants(shaderConstants[i], programs[i],buffer);
			
			if (i == 0){
				buffer.g2.drawSubImage(source, 0, 0, sx, sy, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
			}
			else {
				buffer.g2.drawSubImage(previousBuffer, 0, 0,sx,sy,(sw == 0 ? previousBuffer.width:sw),(sh == 0 ? previousBuffer.height:sh));
			}
			
			buffer.g2.end();
			
			
			if (buffer == bufferA) {
				previousBuffer = buffer;
				buffer = bufferB;
			}
			else {
				previousBuffer = buffer;
				buffer = bufferA;
			}
			
		}
		
		target.g2.begin();
		//render previousBuffer since buffer gets swapped
		target.g2.drawSubImage(previousBuffer, x, y,0,0,(sw == 0 ? source.width:sw),(sh == 0 ? source.height:sh));
		target.g2.end();
		flip = false;
	}
	var flip:Bool = false;
	function setConstants(const:ShaderConstants, prog:Program, buff:Image)  : Void
	{
		buff.g4.setFloat(prog.getConstantLocation("flipy"), buff.g4.renderTargetsInvertedY() ? (flip ? 1:0):(flip ? 0:1));
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
		
		
	}
	
}