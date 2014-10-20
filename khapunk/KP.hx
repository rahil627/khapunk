package khapunk;


import kha.Image;

class HXP
{
	public static var backbuffer:Image;
	
	@:allow(khapunk.scene.Scene)
	public static var frameRate(default, null):Float = 0;
}
