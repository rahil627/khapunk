package com.khapunk;
import com.khapunk.masks.Masklist;
import com.khapunk.math.Projection;
import kha.math.Vector2;
import kha.Painter;

/**
 * ...
 * @author ...
*/

typedef MaskCallback = Dynamic -> Bool;


class Mask
{
	
	// Mask information.
	private var _class:String;
	private var check:Map<String,MaskCallback>;
	private var _parent:Entity;

	/**
	 * The parent Entity of this mask.
	 */
	public var parent(get,set):Entity;
	private inline function get_parent() : Entity
	{
		return _parent != Entity._EMPTY ? _parent : null;
	}
	private function set_parent(value:Entity) : Entity
	{
		if (value == null) { _parent = Entity._EMPTY; }
		else { _parent = value; update(); }
		return value;
	}

	/**
	 * The parent Masklist of the mask.
	 */
	public var list:Masklist;
	
	public function new() {
		_parent = Entity._EMPTY;
		_class = Type.getClassName(Type.getClass(this));
		check = new Map<String,MaskCallback>();
		check.set(Type.getClassName(Mask), collideMask);
		check.set(Type.getClassName(Masklist), collideMasklist);
	}
	
	/**
	 * Checks for collision with another Mask.
	 * @param	mask	The other Mask to check against.
	 * @return	If the Masks overlap.
	 */
	public function collide(mask:Mask):Bool
	{
		var cbFunc:MaskCallback = check.get(mask._class);
		if (cbFunc != null) return cbFunc(mask);

		cbFunc = mask.check.get(_class);
		if (cbFunc != null) return cbFunc(this);

		return false;
	}
	
	/** @private Collide against an Entity. */
	private function collideMask(other: Mask): Bool
	{
		return parent.x - parent.originX + parent.width > other.parent.x - other.parent.originX
			&& parent.y - parent.originY + parent.height > other.parent.y - other.parent.originY
			&& parent.x - parent.originX < other.parent.x - other.parent.originX + other.parent.width
			&& parent.y - parent.originY < other.parent.y - other.parent.originY + other.parent.height;
	}
	
	private function collideMasklist(other:Masklist):Bool
	{
		return other.collide(this);
	}
	
	
	/**
	 * Override this
	 */
	public function debugDraw(painter:Painter, scaleX:Float, scaleY:Float):Void
	{

	}

	/** Updates the parent's bounds for this mask. */
	public function update(): Void
	{

	}

	public function project(axis:Vector2, projection:Projection): Void
	{
		var cur:Float,
			max:Float = Math.NEGATIVE_INFINITY,
			min:Float = Math.POSITIVE_INFINITY;

		cur = -parent.originX * axis.x - parent.originY * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		cur = (-parent.originX + parent.width) * axis.x - parent.originY * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		cur = -parent.originX * axis.x + (-parent.originY + parent.height) * axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		cur = (-parent.originX + parent.width) * axis.x + (-parent.originY + parent.height)* axis.y;
		if (cur < min)
			min = cur;
		if (cur > max)
			max = cur;

		projection.min = min;
		projection.max = max;
	}
	
	
}