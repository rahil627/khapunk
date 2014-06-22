package com.khapunk.graphics;
import com.khapunk.graphics.Animator;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.graphics.atlas.TextureAtlas;


/**
 * ...
 * @author Sidar Talei
 */
class Atlasmap extends Animator<AtlasRegion, Atlasmap>
{

	var _atlas:TextureAtlas;
	
	public function new(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0, cbFunc:CallbackFunction = null, name:String = ""){
	
		super(source, cbFunc, name,_rect);
			
		complete = true;
		rate = 1;
		_anims = new Map<String,IAnimation<Int,Spritemap>>();
		_timer = _frame = 0;
		
		if (Std.is(source, TextureAtlas))
		{
			_atlas = cast(source, TextureAtlas);
		}
		else (Std.is(source, String))
		{
			_atlas = new TextureAtlas(source);
		}
	}
	
	override function updateFrame():Void 
	{
		_region = _anim.frames[_index];
	}
	
	/**
	 * Add an Animation.
	 * @param	name		Name of the animation.
	 * @param	frames		Array of frame indices to animate through.
	 * 						If frames is null, the assigned texture atlas will retrieve the sequence.
	 * @param	frameRate	Animation speed (in frames per second, 0 defaults to assigned frame rate)
	 * @param	loop		If the animation should loop
	 * @return	A new Anim object for the animation.
	 */
	override public function add(name:String, frames:Array<AtlasRegion> == null, frameRate:Float = 0, loop:Bool = true):IAnimation<Int,Spritemap>
	{
		
		if (_anims.get(name) != null)
			throw "Cannot have multiple animations with the same name";

			
		if(frameRate == 0)
			frameRate = Game.FPS;

		if(frames == null){
			var anim = new Animation(name, _atlas.getRegions(name), frameRate, loop);	
		}
		else {
			var anim = new Animation(name, frames, frameRate, loop);	
		}
		_anims.set(name, anim);
		anim.parent = this;
		return anim;
	}
	
}