package com.khapunk.graphics;
import com.khapunk.Graphic;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.KP;
import kha.Image;
import kha.math.Vector2;
import kha.Painter;

/**
 * ...
 * @author Sidar Talei
 */
class Backdrop extends Graphic
{
		// Backdrop information.
	private var _source:Image;
	private var _region:AtlasRegion;
	private var _textWidth:Int;
	private var _textHeight:Int;
	private var _repeatX:Bool;
	private var _repeatY:Bool;
	private var _x:Float;
	private var _y:Float;
	private var _width:Int;
	private var _height:Int;

	
	/**
	 * Rotation of the canvas, in degrees.
	 */
	public var angle:Float;

	/**
	 * Scale of the canvas, effects both x and y scale.
	 */
	public var scale:Float;
	/**
	 * X scale of the canvas.
	 */
	public var scaleX:Float;

	/**
	 * Y scale of the canvas.
	 */
	public var scaleY:Float;
	
	public function new(source:Dynamic, repeatX:Bool = true, repeatY:Bool = true)
	{
		if (Std.is(source, AtlasRegion)){
			setAtlasRegion(cast(source, AtlasRegion));
		}
		else if (Std.is(source, Image)) {
			setBitmapSource(cast(source, Image));
		}

		_repeatX = repeatX;
		_repeatY = repeatY;

		_width = KP.width * (repeatX ? 1 : 0) + _textWidth;
		_height = KP.height * (repeatY ? 1 : 0) + _textHeight;
		scale = scaleX = scaleY = 1;
		angle = 0;
		super();
	}
	
	private inline function setAtlasRegion(region:AtlasRegion)
	{
		_source = region.image;
		_textWidth = Std.int(region.w);
		_textHeight = Std.int(region.h);
	}

	private inline function setBitmapSource(bitmap:Image)
	{
		_source = bitmap;
		_textWidth = _source.width;
		_textHeight = _source.height;
	}
	
	override public function render(painter:Painter, point:Vector2, camera:Vector2)
	{
		this.point.x = point.x + x - camera.x * scrollX;
		this.point.y = point.y + y - camera.y * scrollY;

		if (_repeatX)
		{
			this.point.x %= _textWidth;
			if (this.point.x > 0) this.point.x -= _textWidth;
		}

		if (_repeatY)
		{
			this.point.y %= _textHeight;
			if (this.point.y > 0) this.point.y -= _textHeight;
		}

		var sx = scale * scaleX;
		var	sy = scale * scaleY;
			//fsx = HXP.screen.fullScaleX,
			//fsy = HXP.screen.fullScaleY,
			//px:Int = Std.int(this.point.x * fsx), py:Int = Std.int(this.point.y * fsy);

		var y:Int = 0;
		//while (y < _height * sy * fsy)
		while (y < _height * sy )
		{
			var x:Int = 0;
			//while (x < _width * sx * fsx)
			while (x < _width * sx)
			{
				//_region.draw(px + x, py + y, layer, sx * fsx, sy * fsy, 0, _red, _green, _blue, _alpha);
				//x += Std.int(_textWidth * fsx);
				painter.drawImage2(_source, 0, 0,
				_textWidth,
				_textHeight,
				this.point.x + x,
				this.point.y + y,
				_textWidth * sx,
				_textHeight * sy,
				angle,
				_textWidth * 0.5,
				_textHeight* 0.5);
				
				x += Std.int(_textWidth);
			}
			//y += Std.int(_textHeight * fsy);
			y += Std.int(_textHeight);
		}
	}

	
	
	
}