package com.khapunk.masks;
import com.khapunk.math.Projection;
import kha.math.Vector2;
import kha.Painter;

/**
 * ...
 * @author ...
 */
class Polygon extends Hitbox
{
	// Hitbox information.
	private var _angle:Float;
	private var _points:Array<Vector2>;
	private var _axes:Array<Vector2>;

	private var _fakeEntity:Entity;				// used for Grid and Pixelmask collision
	private var _fakeTileHitbox:Hitbox;			// used for Grid collision

	private var _indicesToRemove:Array<Int>;	// used in removeDuplicateAxes()

	private static var firstProj = new Projection();
	private static var secondProj = new Projection();

	public static var vertical = new Vector(0, 1);
	public static var horizontal = new Vector(1, 0);
	
	/**
	* The polygon rotates around this point when the angle is set.
	*/
	public var origin:Vector2;

	/**
	 * Constructor.
	 * @param	points		An array of coordinates that define the polygon (must have at least 3).
	 * @param	origin	 	Pivot point for rotations.
	 */
	public function new(points:Array<Vector2>, ?origin:Vector2)
	{
		super();
		if (points.length < 3) throw "The polygon needs at least 3 sides.";
		_points = points;

		_fakeEntity = new Entity();
		_fakeTileHitbox = new Hitbox();

		check.set(Type.getClassName(Mask), collideMask);
		check.set(Type.getClassName(Hitbox), collideHitbox);
		check.set(Type.getClassName(Grid), collideGrid);
		check.set(Type.getClassName(Circle), collideCircle);
		check.set(Type.getClassName(Polygon), collidePolygon);

		this.origin = origin != null ? origin : new Vector2();
		_angle = 0;

		updateAxes();
	}
	
	/**
	 * Checks for collisions with an Entity.
	 */
	override private function collideMask(other:Mask):Bool
	{
		var offset:Float,
			offsetX:Float = parent.x + _x - other.parent.x,
			offsetY:Float = parent.y + _y - other.parent.y;

		// project on the vertical axis of the hitbox/mask
		project(vertical, firstProj);
		other.project(vertical, secondProj);

		firstProj.min += offsetY;
		firstProj.max += offsetY;

		// if firstProj not overlaps secondProj
		if (!firstProj.overlaps(secondProj))
		{
			return false;
		}

		// project on the horizontal axis of the hitbox/mask
		project(horizontal, firstProj);
		other.project(horizontal, secondProj);

		firstProj.min += offsetX;
		firstProj.max += offsetX;

		// if firstProj not overlaps secondProj
		if (!firstProj.overlaps(secondProj))
		{
			return false;
		}

		// project hitbox/mask on polygon axes
		// for a collision to be present all projections must overlap
		for (a in _axes)
		{
			project(a, firstProj);
			other.project(a, secondProj);

			offset = offsetX * a.x + offsetY * a.y;
			firstProj.min += offset;
			firstProj.max += offset;

			// if firstProj not overlaps secondProj
			if (!firstProj.overlaps(secondProj))
			{
				return false;
			}
		}
		return true;
	}
	
	/**
	 * Checks for collisions with a Hitbox.
	 */
	override private function collideHitbox(hitbox:Hitbox):Bool
	{
		var offset:Float,
			offsetX:Float = parent.x + _x - hitbox.parent.x,
			offsetY:Float = parent.y + _y - hitbox.parent.y;

		// project on the vertical axis of the hitbox
		project(vertical, firstProj);
		hitbox.project(vertical, secondProj);

		firstProj.min += offsetY;
		firstProj.max += offsetY;

		// if firstProj not overlaps secondProj
		if (!firstProj.overlaps(secondProj))
		{
			return false;
		}

		// project on the horizontal axis of the hitbox
		project(horizontal, firstProj);
		hitbox.project(horizontal, secondProj);

		firstProj.min += offsetX;
		firstProj.max += offsetX;

		// if firstProj not overlaps secondProj
		if (!firstProj.overlaps(secondProj))
		{
			return false;
		}

		// project hitbox on polygon axes
		// for a collision to be present all projections must overlap
		for (a in _axes)
		{
			project(a, firstProj);
			hitbox.project(a, secondProj);

			offset = offsetX * a.x + offsetY * a.y;
			firstProj.min += offset;
			firstProj.max += offset;

			// if firstProj not overlaps secondProj
			if (!firstProj.overlaps(secondProj))
			{
				return false;
			}
		}
		return true;
	}

