package com.khapunk.utils;
import js.Cookie;
import kha.Color;

/**
 * ...
 * @author ...
 */
class ColorTransform
{

	public var alphaMultiplier:Float = 0;
	public var alphaOffset:Float = 0;
	public var blueMultiplier:Float = 0;
	public var blueOffset:Float = 0;
		   var _color:Color;
	public var color(get, set):Color;
	public var greenMultiplier:Float= 0;	
	public var greenOffset:Float= 0;
	public var redMultiplier:Float= 0;
	public var redOffset:Float= 0;

	public function new(redMultiplier:Float = 1.0, greenMultiplier:Float = 1.0, blueMultiplier:Float = 1.0, alphaMultiplier = 1.0,
								   redOffset:Float = 0, blueOffset:Float = 0, greenOffset:Float = 0, alphaOffset:Float = 0 ) {
									 
		this.redMultiplier = redMultiplier;
		this.greenMultiplier = greenMultiplier;
		this.blueMultiplier = blueMultiplier;
		this.alphaMultiplier = alphaMultiplier;
		this.redOffset = redOffset;
		this.blueOffset = blueOffset;
		this.greenOffset = greenOffset;
		this.alphaOffset = alphaOffset;
		
	}
	//rgb-----------------------------
	
	public function transform() : Void
	{
		_color.Rb = Std.int(_color.Rb * redMultiplier + redOffset );
		_color.Gb = Std.int(_color.Gb * greenMultiplier + blueOffset );
		_color.Bb = Std.int(_color.Bb * blueMultiplier + greenOffset );
		_color.Ab = Std.int(_color.Ab * alphaMultiplier + alphaOffset ); 
		
		
		
		/*if (r > 255) r = 255;
		else if (r < 0 ) r = 0;
		
		if (g > 255) g = 255;
		else if (g < 0 ) g = 0;
		
		if (b > 255) b = 255;
		else if (b < 0 ) b = 0;
		
		if (a > 255) a = 255;
		else if (a < 0 ) a = 0;*/
		
		//_color = Color.fromBytes(r, g, b, a);
	}
	
	public function concat(second:ColorTransform) : Void
	{
		_color.Rb += second._color.Rb;
		_color.Gb += second._color.Gb;
		_color.Bb += second._color.Bb;
		_color.Ab += second._color.Ab;
		
		redOffset 	+= second.redOffset;
		blueOffset 	+= second.blueOffset;
		greenOffset += second.greenOffset;
		alphaOffset += second.alphaOffset;
		
		redMultiplier 	+= second.redMultiplier;
		blueMultiplier 	+= second.blueMultiplier;
		greenMultiplier += second.greenMultiplier;
		alphaMultiplier += second.alphaMultiplier;
	
		transform();
	}
	
	
	function get_color() : Color
	{
		return _color;
	}
	
	function set_color(value:Color) : Color
	{
		_color = value;
		transform();
		return _color;
	}
	
	public function toString() : String
	{
		var s:String = "ARGB = [" + _color.Ab + "," + _color.Rb + "," +_color.Gb + "," + _color.Bb +"]\n" +
					   "Offset = [" + alphaOffset + "," + redOffset + "," + greenOffset + "," + blueOffset + "]\n" +
					   "Multiplier = [" + alphaMultiplier + "," + redMultiplier + "," + greenMultiplier + "," + blueMultiplier + "]\n";
		
		return s;
	}

}