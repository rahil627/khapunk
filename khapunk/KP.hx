package khapunk;


import kha.Image;
import kha.Loader;
import kha.Sys;

class KP
{
	/**
	* Width of the game.
	*/
	public static var width(get, null):Int;
	static function get_width() : Int {
		return Loader.the.width;
	}

	/**
	 * Height of the game.
	 */
	public static var height(get, null):Int;
	static function get_height() : Int {
		return Loader.the.height;
	}
	
	public static var backbuffer(default,null):Image;
	public static function init() : Void {
		backbuffer = Image.createRenderTarget(width, height);
	}
	
	@:allow(khapunk.scene.Scene)
	public static var frameRate(default, null):Float = 0;
}
