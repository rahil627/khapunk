package com.khapunk.graphics.atlas;
import kha.Image;

/**
 * ...
 * @author ...
 */
class AtlasRegion {
	public function new(){}
	public var image:Image;
	public var name:String;
	public var x:Int;
	public var y:Int;
	public var w:Int;
	public var h:Int;
	public var sx:Int;
	public var sy:Int;
	public var sh:Int;
	public var sw:Int;
	public var rotated:Bool;
	public var trimmed:Bool;
	public var atlas:TextureAtlas;
}