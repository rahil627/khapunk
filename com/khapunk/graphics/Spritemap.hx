package com.khapunk.graphics;
import com.khapunk.graphics.Animation;
import com.khapunk.graphics.Animator.CallbackFunction;
import com.khapunk.graphics.atlas.TileAtlas;
import kha.Game;
import kha.Rectangle;

/**
 * ...
 * @author Sidar Talei
 */
class Spritemap extends Animator<Int,Spritemap>
{
	private var _atlas:TileAtlas;
	private var _width:Int;
	private var _height:Int;
	private var _columns:Int;
	private var _rows:Int;
	private var _rect:Rectangle;
	private var _frame:Int;
	
	public function new(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0, cbFunc:CallbackFunction = null, name:String = ""){
	

		_rect = new Rectangle(0, 0, frameWidth, frameHeight);
		
			super(source, cbFunc, name,_rect);
			
		 _frame = 0;
		if (Std.is(source, TileAtlas))
		{
			_atlas = cast(source, TileAtlas);
			_region = _atlas.getRegion(_frame);
		}
		else 
		{
			_atlas = TileAtlas.getAtlas(source);
			_atlas.prepareTiles(frameWidth, frameHeight, 0, 0);
			_region = _atlas.getRegion(_frame);
		}

	
		_width = Std.int(_atlas.img.width);
		_height = Std.int(_atlas.img.height);
		
		if (frameWidth == 0) _rect.width = _width;
		if (frameHeight == 0) _rect.height = _height;
		
			if (_width % _rect.width != 0 || _height % _rect.height != 0)
			throw "Source image width and height should be multiples of the frame width and height.";
		_columns = Math.ceil(_width / _rect.width);
		_rows = Math.ceil(_height / _rect.height);
		_frameCount = _columns * _rows;
	}
	

	override function updateFrame() : Void
	{
		if (_anim != null) _frame = Std.int(_anim.frames[_index]);
		_region = _atlas.getRegion(_frame);
	}
	
	/**
	 * Add an Animation.
	 * @param	name		Name of the animation.
	 * @param	frames		Array of frame indices to animate through.
	 * @param	frameRate	Animation speed (in frames per second, 0 defaults to assigned frame rate)
	 * @param	loop		If the animation should loop
	 * @return	A new Anim object for the animation.
	 */
	override public function add(name:String, frames:Array<Int> = null, frameRate:Float = 0, loop:Bool = true):IAnimation<Int,Spritemap>
	{
		
		if (_anims.get(name) != null)
			throw "Cannot have multiple animations with the same name";

		if(frameRate == 0)
			frameRate = Game.FPS;

		for (i in 0...frames.length)
		{
			frames[i] %= _frameCount;
			if (frames[i] < 0) frames[i] += _frameCount;
		}
		var anim = new Animation(name, frames, frameRate, loop);
		_anims.set(name, anim);
		anim.parent = this;
		return anim;
	}
	
	/**
	 * Plays an animation.
	 * @param	name		Name of the animation to play.
	 * @param	reset		If the animation should force-restart if it is already playing.
	 * @return	Anim object representing the played animation.
	 */
	/*override public function play(name:String = "", reset:Bool = false, reverse:Bool = false):IAnimation<Int,Spritemap>
	{
		if (!reset && _anim != null && _anim.name == name)
		{
			return _anim;
		}
		
		if (!_anims.exists(name))
		{
			stop(reset);
			return null;
		}
		
		_anim = _anims.get(name);
		this.reverse = reverse;
		restart();
		
		return _anim;
	}*/

		/**
	 * Plays a new ad hoc animation.
	 * @param	frames		Array of frame indices to animate through.
	 * @param	frameRate	Animation speed (in frames per second, 0 defaults to assigned frame rate)
	 * @param	loop		If the animation should loop
	 * @param	reset		When the supplied frames are currently playing, should the animation be force-restarted
	 * @param	reverse		If the animation should be played backward.
	 * @return	Anim object representing the played animation.
	 */
	override public function playFrames(frames:Array<Int>, frameRate:Float = 0, loop:Bool = true, reset:Bool = false, reverse:Bool = false):IAnimation<Int,Spritemap>
	{
		if(frames == null || frames.length == 0)
		{
			stop(reset);		
			return null;
		}

		if(reset == false && _anim != null && _anim.frames == frames)
			return _anim;

		return playAnimation(new Animation(null, frames, frameRate, loop), reset, reverse);
	}
	
		/**
	 * Plays or restarts the supplied Animation.
	 * @param	animation	The Animation object to play
	 * @param	reset		When the supplied animation is currently playing, should it be force-restarted
	 * @param	reverse		If the animation should be played backward.
	 * @return	Anim object representing the played animation.
	 */
 	override public function playAnimation(anim:IAnimation<Int,Spritemap>, reset:Bool = false, reverse:Bool = false): IAnimation<Int,Spritemap>
	{
		if(anim == null)
			throw "No animation supplied";
			
		if(reset == false && _anim == anim)
			return anim;

		_anim = anim;
		this.reverse = reverse;
		restart();
		
		return anim;
	}
	
		/**
	 * Resets the animation to play from the beginning.
	 */
	override public function restart()
	{
		_timer = _index = reverse ? _anim.frames.length - 1 : 0;
		_frame = _anim.frames[_index];
		complete = false;
	}
	
	/**
	 * Gets the frame index based on the column and row of the source image.
	 * @param	column		Frame column.
	 * @param	row			Frame row.
	 * @return	Frame index.
	 */
	public inline function getFrame(column:Int = 0, row:Int = 0):Int
	{
		return (row % _rows) * _columns + (column % _columns);
	}

	/**
	 * Sets the current frame index. When you set this, any
	 * animations playing will be stopped to force the frame.
	 */
	
	
	/**
	 * Sets the current display frame based on the column and row of the source image.
	 * When you set the frame, any animations playing will be stopped to force the frame.
	 * @param	column		Frame column.
	 * @param	row			Frame row.
	 */
	public function setFrame(column:Int = 0, row:Int = 0)
	{
		_anim = null;
		var frame:Int = getFrame(column, row);
		if (_frame == frame) return;
		_frame = frame;
		updateFrame();
	}

		/**
	 * Sets the frame to the frame index of an animation.
	 * @param	name	Animation to draw the frame frame.
	 * @param	index	Index of the frame of the animation to set to.
	 */
	 public function setAnimFrame(name:String, index:Int) : Void
	{
		var frames:Array<Int> = _anims.get(name).frames;
		index = index % frames.length;
		if (index < 0) index += frames.length;
		frame = frames[index];
	}
	
	/**
	 * Assigns the Spritemap to a random frame.
	 */
	public function randFrame()
	{
		frame = KP.rand(_frameCount);
	}
	
	override function set_index(value:Int):Int 
	{
		_frame = _anim.frames[_index];
		return super.set_index(value);
	}
	
	override public function stop(reset:Bool = false) 
	{
		_frame = 0;
		super.stop(reset);
	}
	
	/**
	 * Sets the current frame index. When you set this, any
	 * animations playing will be stopped to force the frame.
	 */
	public var frame(get, set):Int;
	private function get_frame():Int { return _frame; }
	private function set_frame(value:Int):Int
	{
		_anim = null;
		value %= _frameCount;
		if (value < 0) value = _frameCount + value;
		if (_frame == value) return _frame;
		_frame = value;
		updateFrame();
		return _frame;
	}

	
}