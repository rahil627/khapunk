package com.khapunk.masks;
import com.khapunk.Mask;
import com.khapunk.math.Projection;
import kha.Canvas;
import kha.Color;
import kha.math.Vector2;

/**
 * ...
 * @author ...
 */
class Hitbox extends Mask
{

	// Hitbox information.
	private var _width:Int = 0;
	private var _height:Int = 0;
	private var _x:Int = 0;
	private var _y:Int = 0;
	
	/**
	 * Constructor.
	 * @param	width		Width of the hitbox.
	 * @param	height		Height of the hitbox.
	 * @param	x			X offset of the hitbox.
	 * @param	y			Y offset of the hitbox.
	 */
	public function new(width:Int = 1, height:Int = 1, x:Int = 0, y:Int = 0)
	{
		super();
		_width = width;
		_height = height;
		_x = x;
		_y = y;
		check.set(Type.getClassName(Hitbox), collideHitbox);
	}
	
	/** @private Collides against an Entity. */
	override private function collideMask(other:Mask):Bool
	{
		if (other._parent != null)
		{
			var px:Float = _x, py:Float = _y;
			if (_parent != null)
			{
				px += _parent.x;
				py += _parent.y;
			}

			var ox = other._parent.originX + other._parent.x,
				oy = other._parent.originY + other._parent.y;

			return px + _width > ox
				&& py + _height > oy
				&& px < ox + other._parent.width
				&& py < oy + other._parent.height;
		}
		return false;
	}
	
	/** @private Collides against a Hitbox. */
	private function collideHitbox(other:Hitbox):Bool
	{
		var px:Float = _x, py:Float = _y;
		if (_parent != null)
		{
			px += _parent.x;
			py += _parent.y;
		}

		var ox:Float = other._x, oy:Float = other._y;
		if (other._parent != null)
		{
			ox += other._parent.x;
			oy += other._parent.y;
		}

		return px + _width > ox
			&& py + _height > oy
			&& px < ox + other._width
			&& py < oy + other._height;
	}

	/**
	 * X offset.
	 */
	public var x(get, set):Int;
	private function get_x():Int { return _x; }
	private function set_x(value:Int):Int
	{
		if (_x == value) return value;
		_x = value;
		if (list != null) list.update();
		else if (_parent != null) update();
		return _x;
	}

	/**
	 * Y offset.
	 */
	public var y(get, set):Int;
	private function get_y():Int { return _y; }
	private function set_y(value:Int):Int
	{
		if (_y == value) return value;
		_y = value;
		if (list != null) list.update();
		else if (_parent != null) update();
		return _y;
	}

	/**
	 * Width.
	 */
	public var width(get, set):Int;
	private function get_width():Int { return _width; }
	private function set_width(value:Int):Int
	{
		if (_width == value) return value;
		_width = value;
		if (list != null) list.update();
		else if (_parent != null) update();
		return _width;
	}

	/**
	 * Height.
	 */
	public var height(get, set):Int;
	private function get_height():Int { return _height; }
	private function set_height(value:Int):Int
	{
		if (_height == value) return value;
		_height = value;
		if (list != null) list.update();
		else if (_parent != null) update();
		return _height;
	}

	/** Updates the _parent's bounds for this mask. */
	override public function update()
	{
		if (_parent != null)
		{
			// update entity bounds
			_parent.originX = -_x;
			_parent.originY = -_y;
			_parent.width = _width;
			_parent.height = _height;
			// update _parent list
			if (list != null)
				list.update();
		}
	}
	
	@:dox(hide)
	override public function project(axis:Vector2, projection:Projection):Void
	{
		var px = _x;
		var py = _y;
		var cur:Float,
			max:Float = Math.NEGATIVE_INFINITY,
			min:Float = Math.POSITIVE_INFINITY;

		cur = px * axis.x + py * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		cur = (px + _width) * axis.x + py * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		cur = px * axis.x + (py + _height) * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		cur = (px + _width) * axis.x + (py + _height) * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		projection.min = min;
		projection.max = max;
	}
	
	#if debug
	public override function debugDraw(buffer:Canvas):Void {
		
		if (parent != null)
		{
			buffer.g2.set_color(Color.fromValue(0xFF22BB1E));
			buffer.g2.drawRect((parent.x - KP.camera.x + x), (parent.y - KP.camera.y + y), width, height);
			buffer.g2.set_color(Color.White);
		}
	}
	#end
	
}