package com.khapunk.graphics.shader;
import haxe.ds.Vector;
import com.khapunk.graphics.Material;
import kha.FastFloat;
import kha.Image;
import kha.math.FastVector2;
import kha.math.Vector2;
import kha.math.Vector3;


/**
 * ...
 * @author Sidar Talei
 */
@:allow(com.khapunk.graphics.shader.ShaderPass)
@:allow(com.khapunk.graphics.Material)
class ShaderConstants
{

	var floatConstants:Map<String,Float>;
	var vec2Constants:Map<String,FastVector2>;
	var intConstants:Map<String,Int>;
	var textureConstant:Map<String,Image>;
	var floatsArrConstants:Map<String,Vector<FastFloat>>;
	
	public var hasChanged(default, default) : Bool = false;
	
	public function new() 
	{
		
	}
	
	public function setFloatArr(name:String,value:Vector<FastFloat>) : Void {
		if (floatsArrConstants == null) floatsArrConstants = new Map<String,Vector<FastFloat>>();
		floatsArrConstants.set(name, value);
		hasChanged = true;
	}
	
	public function setInt(name:String,value:Int) : Void {
		if (intConstants == null) intConstants = new Map<String,Int>();
		intConstants.set(name, value);
		hasChanged = true;
	}
	
	
	public function setFloat(name:String, value:Float) : Void {
		if (floatConstants == null) floatConstants = new Map<String,Float>();
		floatConstants.set(name, value);
		hasChanged = true;
	}
	
	public function setVec2(name:String,value:FastVector2) : Void {
		if (vec2Constants == null) vec2Constants = new Map<String,FastVector2>();
		vec2Constants.set(name, value);
		hasChanged = true;
	}
	
	public function setTexture(name:String,value:Image) : Void {
		if (textureConstant == null) textureConstant = new Map<String,Image>();
		textureConstant.set(name, value);
		hasChanged = true;
	}
	
	
	public function hasFloats() : Bool {return floatConstants != null;}
	public function hasVec2() : Bool {return vec2Constants != null;}
	public function hasFloatArr() : Bool {return floatsArrConstants != null;}
	public function hasTextures() : Bool {return textureConstant != null;}
	public function hasInts() : Bool {return intConstants != null;}
	
}