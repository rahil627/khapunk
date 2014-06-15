package com.khapunk.graphics;
import com.khapunk.graphics.atlas.TextureAtlas;
import com.khapunk.graphics.atlas.TextureAtlas.AtlasRegion;
import kha.Color;
import kha.Image;
import kha.Loader;
import kha.math.Vector2;
import kha.Painter;
import kha.Rectangle;

/**
 * ...
 * @author ...
 */
class PunkImage extends Graphic
{


	// Source and buffer information.
	private var _source:Image;
	private var _sourceRect:Rectangle;
	private var _bufferRect:Rectangle;
	private var _region:AtlasRegion;

	// Color and alpha information.
	private var _alpha:Float;
	private var _color:Int;
	private var _tint:Color;
	//private var _colorTransform:ColorTransform;
	//private var _matrix:Matrix;
	private var _red:Float;
	private var _green:Float;
	private var _blue:Float;

	// Flipped image information.
	private var _class:String;
	private var _flipped:Bool;
	//private var _flip:BitmapData;
	//private static var _flips:Map<String,BitmapData> = new Map<String,BitmapData>();

	private var _scale:Float;
	

	/**
	 * Rotation of the image, in degrees.
	 */
	public var angle:Float;

	/**
	 * Scale of the image, effects both x and y scale.
	 */
	public var scale(get, set):Float;
	private function get_scale():Float { return _scale; }
	private function set_scale(value:Float):Float { return _scale = value; }

	/**
	 * X scale of the image.
	 */
	public var scaleX:Float;

	/**
	 * Y scale of the image.
	 */
	public var scaleY:Float;

	/**
	 * X origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originX:Float;

	/**
	 * Y origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originY:Float;

	
	
	
	/**
	 * Constructor.
	 * @param	source		Source image.
	 * @param	clipRect	Optional rectangle defining area of the source image to draw.
	 * @param	name		Optional name, necessary to identify the bitmapData if you are using flipped
	 */
	public function new(source:Dynamic, clipRect:Rectangle = null, name:String = "")
	{
		super();
		init();

		_sourceRect = new Rectangle(0, 0, 0, 0);
		
		// check if the _source or _region were set in a higher class
		if (_source == null && _region == null)
		{
			_class = name;
			if (Std.is(source, TextureAtlas))
			{
				setAtlasRegion(cast(source, TextureAtlas).getRegion(name));
			}
			else if (Std.is(source, AtlasRegion))
			{
				setAtlasRegion(source);
			}
			/*else if (Std.is(source, TileAtlas))
			{
				setAtlasRegion(cast(source, TileAtlas).getRegion(0));
			}*/
			else if (Std.is(source, Image))
			{
				setBitmapSource(source);
			}
			else if (Std.is(source, String)){
				
				setBitmapSource(Loader.the.getImage(source));
			}

			if (_source == null && _region == null)
				throw "Invalid source image.";
		}

		if (clipRect != null)
		{
			if (clipRect.width == 0) clipRect.width = _sourceRect.width;
			if (clipRect.height == 0) clipRect.height = _sourceRect.height;
			_sourceRect = clipRect;
		}
	}
	
	private inline function setAtlasRegion(region:AtlasRegion)
	{
		_region = region;
		_sourceRect = new Rectangle(0, 0, _region.w, _region.h);
	}
	
	private inline function setBitmapSource(image:Image)
	{
		_sourceRect.width = image.width;
		_sourceRect.height = image.height;
		_source = image;
	}
	
	/** @private Initialize variables */
	private inline function init()
	{
		angle = 0;
		scale = scaleX = scaleY = 1;
		originX = originY = 0;

		_alpha = 1;
		_flipped = false;
		_color = 0x00FFFFFF;
		_red = _green = _blue = 1;
		//_matrix = HXP.matrix;
	}
	
	/** Renders the image. */
	override public function render(painter:Painter, point:Vector2, camera:Vector2)
	{
		
		var sx = scale * scaleX,
			sy = scale * scaleY;

		// determine drawing location
		this.point.x = point.x + x - originX - camera.x * scrollX;
		this.point.y = point.y + y - originY - camera.y * scrollY;

		if (angle == 0 && sx == 1 && sy == 1)
		{
			painter.drawImage(_source, this.point.x, this.point.y);
		}
		else
		{
			painter.drawImage2(
			_source,
			_sourceRect.x,
			_sourceRect.y,
			_sourceRect.width,
			_sourceRect.height,
			this.point.x,
			this.point.y,
			_sourceRect.width * scaleX,
			_sourceRect.height * scaleY);
		}
	
	}
	
	/**
	 * Change the opacity of the Image, a value from 0 to 1.
	 */
	public var alpha(get, set):Float;
	private function get_alpha():Float { return _alpha; }
	private function set_alpha(value:Float):Float
	{
		value = value < 0 ? 0 : (value > 1 ? 1 : value);
		if (_alpha == value) return value;
		_alpha = value;
		
		return _alpha;
	}
	
	/**
	 * The tinted color of the Image. Use 0xFFFFFF to draw the Image normally.
	 */
	public var color(get, set):Int;
	private function get_color():Int { return _color; }
	private function set_color(value:Int):Int
	{
		value &= 0xFFFFFF;
		if (_color == value) return value;
		_color = value;
		// save individual color channel values
		_red = HXP.getRed(_color) / 255;
		_green = HXP.getGreen(_color) / 255;
		_blue = HXP.getBlue(_color) / 255;
		
		return _color;
	}
	
	/**
	 * Centers the Image's originX/Y to its center.
	 */
	public function centerOrigin()
	{
		originX = Std.int(width / 2);
		originY = Std.int(height / 2);
	}
	
	/**
	 * Centers the Image's originX/Y to its center, and negates the offset by the same amount.
	 */
	public function centerOO()
	{
		x += originX;
		y += originY;
		centerOrigin();
		x -= originX;
		y -= originY;
	}
	
	/**
	 * Width of the image.
	 */
	public var width(get, never):Int;
	private function get_width():Int { return Std.int((!_region.rotated ? _region.w : _region.h)); }

	/**
	 * Height of the image.
	 */
	public var height(get, never):Int;
	private function get_height():Int { return Std.int((!_region.rotated ? _region.h : _region.w)); }
	
	/**
	 * The scaled width of the image.
	 */
	public var scaledWidth(get, set):Float;
	private function get_scaledWidth():Float { return width * scaleX * scale; }
	private function set_scaledWidth(w:Float):Float {
		scaleX = w / scale / width;
		return scaleX;
	}

	/**
	 * The scaled height of the image.
	 */
	public var scaledHeight(get, set):Float;
	private function get_scaledHeight():Float { return height * scaleY * scale; }
	private function set_scaledHeight(h:Float):Float {
		scaleY = h / scale / height;
		return scaleY;
	}
	
	/**
	 * Clipping rectangle for the image.
	 */
	public var clipRect(get, null):Rectangle;
	private function get_clipRect():Rectangle { return _sourceRect; }
}