	/**
	 * Checks for collisions with a Grid.
	 * May be slow, added for completeness sake.
	 *
	 * Internally sets up an Hitbox out of each solid Grid tile and uses that for collision check.
	 */
	private function collideGrid(grid:Grid):Bool
	{
		var tileW:Int = grid.tileWidth;
		var tileH:Int = grid.tileHeight;
		var solidTile:Bool;

		_fakeEntity.width = tileW;
		_fakeEntity.height = tileH;
		_fakeEntity.x = parent.x;
		_fakeEntity.y = parent.y;
		_fakeEntity.originX = grid.parent.originX + grid._x;
		_fakeEntity.originY = grid.parent.originY + grid._y;

		_fakeTileHitbox._width = tileW;
		_fakeTileHitbox._height = tileH;
		_fakeTileHitbox.parent = _fakeEntity;

		for (r in 0...grid.rows)
		{
			for (c in 0...grid.columns)
			{
				_fakeEntity.x = grid.parent.x + grid._x + c * tileW;
				_fakeEntity.y = grid.parent.y + grid._y + r * tileH;
				solidTile = grid.getTile(c, r);

				if (solidTile && collideHitbox(_fakeTileHitbox)) return true;
			}
		}
		return false;
	}
	
	/**
	 * Checks for collision with a circle.
	 */
	private function collideCircle(circle:Circle):Bool
	{
		var edgesCrossed:Int = 0;
		var p1:Vector2, p2:Vector2;
		var i:Int, j:Int;
		var nPoints:Int = _points.length;
		var offsetX:Float = parent.x + _x;
		var offsetY:Float = parent.y + _y;


		// check if circle center is inside the polygon
		i = 0;
		j = nPoints - 1;
		while (i < nPoints)
		{
			p1 = _points[i];
			p2 = _points[j];

			var distFromCenter:Float = (p2.x - p1.x) * (circle._y + circle.parent.y - p1.y - offsetY) / (p2.y - p1.y) + p1.x + offsetX;

			if ((p1.y + offsetY > circle._y + circle.parent.y) != (p2.y + offsetY > circle._y + circle.parent.y)
				&& (circle._x + circle.parent.x < distFromCenter))
			{
				edgesCrossed++;
			}
			j = i;
			i++;
		}

		if (edgesCrossed & 1 > 0) return true;

		// check if minimum distance from circle center to each polygon side is less than radius
		var radiusSqr:Float = circle.radius * circle.radius;
		var cx:Float = circle._x + circle.parent.x;
		var cy:Float = circle._y + circle.parent.y;
		var minDistanceSqr:Float = 0;
		var closestX:Float;
		var closestY:Float;

		i = 0;
		j = nPoints - 1;
		while (i < nPoints)
		{
			p1 = _points[i];
			p2 = _points[j];

			var segmentLenSqr:Float = (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);

			// find projection of center onto line (extended segment)
			var t:Float = ((cx - p1.x - offsetX) * (p2.x - p1.x) + (cy - p1.y - offsetY) * (p2.y - p1.y)) / segmentLenSqr;

			if (t < 0)
			{
				closestX = p1.x;
				closestY = p1.y;
			}
			else if (t > 1)
			{
				closestX = p2.x;
				closestY = p2.y;
			}
			else
			{
				closestX = p1.x + t * (p2.x - p1.x);
				closestY = p1.y + t * (p2.y - p1.y);
			}
			closestX += offsetX;
			closestY += offsetY;

			minDistanceSqr = (cx - closestX) * (cx - closestX) + (cy - closestY) * (cy - closestY);

			if (minDistanceSqr <= radiusSqr) return true;

			j = i;
			i++;
		}

		return false;
	}
	
