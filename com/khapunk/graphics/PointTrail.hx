package com.khapunk.graphics;
import haxe.ds.Vector;
import kha.Color;
import kha.graphics4.BlendingOperation;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Program;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Image;
import kha.Loader;
import kha.math.Matrix4;
import kha.math.Vector2;

import com.khapunk.Graphic;
import kha.Canvas;

/**
 * ...
 * @author Sidar Talei
 */
class PointTrail extends Graphic
{

	
	var trailPoints:Array<Vector2>;
	var alpha:Array<Float>;
	
	
	var current:Int = 0;
	var timer:Float = 0.0;
	
	public var parent:Dynamic;
	public var additiveBlend:Bool = false;
	static var matrix:Matrix4 = Matrix4.identity();
	static var projection:Matrix4 = Matrix4.orthogonalProjection(0, 640, 0, 480, 1, 50);
	
	static var program:Program;
	static var struct:VertexStructure;
	
	public var width:Float = 50.0;
	
	public var step:Float = 0.06;
	public var alphaSpeed:Float = 0.05;
	public var startingAlpha:Float = 1;
	
	public var rainbowMode:Bool = false;
	
	public function new(parent:Dynamic) 
	{
		super();
		this.parent = parent;
		trailPoints = new Array<Vector2>();
		alpha = new Array<Float>();
	}
	
	
	override public function update() {
		timer += KP.elapsed;
	}
	
	function calcVertices(): Void {
		
		if (timer > step) {
			trailPoints.push(new Vector2(this.point.x, this.point.y));
			alpha.push(startingAlpha);
			timer = 0;
			
		}
		
		for (i in 0...alpha.length) {
			alpha[0] -= alphaSpeed;
		}
		
		if (alpha[0] <= 0) {
			trailPoints.shift();
			alpha.shift();
		}
		
	}
	
	var prev:Float = 1.0;
	var prevC:Int = 0;
	override public function render(buffer:Canvas, point:Vector2, camera:Vector2) 
	{
		// determine drawing location
		this.point.x = point.x;
		this.point.y = point.y;
		
		calcVertices();
		
		if(additiveBlend)buffer.g2.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.BlendOne);
		for (i in 0...alpha.length) {
			
			
			if (Reflect.hasField(parent, "_alpha")) {
				 prev = parent._alpha;
				parent._alpha = alpha[i]; 
				prevC = parent._color;
				if(additiveBlend)	parent._color = Color.fromValue(Std.int(Math.random() * 0xFFFFFF)); 
				
			 }else {
				 prevC = parent._color;
				 buffer.g2.pushOpacity(alpha[i]);
				if(rainbowMode) buffer.g2.set_color(Color.fromValue(Std.int(Math.random() * 0xFFFFFF)));
			 }
			 
			parent.render(buffer, trailPoints[i], camera);
			
			 if (Reflect.hasField(parent, "_alpha")) {
				parent._alpha = prev;
				parent._color = prevC;
			 }else {
				 buffer.g2.popOpacity();
				  buffer.g2.set_color(Color.fromValue(prevC));
			 }
		}
		if(additiveBlend)buffer.g2.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.InverseSourceAlpha);
	}
	
}