package com.khapunk.graphics;

/**
 * @author Sidar Talei
 */

interface IAnimation<FrameType, ParentType>
{
  
	public function play(reset:Bool = false, reverse:Bool = false) : Void;
	
	/**
	 * Name of the animation.
	 */
	public var name(default, null):String;
	/**
	 * Array of frame indices to animate.
	 */
	public var frames(default, null):Array<FrameType>;
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
	private var _parent:ParentType;
}