	/**
	 * Checks for collision with a polygon.
	 */
	private function collidePolygon(other:Polygon):Bool
	{
		var offset:Float;
		var offsetX:Float = parent.x + _x - other.parent.x;
		var offsetY:Float = parent.y + _y - other.parent.y;

		// project other on this polygon axes
		// for a collision to be present all projections must overlap
		for (a in _axes)
		{
			project(a, firstProj);
			other.project(a, secondProj);

			// shift the first info with the offset
			offset = offsetX * a.x + offsetY * a.y;
			firstProj.min += offset;
			firstProj.max += offset;

			// if firstProj not overlaps secondProj
			if (!firstProj.overlaps(secondProj))
			{
				return false;
			}
		}

		// project this polygon on other polygon axes
		// for a collision to be present all projections must overlap
		for (a in other._axes)
		{
			project(a, firstProj);
			other.project(a, secondProj);

			// shift the first info with the offset
			offset = offsetX * a.x + offsetY * a.y;
			firstProj.min += offset;
			firstProj.max += offset;

			// if firstProj not overlaps secondProj
			if (!firstProj.overlaps(secondProj))
			{
				return false;
			}
		}
		return true;
	}
	
	/** Projects this polygon points on axis and returns min and max values in projection object. */
	override public function project(axis:Vector2, projection:Projection):Void
	{
		var p:Vector2 = _points[0];

		var min:Float = axis.dot(p),
			max:Float = min;

		for (i in 1..._points.length)
		{
			p = _points[i];
			var cur:Float = axis.dot(p);

			if (cur < min)
			{
				min = cur;
			}
			else if (cur > max)
			{
				max = cur;
			}
		}
		projection.min = min;
		projection.max = max;
	}
	
	override public function debugDraw(painter:Painter, scaleX:Float, scaleY:Float):Void
	{
		
		/** TODO Debug draw*/
		/*if (parent != null)
		{
			var	offsetX:Float = parent.x + _x - HXP.camera.x,
				offsetY:Float = parent.y + _y - HXP.camera.y;

			graphics.beginFill(0x0000FF, .3);

			graphics.moveTo((points[_points.length - 1].x + offsetX) * scaleX , (_points[_points.length - 1].y + offsetY) * scaleY);
			for (i in 0..._points.length)
			{
				graphics.lineTo((_points[i].x + offsetX) * scaleX, (_points[i].y + offsetY) * scaleY);
			}

			graphics.endFill();

			// draw pivot
			graphics.drawCircle((offsetX + origin.x) * scaleX, (offsetY + origin.y) * scaleY, 2);
		}*/
	}
	
	/**
	 * Rotation angle (in degrees) of the polygon (rotates around origin point).
	 */
	public var angle(get, set):Float;
	private inline function get_angle():Float { return _angle; }
	private function set_angle(value:Float):Float
	{
		if (value != _angle)
		{
			rotate(value - _angle);
			if (list != null || parent != null) update();
		}
		return value;
	}
	
	/**
	 * The points representing the polygon.
	 *
	 * If you need to set a point yourself instead of passing in a new Array<Point> you need to call update()
	 * to make sure the axes update as well.
	 */
	public var points(get, set):Array<Vector2>;
	private inline function get_points():Array<Vector2> { return _points; }
	private function set_points(value:Array<Vector2>):Array<Vector2>
	{
		if (_points != value)
		{
			_points = value;
			if (list != null || parent != null) updateAxes();
		}
		return value;
	}
	
	/** Updates the parent's bounds for this mask. */
	override public function update():Void
	{
		project(horizontal, firstProj); // width
		var projX:Int = Math.round(firstProj.min);
		_width = Math.round(firstProj.max - firstProj.min);
		project(vertical, secondProj); // height
		var projY:Int = Math.round(secondProj.min);
		_height = Math.round(secondProj.max - secondProj.min);

		if (list != null)
		{
			// update parent list
			list.update();
		}
		else if (parent != null)
		{
			parent.originX = -_x - projX;
			parent.originY = -_y - projY;
			parent.width = _width;
			parent.height = _height;
		}

	}
	
