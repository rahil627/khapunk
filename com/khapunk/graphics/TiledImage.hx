package com.khapunk.graphics;


import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.KP;
import com.khapunk.Graphic;
import kha.Canvas;
import kha.Color;
import kha.Image;
import kha.math.Vector2;
import kha.Rectangle;

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
		
		_offsetX = _offsetY = 0;
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

		buffer.g2.set_color(color);
			
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
		
		
		buffer.g2.set_color(Color.White);
	}

	/**
	 * The x-offset of the texture.
	 */
	public var offsetX(get, set):Float;
	private function get_offsetX():Float { return _offsetX; }
	private function set_offsetX(value:Float):Float
	{
		if (_offsetX == value) return value;
		_offsetX = value;
		return _offsetX;
	}

	/**
	 * The y-offset of the texture.
	 */
	public var offsetY(get, set):Float;
	private function get_offsetY():Float { return _offsetY; }
	private function set_offsetY(value:Float):Float
	{
		if (_offsetY == value) return value;
		_offsetY = value;
		return _offsetY;
	}

	/**
	 * Sets the texture offset.
	 * @param	x		The x-offset.
	 * @param	y		The y-offset.
	 */
	public function setOffset(x:Float, y:Float)
	{
		if (_offsetX == x && _offsetY == y) return;
		_offsetX = x;
		_offsetY = y;
	}

	// Drawing information.
	private var _width:Int;
	private var _height:Int;
	private var _offsetX:Float;
	private var _offsetY:Float;
}