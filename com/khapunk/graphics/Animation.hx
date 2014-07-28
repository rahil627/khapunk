package com.khapunk.graphics;

/**
 * ...
 * @author Sidar Talei
 */
class Animation implements IAnimation<Int,Spritemap>
{

	/**
	 * Constructor.
	 * @param	name		Animation name.
	 * @param	frames		Array of frame indices to animate.
	 * @param	frameRate	Animation speed.
	 * @param	loop		If the animation should loop.
	 */
	public function new(name:String, frames:Array<Int>, frameRate:Float = 0, loop:Bool = true)
	{
        this.name       = name;
        this.frames     = frames;
        this.frameRate  = frameRate;
        this.loop       = loop;
        this.frameCount = frames.length;
	}
	
	/*
	 * Plays the animation.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 */
	public function play(reset:Bool = false , reverse:Bool = false)
	{
		_parent.play(name, reset, reverse);
	}

	public var parent(null, set):Spritemap;
	private function set_parent(value:Spritemap):Spritemap {
		_parent = value;
		return _parent;
	}
	
	/**
	 * Name of the animation.
	 */
	public var name(default, null):String;

	/**
	 * Array of frame indices to animate.
	 */
	public var frames(default, null):Array<Int>;

	/**
	 * Animation speed.
	 */
	public var frameRate(default, null):Float;

	/**
	 * Amount of frames in the animation.
	 */
	public var frameCount(default, null):Int;

	/**
	 * If the animation loops.
	 */
	public var loop(default, null):Bool;

	private var _parent:Spritemap;
}