	/**
	 * Creates a regular polygon (edges of same length).
	 * @param	sides	The number of sides in the polygon.
	 * @param	radius	The distance that the vertices are at.
	 * @param	angle	How much the polygon is rotated (in degrees).
	 * @return	The polygon
	 */
	public static function createPolygon(sides:Int = 3, radius:Float = 100, angle:Float = 0):Polygon
	{
		if (sides < 3) throw "The polygon needs at least 3 sides.";

		// figure out the angle required for each step
		var rotationAngle:Float = (Math.PI * 2) / sides;

		// loop through and generate each point
		var points:Array<Point> = new Array<Point>();

		for (i in 0...sides)
		{
			var tempAngle:Float = Math.PI + i * rotationAngle;
			var p:Vector2 = new Vector2();
			p.x = Math.cos(tempAngle) * radius + radius;
			p.y = Math.sin(tempAngle) * radius + radius;
			points.push(p);
		}

		// return the polygon
		var poly:Polygon = new Polygon(points);
		poly.origin.x = radius;
		poly.origin.y = radius;
		poly.angle = angle;
		return poly;
	}
	
	/**
	 * Creates a polygon from an array were even numbers are x and odd are y
	 * @param	points	Array containing the polygon's points.
	 *
	 * @return	The polygon
	 */
	public static function createFromArray(points:Array<Float>):Polygon
	{
		var p:Array<Point> = new Array<Point>();

		var i:Int = 0;
		while (i < points.length)
		{
			p.push(new Point(points[i++], points[i++]));
		}
		return new Polygon(p);
	}
	
	private function rotate(angleDelta:Float):Void
	{
		_angle += angleDelta;

		angleDelta *= HXP.RAD;

		var p:Vector2;

		for (i in 0..._points.length)
		{
			p = _points[i];
			var dx:Float = p.x - origin.x;
			var dy:Float = p.y - origin.y;

			var pointAngle:Float = Math.atan2(dy, dx);
			var length:Float = Math.sqrt(dx * dx + dy * dy);

			p.x = Math.cos(pointAngle + angleDelta) * length + origin.x;
			p.y = Math.sin(pointAngle + angleDelta) * length + origin.y;
		}

		for (a in _axes)
		{
			var axisAngle:Float = Math.atan2(a.y, a.x);

			a.x = Math.cos(axisAngle + angleDelta);
			a.y = Math.sin(axisAngle + angleDelta);
		}
	}
	
	private function generateAxes():Void
	{
		_axes = new Array<Vector>();
		_indicesToRemove = new Array<Int>();

		var temp:Float;
		var nPoints:Int = _points.length;
		var edge:Vector;
		var i:Int, j:Int;

		i = 0;
		j = nPoints - 1;
		while (i < nPoints)
		{
			edge = new Vector();
			edge.x = _points[i].x - _points[j].x;
			edge.y = _points[i].y - _points[j].y;

			// get the axis which is perpendicular to the edge
			temp = edge.y;
			edge.y = -edge.x;
			edge.x = temp;
			edge.normalize(1);

			_axes.push(edge);

			j = i;
			i++;
		}
	}
	
	private function removeDuplicateAxes():Void
	{
		var nAxes:Int = _axes.length;
		HXP.clear(_indicesToRemove);

		for (i in 0...nAxes)
		{
			for (j in 0...nAxes)
			{
				if (i == j || Math.max(i, j) >= nAxes) continue;

				// if the first vector is equal or similar to the second vector,
				// add it to the remove list. (for example, [1, 1] and [-1, -1]
				// represent the same axis)
				if ((_axes[i].x == _axes[j].x && _axes[i].y == _axes[j].y)
					|| ( -_axes[i].x == _axes[j].x && -_axes[i].y == _axes[j].y))	// first axis inverted
				{
					_indicesToRemove.push(j);
				}
			}
		}

		// remove duplicate axes
		var indexToRemove:Null<Int>;
		while ((indexToRemove = _indicesToRemove.pop()) != null) _axes.splice(indexToRemove, 1);
	}

	private function updateAxes():Void
	{
		generateAxes();
		removeDuplicateAxes();
		update();
	}
	
}