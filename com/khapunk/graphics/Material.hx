package com.khapunk.graphics;
import com.khapunk.graphics.shader.ShaderConstants;
import kha.Canvas;
import kha.graphics2.Graphics;
import kha.graphics4.BlendingOperation;
import kha.graphics4.PipelineState;

/**
 * ...
 * @author Sidar Talei
 */
class Material
{
	/**
	 * Create a material that can be shared among other Graphics.
	 * @param	p
	 * @return
	 */
	public static function CreateMaterial(p:PipelineState) : Material {
		var m:Material = new Material();
		m.setShader(p, new ShaderConstants());
		return m;
	}
	
	static var lastBlendMode:BlendMode = Normal;
	static var lastProgram:PipelineState = null;
	public var blendMode:BlendMode = BlendMode.Normal;
	
	var shader:PipelineState;
	var constants:ShaderConstants;
	
	//TODO FIX Render target
	//var renderTarget:Canvas = null;
	
	public function new() 
	{
		
	}
	
	public function setShader(p:PipelineState, constants:ShaderConstants) : Void
	{
		this.constants = constants;
		shader = p;
	}
	
	public function apply(c:Canvas) {
		
		if(lastProgram != shader){
			c.g2.pipeline = shader;
			lastProgram = shader;
		}
		checkBlendMode(c.g2);
		
		if(shader != null && constants != null){
			
			setConstants(constants, shader, c);
		}
	}
	
	public function checkBlendMode(g:Graphics) : Void {
		
			if (lastBlendMode != blendMode) {
            switch (blendMode) {
                case Normal:	 g.setBlendingMode(BlendingOperation.BlendOne, BlendingOperation.InverseSourceAlpha);
                case Mask:  	 g.setBlendingMode(BlendingOperation.BlendZero,BlendingOperation.SourceAlpha);
                case Copy:  	 g.setBlendingMode(BlendingOperation.BlendOne, BlendingOperation.BlendZero); 
                case Add: 		 g.setBlendingMode(BlendingOperation.BlendOne, BlendingOperation.BlendOne);
            }
            lastBlendMode = blendMode;
        }
	}
	
	/**
	 * This is automatically called by Apply. Only use this in cases you need to update the consts live.
	 * @param	c
	 */
	/*public function updateConsts(c:Canvas) {
		if(shader != null && constants != null){
			setConstants(constants, shader, c);
		}
	}*/
	
	function setConstants(const:ShaderConstants, prog:PipelineState, buff:Canvas)  : Void
	{
		if(const.hasChanged){
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
	
	
}