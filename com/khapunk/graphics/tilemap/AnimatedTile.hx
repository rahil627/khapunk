package com.khapunk.graphics.tilemap;

/**
 * ...
 * @author Sidar Talei
 */
class AnimatedTile {
	public function new() {
		speed = 1;
		length = 0;
		reverse = false;
		framePos = new Array<Int>();
		frameTimers = new Array<Float>();
	}
	
	public var speed:Float;
	public var length:Int;
	public var index:Int;
	public var paused:Bool;
	public var reverse:Bool;
	
	public var frames:Array<Int>;
	public var durations:Array<Float>;
	public var framePos:Array<Int>;
	public var frameTimers:Array<Float>;
	
	var perc:Float = 0;
	
	public function update() : Void
	{
		for (i in 0...framePos.length)
		{
			
			frameTimers[i] += KP.elapsed;
			
			if (frameTimers[i] > durations[framePos[i]] / speed) {
				frameTimers[i] = 0;
				
				if (reverse) {
					framePos[i]--;
					if (framePos[i] < 0)
					{
						framePos[i] = length-1;
					}
				}
				else {
					framePos[i]++;
					if (framePos[i] >= length)
					{
						framePos[i] = 0;
					}
				}
			}
		}
	}

	public function getParentFrame() : Int
	{
		return frames[framePos[0]];
	}
	
	var indexof:Int;
	public function getChildFrame(index:Int) : Int
	{
		indexof = frames.indexOf(index);
		return frames[framePos[indexof]];
	}
}