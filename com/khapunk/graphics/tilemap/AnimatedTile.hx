package com.khapunk.graphics.tilemap;

/**
 * ...
 * @author Sidar Talei
 */
class AnimatedTile {
	public function new() {
		speed = 0;
		currentTime = 0;
		length = 0;
		index = 0;
		reverse = false;
		frame = 0;
		children = new Array<Int>();
		offset = 0;
	}
	public var speed:Float;
	public var currentTime:Float;
	public var length:Int;
	public var index:Int;
	public var frame:Int;
	public var paused:Bool;
	public var reverse:Bool;
	public var vertical:Bool;
	public var offset:Int;
	
	public var children:Array<Int>;
	
	var perc:Float = 0;
	
	public function update() : Void
	{
		currentTime += KP.elapsed;
		if (currentTime > 1 / speed) {
			currentTime = 0;
			if (reverse) {
				frame--;
				if (frame < 0)
				{
					frame = length-1;
				}
				for (i in 0...children.length)
				{
					children[i]--;
					if (children[i] < 0)
					{
						children[i] = length-1;
					}
				}
				
			}
			else {
				frame++;
				if (frame >= length)
				{
					frame = 0;
				}
				
				for (i in 0...children.length)
				{
					children[i]++;
					if (children[i] >= length)
					{
						children[i] = 0;
					}
				}
			}
		}
	}
	
	public function getChildFrame(index:Int) : Int
	{
		return children[index];
	}
}