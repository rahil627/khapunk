package com.khapunk.graphics.shader;
import kha.Canvas;
import kha.Color;
import kha.graphics4.BlendingOperation;
import kha.graphics4.CompareMode;
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
			buffer = Image.createRenderTarget(KP.width, KP.height);
			bufferB = Image.createRenderTarget(KP.width, KP.height);
		}
		
	}
	
	public static function resize(w:Int, h:Int) : Void {
		buffer.unload();
		//bufferB.unload();
		
		buffer = Image.createRenderTarget(w, h);
		bufferB = Image.createRenderTarget(w, h);
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
	
	public var blend(get, null): Bool;
	function get_blend() : Bool {
		return _blend;
	}
	
	public function execute(source:Image, target:Image, x:Float = 0, y:Float = 0, sx:Float = 0, sy:Float = 0, sw:Float = 0, sh:Float = 0) : Void {
		
		buffer.g2.begin(true, Color.fromFloats(0, 0, 0, 0));
		
		for (i in 0...programs.length)
		{
			buffer.g2.program = programs[i];
			
			//If shader constant is not null AND either shader constant has changed OR previous program is the same as current program or the next.
			//If the program is the same as the previous/next one we update the uniforms with the specified shader constant object.
			//Due to the hasChanged flag the changes might never get applied, this way we ensure the same shader gets applied with different settings.
			if (
					shaderConstants[i] != null && 
					(
						shaderConstants[i].hasChanged || 
						(( i > 0) ? (programs[i - 1] == programs[i]):false) ||
						(( i < programs.length - 1) ? (programs[i + 1] == programs[i]):false)
					)
				)
			{
				setConstants(shaderConstants[i], programs[i]);
			}
			
			if (i >= 1) buffer.g2.setBlendingMode(BlendingOperation.BlendOne, BlendingOperation.InverseSourceAlpha);
			
			if (sampleSource[i]) {
				buffer.g2.drawSubImage(source, 0, 0, sx, sy, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
			}
			else {
				buffer.g2.end();
				bufferB.g2.begin(true, Color.fromFloats(0, 0, 0, 0));
				bufferB.g2.drawSubImage(buffer, 0, 0, sx, sy, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
				bufferB.g2.end();
				
				buffer.g2.begin(false);
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
		else target.g2.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.InverseSourceAlpha);
		target.g2.drawSubImage(buffer, x, y, 0, 0, (sw == 0 ? source.width:sw), (sh == 0 ? source.height:sh));
		
		target.g2.end();
	}
	
	function setConstants(const:ShaderConstants = null, prog:Program)  : Void
	{
		const.hasChanged = false;
		if (const.hasFloatArr()) {
			for (key in const.floatsArrConstants.keys()) {
				buffer.g4.setFloats(prog.getConstantLocation(key), const.floatsArrConstants.get(key));
			}
		}
		
		if (const.hasFloats()) {
			
			for (key in const.floatConstants.keys()) {
				buffer.g4.setFloat(prog.getConstantLocation(key), const.floatConstants.get(key));
			}
		}
		
		if (const.hasVec2()) {
			for (key in const.vec2Constants.keys()) {
				buffer.g4.setVector2(prog.getConstantLocation(key), const.vec2Constants.get(key));
			}
		}
		
		if (const.hasTextures()) {
			for (key in const.textureConstant.keys()) {
				buffer.g4.setTexture(prog.getTextureUnit(key), const.textureConstant.get(key));
			}
		}
		
		if (const.hasInts()) {
			for (key in const.intConstants.keys()) {
				buffer.g4.setInt(prog.getConstantLocation(key), const.intConstants.get(key));
			}
		}
		
		
	}
	
}