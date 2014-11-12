package com.khapunk.graphics;
import kha.math.Matrix3;
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
	public var matrix:Matrix3;
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	
	public function new() 
	{
		matrix = Matrix3.identity();
	}
	
	public function rotate(angle:Float): Void {
		rotation = angle;
		matrix = Matrix3.translation(KP.halfWidth, KP.halfHeight) * 
		Matrix3.scale(scaleX, scaleY) * 
		Matrix3.rotation(rotation) * 
		Matrix3.translation(-KP.halfWidth, -KP.halfHeight);
	}
	
	public function rotateAround(angle:Float,screenX:Float,screenY:Float,scalex:Float = null,scaley:Float = null): Void {
		rotation = angle;
		matrix = Matrix3.translation(screenX, screenY) * 
		Matrix3.scale((scalex == null ? scaleX:scalex), (scaley == null ? scaleY:scaley)) * 
		Matrix3.rotation(rotation) * 
		Matrix3.translation(-screenX, -screenY);
	}
	
	
	public function scale(x:Float,y:Float) : Void {
		scaleX = x;
		scaleY = y;
		matrix = Matrix3.translation(KP.halfWidth, KP.halfHeight) * 
		Matrix3.scale(scaleX, scaleY) * 
		Matrix3.rotation(rotation) * 
		Matrix3.translation(-KP.halfWidth, -KP.halfHeight);
	}
	
	public function  translate(screenX:Float, screenY:Float) : Void {

		matrix = Matrix3.translation(screenX, screenY) * 
		Matrix3.scale(scaleX, scaleY) * 
		Matrix3.rotation(rotation) * 
		Matrix3.translation(-screenX, -screenY);
	}
}