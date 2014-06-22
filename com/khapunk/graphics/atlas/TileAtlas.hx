package com.khapunk.graphics.atlas;
import com.khapunk.graphics.atlas.AtlasRegion;
import kha.Image;
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
	
	public function new(source:Dynamic) 
	{
		_regions = new Array<AtlasRegion>();
		
		if (Std.is(source, Image)) {
			
			_image = cast(source,Image);
			_width = cast(source,Image).width;
			_height = cast(source,Image).height;
			
		}
		else if (Std.is(source, TextureAtlas))
		{
			_image =  cast(source,TextureAtlas).getImage();
			_width = _image.width;
			_height = _image.height;
		}

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
		return _regions[index];
	}
	
	public function prepareTiles(tileWidth:Int, tileHeight:Int, tileMarginWidth:Int,tileMarginHeight:Int)
	{
		
		var cols:Int = Math.floor(_image.width / tileWidth);
		var rows:Int = Math.floor(_image.height / tileHeight);

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
		
	}
	
}