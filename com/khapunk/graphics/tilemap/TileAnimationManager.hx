package com.khapunk.graphics.tilemap;
import com.khapunk.graphics.tilemap.AnimatedTile;

/**
 * ...
 * @author Sidar Talei
 */
class TileAnimationManager
{
	static var _animlayers:Map<String, Map<Int, AnimatedTile>>;
	static var _parentLayers:Map<String, Map<Int, Int>>;
	static var initiated:Bool = false;
	static var paused:Bool;

	public static function addLayer(tileset:String, animLayer: Map<Int, AnimatedTile>) : Void
	{
		_animlayers.set(tileset, animLayer);
	}
	
	public static function getLayer(tileset:String): Map<Int, AnimatedTile>
	{
		return _animlayers.get(tileset);
	}
	
	public static function addParentLayer(tileset:String, parentLayer: Map<Int, Int>) : Void
	{
		_parentLayers.set(tileset, parentLayer);
	}
	
	public static function getParentLayer(tileset:String):  Map<Int, Int>
	{
		return _parentLayers.get(tileset);
	}
	
	public static function layerExists(tileset:String) : Bool
	{
		return _animlayers.exists(tileset);
	}
	
	public static function parentLayerExists(tileset:String) : Bool
	{
		return _parentLayers.exists(tileset);
	}
	

		/**
	 * Adds animation information for a tile
	 * @param	index The tile index
	 * @param	length The amount of frames 
	 * @param	speed The rate at which the tile should animate
	 * @param	reverse Whether the animation should be played backwards
	 * @param	vertical If our animation is setup vertical on our tileset.
	 * @return  returns The object that holds the animation information.
	 */
	public static function addAnimatedTile(tileset:String,index:Int, length:Int, speed:Int, reverse:Bool = false, vertical:Bool = false, tileset:String ) : AnimatedTile
	{	
		var anim:AnimatedTile;
		
		if (!_animlayers.exists(tileset)) _animlayers.set(tileset, new Map<Int,AnimatedTile>());
		
		if (_animlayers.get(tileset).exists(index)) {
			anim = _animlayers.get(tileset).get(index);
		}
		else {
			anim = new AnimatedTile();
			anim.index = index;
			_animlayers.get(tileset).set(index, anim);
		}
	
		anim.length = length;
		anim.speed = speed;
		anim.reverse = false;
		anim.vertical = vertical;
		
		return anim;
	}
	

		/**
	 * Groups up an animation frame to a parent frame
	 * @param	index The child GID
	 * @param	parent The parent GID.
	 */
	public function addChildTile(tileset:String, index:Int, parent:Int, tileset:String) : Void
	{
		 _parentLayers.get(tileset).set(index,parent);
		_animlayers.get(tileset).get(parent).children[index - parent - 1] = index - parent;
	}

	
	public static function init() : Void
	{
		if (initiated) clear();
		initiated = true;
		_animlayers = new Map<String, Map<Int, AnimatedTile>>();
		_parentLayers = new Map<String, Map<Int, Int>>();
	}
	
	public static function update() : Void
	{
		if (paused || !initiated) return;
		for (layers in _animlayers) {
			for (anim in layers) 
				anim.update();
		}
	}
	
	public static function clear() : Void
	{
		initiated = false;
		_animlayers = null;
		_parentLayers = null;
	}
	
	public function stop() : Void
	{
		paused = true;
	}
	
	public function resume() : Void
	{
		paused = false;
	}
}