package com.khapunk.graphics;
import kha.Rectangle;

/**
 * @author Sidar Talei
 */

typedef CallbackFunction = Void -> Void;
 
class Animator<FrameType,ParentType> extends PunkImage 
{
	/**
	 * If the animation has stopped.
	 */
	public var complete:Bool;

	/**
	 * Optional callback function for animation end.
	 */
	public var callbackFunc:CallbackFunction;

	/**
	 * Animation speed factor, alter this to speed up/slow down all animations.
	 */
	public var rate:Float;
	
	/**
	 * The amount of frames in the Spritemap.
	 */
	public var frameCount(get, null):Int;
	private function get_frameCount():Int { return _frameCount; }

	/**
	* If the animation is played in reverse.
	*/
	public var reverse:Bool;
	
	/**
	 * The currently playing animation.
	 */
	public var currentAnim(get, null):String;
	private function get_currentAnim():String { return (_anim != null) ? _anim.name : ""; }

	// Spritemap information.
	private var _frameCount:Int;
	private var _anims:Map<String,IAnimation<FrameType,ParentType>>;
	private var _anim:IAnimation<FrameType,ParentType>;
	private var _index:Int;
	private var _timer:Float;

	
	private function new(source:Dynamic, cbFunc:CallbackFunction = null, name:String = "", rect:Rectangle = null)
	{
		callbackFunc = cbFunc;
		super(source, rect, name);
		complete = true;
		rate = 1;
		_anims = new Map < String, IAnimation < FrameType, ParentType >> ();
		_timer = 0;
		
	}

	public function playFrames(frames:Array<FrameType>, frameRate:Float = 0, loop:Bool = true, reset:Bool = false, reverse:Bool = false):IAnimation<FrameType, ParentType>{return null;} 
	public function playAnimation(anim:IAnimation<FrameType, ParentType>, reset:Bool = false, reverse:Bool = false): IAnimation<FrameType, ParentType>{return null;}  
	public function restart() : Void{}
	
  public function add(name:String, frames:Array<FrameType> = null, frameRate:Float = 0, loop:Bool = true):IAnimation<FrameType,ParentType>{return null;}
	
  /**
	 * Plays an animation.
	 * @param	name		Name of the animation to play.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @return	Anim object representing the played animation.
	 */
	public function play(name:String = "", reset:Bool = false, reverse:Bool = false):IAnimation<FrameType,ParentType>
	{
		if (!reset && _anim != null && _anim.name == name) return _anim;
		if (_anims.exists(name))
		{
			_anim = _anims.get(name);
			_timer = 0;
			this.reverse = reverse;
			_index = reverse ?  _anim.frames.length -1 : 0;
			complete = false;
			updateFrame();
			restart();
		}
		else
		{
			stop(reset);
		}
		
		return _anim;
	}
  	
  function updateFrame() : Void { }
  
    /**
	 * Current index of the playing animation.
	 */
	public var index(get, set):Int;
	private function get_index():Int { return _anim != null ? _index : 0; }
	private function set_index(value:Int):Int
	{
		if (_anim == null) return 0;
		value %= _anim.frameCount;
		if (_index == value) return _index;
		_index = value;
		updateFrame();
		return _index;
	}
  
	public function stop(reset:Bool = false) {
		_anim = null;
		if(reset)_index = 0;
		complete = true;
	}
	
	
	/** @private Updates the animation. */
	override public function update()
	{
		
		if (_anim != null && !complete)
		{
			
			_timer += _anim.frameRate * KP.elapsed * rate;
			if (_timer >= 1)
			{
				while (_timer >= 1)
				{
					
					_timer --;
					_index += reverse ? -1:1;
					if ((reverse && index == -1) || (!reverse && _index == _anim.frameCount)){
						if (_anim.loop)
						{
							_index = reverse ? _anim.frameCount -1 : 0;
							if (callbackFunc != null) callbackFunc();
						}
						else
						{
							_index = reverse ? 0: _anim.frameCount - 1;
							complete = true;
							if (callbackFunc != null) callbackFunc();
							break;
						}
					}
				}
				
				updateFrame();
			}
		}
	}

}