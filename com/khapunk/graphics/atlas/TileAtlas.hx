package com.khapunk.graphics.atlas;
import com.khapunk.graphics.atlas.AtlasRegion;
import kha.Image;
import kha.Loader;
import kha.Rectangle;

/**
 * ...
 * @author ...
 */
class TileAtlas
{

	private var _regions:Array<AtlasRegion>;
	private var _image:Image;
	private var _width:Int;
	private var _height:Int;
	private var _rect:Rectangle;
	private var _name:String;
	private var _prepared:Bool = false;
	
	
	public var cols:Int;
	public var rows:Int;
	
	private static var _dataPool:Map<Image, TileAtlas> = new Map<Image, TileAtlas>();
	
	function new(source:Dynamic) 
	{
		_regions = new Array<AtlasRegion>();

		if (Std.is(source, Image)) {
			
			_image = cast(source,Image);
			_width = _image.width;
			_height = _image.height;
			
		}
		else if (Std.is(source, TextureAtlas))
		{
			_image =  cast(source,TextureAtlas).getImage();
			_width = _image.width;
			_height = _image.height;
		}
		else if (Std.is(source, String)) {
			var s:String = cast(source, String);
			_image = Loader.the.getImage(s);
			_width = _image.width;
			_height = _image.height;
		}

	}
	
	public static inline function getAtlas(source:Dynamic): TileAtlas
	{
		var img:Image = null;
		
		if (Std.is(source, String)) {
			img = Loader.the.getImage(cast(source, String));
		}
		else if (Std.is(source, Image)) {
			img = cast(source, Image);
		}
		else if (Std.is(source, TextureAtlas)) {
			img =  cast(source,TextureAtlas).getImage();
		}
		
		if (!_dataPool.exists(img)) {
			
			var ta:TileAtlas = new TileAtlas(img);
			_dataPool.set(img,ta);
			return ta;
		}
		
		return _dataPool.get(img);
	}
	
	public function destroy() : Void
	{
		_dataPool.remove(_image);
	}
	
	public var img(get, set): Image;
	private function get_img() : Image
	{
		return _image;
	}
	private function set_img(s:Image) : Image
	{
		return _image = s;
	}
	
	public var imgWidth(get, null): Int;
	private function get_imgWidth() : Int
	{
		return _width;
	}
	
	public var imgHeight(get, null): Int;
	private function get_imgHeight() : Int
	{
		return _height;
	}
	
	
	public function getRegion(index:Int) : AtlasRegion
	{
		(index > _regions.length-1) ?  return _regions[0]:return _regions[index];
	}
	
	public function prepareTiles(tileWidth:Int, tileHeight:Int, tileMarginWidth:Int,tileMarginHeight:Int) : Void
	{
		#if debug
		 if (_prepared) trace("This atlas is already prepared");
		#end
		
		if (_prepared) return;
		
		cols = Math.floor(_image.width / tileWidth);
		rows = Math.floor(_image.height / tileHeight);

		var r:AtlasRegion;
		
		for (y in 0...rows)
		{
			for (x in 0...cols)
			{
				r = new AtlasRegion();
				
				r.x = x * (tileWidth + tileMarginWidth);
				r.y = y * (tileHeight + tileMarginHeight);
				

				r.w = tileWidth;
				r.h = tileHeight;
				
				_regions.push(r);
				
			}
		}
		
		_prepared = true;
		
	}
	
}