package com.khapunk.graphics;
import kha.math.FastMatrix3;
import kha.math.Vector2;

/**
 * ...
 * @author Sidar Talei
 */
class Camera
{

	public var rotation:Float = 0.0;
	public var scaleX:Float = 1.0;
	public var scaleY:Float = 1.0;
	public var matrix:FastMatrix3;
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	
	public function new() 
	{
		matrix = FastMatrix3.identity();
	}
	
	public function rotate(angle:Float): Void {
		rotation = angle;
		matrix = FastMatrix3.identity();
		matrix = matrix.multmat(FastMatrix3.translation(KP.halfWidth, KP.halfHeight))
		.multmat(FastMatrix3.scale(scaleX, scaleY))
		.multmat(FastMatrix3.rotation(rotation))
		.multmat(FastMatrix3.translation( -KP.halfWidth, -KP.halfHeight));
	}
	
	public function rotateAround(angle:Float, screenX:Float, screenY:Float, scalex:Float = null, scaley:Float = null): Void {
		
		scaleX = scaley == null ? scaleY:scaley;
		scaleY = scalex == null ? scaleX:scalex;
		rotation = angle;
		matrix = FastMatrix3.translation(screenX, screenY).multmat( FastMatrix3.scale(scaleX, scaleY))
		.multmat(FastMatrix3.rotation(rotation))
		.multmat(FastMatrix3.translation( -screenX, -screenY));
	}
	
	
	public function scale(x:Float,y:Float) : Void {
		scaleX = x;
		scaleY = y;
		matrix = FastMatrix3.translation(KP.halfWidth, KP.halfHeight)
		.multmat(FastMatrix3.scale(scaleX, scaleY))
		.multmat(FastMatrix3.rotation(rotation))
		.multmat(FastMatrix3.translation( -KP.halfWidth, -KP.halfHeight)); 
	}
	
	public function  translate(screenX:Float, screenY:Float) : Void {

		matrix = FastMatrix3.translation(screenX, screenY)
		.multmat(FastMatrix3.scale(scaleX, scaleY))
		.multmat(FastMatrix3.rotation(rotation))
		.multmat(FastMatrix3.translation(-screenX, -screenY)); 
	}
}