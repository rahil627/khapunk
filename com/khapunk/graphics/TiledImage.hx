package com.khapunk.graphics;


import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.KP;
import com.khapunk.Graphic;
import kha.Canvas;
import kha.Color;
import kha.Image;
import kha.math.Vector2;
import com.khapunk.graphics.Rectangle;

/**
 * Special Image object that can display blocks of tiles.
 */
class TiledImage extends PunkImage
{
	/**
	 * Constructs the TiledImage.
	 * @param	texture		Source texture.
	 * @param	width		The width of the image (the texture will be drawn to fill this area).
	 * @param	height		The height of the image (the texture will be drawn to fill this area).
	 * @param	clipRect	An optional area of the source texture to use (eg. a tile from a tileset).
	 */
	public function new(texture:Dynamic, width:Int = 0, height:Int = 0, clipRect:Rectangle = null)
	{
		
		super(texture, clipRect);
		
	
		_width = width;
		_height = height;
	
	}
	
	/** Renders the image. */
	@:dox(hide)
		override public function render(buffer:Canvas, point:Vector2, camera:Vector2)
	{
		// determine drawing location
		this.point.x = point.x + x - originX - camera.x * scrollX;
		this.point.y = point.y + y - originY - camera.y * scrollY;

		// TODO: properly handle flipped tiled spritemaps
		if (this._flippedX) this.point.x += _sourceRect.width;
		var sx =  scale * scaleX,
			sy =  scale * scaleY,
			x = 0.0, y = 0.0;

		buffer.g2.color = (color);
			
		while (y < _height)
		{
			while (x < _width)
			{
				if(angle != 0)
				buffer.g2.pushRotation(angle,x + Std.int(this.point.x *sx) + (_sourceRect.width * sx * 0.5),y + Std.int(this.point.y *sy) + (_sourceRect.height * sy * 0.5));

				buffer.g2.drawScaledSubImage(_source,
				_sourceRect.x, 
				_sourceRect.y,
				_sourceRect.width,
				_sourceRect.height ,
				this.point.x + x * sx ,
				this.point.y + y * sy,
				_sourceRect.width * sx,
				_sourceRect.height * sy);
				
				if(angle != 0)
				buffer.g2.popTransformation();
				
				x += _sourceRect.width;
			}
			x = 0;
			y += _sourceRect.height;
		}
		
		
		buffer.g2.color = (Color.White);
	}


	// Drawing information.
	private var _width:Int;
	private var _height:Int;
	
	public var repeatWidth(get, set ) : Int;
	private function get_repeatWidth():Int { return _width; }
	private function set_repeatWidth(value:Int):Int
	{
		if (_width == value) return value;
		_width = value;
		return _width;
	}
	
	public var repeatHeight(get, set) : Int;
	private function get_repeatHeight():Int { return _height; }
	private function set_repeatHeight(value:Int):Int
	{
		if (_height == value) return value;
		_height = value;
		return _height;
	}
}