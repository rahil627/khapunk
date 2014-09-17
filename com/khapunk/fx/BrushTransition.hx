package com.khapunk.fx;
import com.khapunk.fx.ITransitionEffect.TransitionState;
import com.khapunk.graphics.Backdrop;
import kha.Canvas;
import kha.Color;
import kha.graphics4.BlendingOperation;
import kha.graphics4.FragmentShader;
import kha.graphics4.Program;
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
class BrushTransition extends ITransitionEffect
{
	var point:Vector2;
	var b1:Backdrop;
	var b2:Backdrop;
	var size:Float;
	var timer:Float;
	static var program:Program;
	
	public var in_dirX:Float = 0;
	public var in_dirY:Float = 0;

	public var out_dirX:Float = 0;
	public var out_dirY:Float = 0;
	
	public var in_scaleFrom:Float = 1;
	public var in_scaleTo:Float = 1;
	
	public var out_scaleFrom:Float = 1;
	public var out_scaleTo:Float = 1;
	
	public var in_rotateFrom:Float = 0;
	public var in_rotateTo:Float = 0;
	
	public var out_rotateFrom:Float = 0;
	public var out_rotateTo:Float = 0;
	

	
	public var duration:Float = 3;
	

	public function new(inEffect:Image, outEffect:Image) 
	{
		super();
		
		b1 = new Backdrop(inEffect, true, true);
		b2 = new Backdrop(outEffect, true, true);
		
		b1.scaleFromCenter = false;
		b2.scaleFromCenter = false;
		
		size = inEffect.width;
		
		point = new Vector2();
		state = TransitionState.OUT;
		
		if (program == null) {
			program = new Program();
			var vert:VertexShader = new VertexShader(Loader.the.getShader("standard-vertex.vert"));
			var frag:FragmentShader = new FragmentShader(Loader.the.getShader("transition.frag"));
			var structure:VertexStructure = new VertexStructure();
			structure.add("vertexPosition", VertexData.Float3);
			structure.add("texPosition", VertexData.Float2);
			structure.add("vertexColor", VertexData.Float4);
			
			program.setFragmentShader(frag);
			program.setVertexShader(vert);
			
			program.link(structure);
		}
	}
	
	/* INTERFACE com.khapunk.fx.ITransitionEffect */
	
	public var scaleOutFromCenter(default, set):Bool;
	function set_scaleOutFromCenter(value:Bool): Bool {
		return b2.scaleFromCenter = value; 
	}
	
	public var scaleInFromCenter(default, set):Bool;
	function set_scaleInFromCenter(value:Bool): Bool {
		return b1.scaleFromCenter = value;
	}
	
	public var fadeOutcolor:Color = Color.Black;
	
	public function setImageScale_Out(value:Float): Void
	{
		b2.scale = value;
	}
	
	public function setImageScale_In(value:Float): Void {
		b1.scale = value;
	}
	
	public override function init(): Void {
		timer = 0;
		b1.x = b1.y = b2.y = b2.x = 0;
	}
	
	public override function update():Void 
	{
		timer += KP.elapsed;
		var t:Float = timer / duration;
		var inverse:Float = (1 / duration);
		switch(state) {
			case TransitionState.IN:
				b1.x += in_dirX * inverse;
				b1.y += in_dirY * inverse;
				
				b1.centerScale = KP.lerp(in_scaleFrom,in_scaleTo,t);
				b1.angle = KP.lerp(in_rotateFrom,in_rotateTo,t);
				
			case TransitionState.OUT:
				b2.x += out_dirX * inverse;
				b2.y += out_dirY * inverse;
				
				b2.centerScale = KP.lerp(out_scaleFrom, out_scaleTo, t);
				b2.angle = KP.lerp(out_rotateFrom,out_rotateTo,t);
				
				
		}	
	}
	
	public override function stateDone(): Bool {
		return timer >= duration;
	}
	
	public override function render(backbuffer:Canvas, transitionBuffer:Canvas):Void 
	{
		transitionBuffer.g2.begin(false);
		transitionBuffer.g2.program = program;
		transitionBuffer.g4.setFloat(program.getConstantLocation("transition"), state == TransitionState.IN ? 1:0);
		transitionBuffer.g4.setFloat(program.getConstantLocation("flipy"), transitionBuffer.g4.renderTargetsInvertedY() ? 1:0);
		
		switch(state) {
			case TransitionState.IN:
				transitionBuffer.g2.setBlendingMode(BlendingOperation.DestinationAlpha, BlendingOperation.SourceAlpha);
				b1.render(transitionBuffer, point, point);
				b1.color = fadeOutcolor;
			case TransitionState.OUT:
				transitionBuffer.g2.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.DestinationAlpha);
				b2.render(transitionBuffer, point, point);
				b2.color = fadeOutcolor;
		}
	
		transitionBuffer.g2.end();
	}
	
	/* INTERFACE com.khapunk.fx.ITransitionEffect */
	
	public override function completed():Bool 
	{
		return (state == TransitionState.IN) && stateDone();
	}
	
}