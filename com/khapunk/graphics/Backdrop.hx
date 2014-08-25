package com.khapunk.graphics;
import com.khapunk.Graphic;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.KP;
import kha.Color;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.Image;
import kha.math.Vector2;
import kha.Sys;

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
	
	/**
	 * Color to be multiplied
	 */
	public var color:Color;
	
	/**
	 * Determines if scrolling should be affected by the camera position.
	 */
	public var scrollByCam:Bool;
	
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
		_height = KP.height * (repeatY ? 1 : 0) + _textHeight ;
		
		scale = scaleX = scaleY = 1;
		angle = 0;
		scrollByCam = false;
		color = Color.White;
		super();
	}
	
	private inline function setAtlasRegion(region:AtlasRegion)
	{
		_region = region;
		_source = region.image;
		_textWidth = Std.int(region.w);
		_textHeight = Std.int(region.h);
	}

	private inline function setBitmapSource(bitmap:Image)
	{
		_region = new AtlasRegion();
		_region.x = 0;
		_region.y = 0;
		_source = bitmap;
		_textWidth = _source.width;
		_textHeight = _source.height;
	}
	
	override public function render(buffer:Graphics, point:Vector2, camera:Vector2)
	{
		
		this.point.x = point.x + x - (scrollByCam ? (camera.x * scrollX):0);
		this.point.y = point.y + y - (scrollByCam ? (camera.y * scrollY):0);

		var sx = scale * scaleX;
		var	sy = scale * scaleY;
		
		if (_repeatX)
		{
			this.point.x %= _textWidth;
			if (this.point.x > 0) this.point.x -= _textWidth ;
		}

		if (_repeatY)
		{
			this.point.y %= _textHeight;
			if (this.point.y > 0) this.point.y -= _textHeight;
		}
		
			//fsx = HXP.screen.fullScaleX,
			//fsy = HXP.screen.fullScaleY,
			//px:Int = Std.int(this.point.x * fsx), py:Int = Std.int(this.point.y * fsy);

		var y:Int = 0;
		//while (y < _height * sy * fsy)
		
		var stepX  = _textWidth * sx;
		var stepY  = _textHeight * sy;
		
		var ratioX  = _width / stepX;
		var ratioY  = _height / stepY;
		
		stepX = ratioX == Math.floor(ratioX) ? 0:stepX;
		stepY = ratioY == Math.floor(ratioY) ? 0:stepY;
		
		buffer.set_color(color);
		
		
		
		while (y < _height + stepY)
		{
			var x:Int = 0;
			//while (x < _width * sx * fsx)
			while (x < _width + stepX)
			{
				//_region.draw(px + x, py + y, layer, sx * fsx, sy * fsy, 0, _red, _green, _blue, _alpha);
				//x += Std.int(_textWidth * fsx);
				if(angle != 0)
				buffer.pushRotation(angle,x + Std.int(this.point.x *sx) + (_textWidth * sx * 0.5),y + Std.int(this.point.y *sy) + (_textHeight * sy * 0.5));
				
				
				buffer.drawScaledSubImage(_source, _region.x, _region.y,
				_textWidth,
				_textHeight,
				Std.int(this.point.x *sx) + x,
				Std.int(this.point.y *sy) + y,
				_textWidth * sx,
				_textHeight * sy);
				
				if(angle != 0)
				buffer.popTransformation();
				
				x += Std.int(_textWidth * sx );
			
			}
			//y += Std.int(_textHeight * fsy);
			y += Std.int(_textHeight * sy);
		}
		
		
		buffer.set_color(Color.White);
	}

	
	
	
}