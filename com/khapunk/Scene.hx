package com.khapunk;
import kha.math.Vector2;
import kha.Mouse;
import kha.Painter;

/**
 * ...
 * @author ...
 */
class Scene
{
	// Adding and removal.
	private var _add:Array<Entity>;
	private var _remove:Array<Entity>;
	private var _recycle:Array<Entity>;

	// Update information.
	private var updateFirst:Entity;
	private var _count:Int;

	// Render information.
	private var _layerSort:Bool;
	private var layerList:Array<Int>;
	private var layerDisplay:Map<Int,Bool>;
	private var _layerCount:Map<Int, Int>;

	private var renderFirst:Map<Int,Entity>;
	private var renderLast:Map<Int,Entity>;

	private var _classCount:Map<String,Int>;

	@:allow(com.khapunk.Entity)
	private var _typeFirst:Map<String,Entity>;
	private var _typeCount:Map<String,Int>;

	private var recycled:Map<String,Entity>;
	private var entityNames:Map<String,Entity>;
	

	public var active:Bool = true;
	
	/**
	 * If the render() loop is performed.
	 */
	public var visible:Bool = true;

	/**
	 * Point used to determine drawing offset in the render loop.
	 */
	public var camera:Vector2;
	
	public function new() 
	{
		visible = true;
		camera = new Vector2();
		_count = 0;

		layerList = new Array<Int>();
		_layerCount = new Map<Int, Int>();

		_add = new Array<Entity>();
		_remove = new Array<Entity>();
		_recycle = new Array<Entity>();

		layerDisplay = new Map<Int,Bool>();
		renderFirst = new Map<Int,Entity>();
		renderLast = new Map<Int,Entity>();
		_typeFirst = new Map<String,Entity>();

		_classCount = new Map<String,Int>();
		_typeCount = new Map<String,Int>();
		recycled = new Map<String,Entity>();
		entityNames = new Map<String,Entity>();
	}
	
	/**
	 * Override this; called when Scene is switch to, and set to the currently active scene.
	 */
	public function begin() { }

	/**
	 * Override this; called when Scene is changed, and the active scene is no longer this.
	 */
	public function end() { }

	/**
	 * Override this, called when game gains focus
	 */
	public function focusGained() { }

	/**
	 * Override this, called when game loses focus
	 */
	public function focusLost() { }
	
	/**
	 * Performed by the game loop, updates all contained Entities.
	 * If you override this to give your Scene update code, remember
	 * to call super.update() or your Entities will not be updated.
	 */
	public function update() : Void
	{
		// update the entities
		var e:Entity = updateFirst;
		while (e != null)
		{
			if (e.active)
			{
				//if (e.hasTween) e.updateTweens();
				e.update();
			}
			if (e.graphic != null && e.graphic.active) e.graphic.update();
			e = e.updateNext;
		}
	}

	/**
	 * Toggles the visibility of a layer
	 * @param layer the layer to show/hide
	 * @param show whether to show the layer (default: true)
	 */
	public inline function showLayer(layer:Int, show:Bool=true): Void
	{
		layerDisplay.set(layer, show);
	}
	
	/**
	 * Checks if a layer is visible or not
	 */
	public inline function layerVisible(layer:Int): Bool
	{
		return !layerDisplay.exists(layer) || layerDisplay.get(layer);
	}
	
	/**
	 * Sorts layer from highest value to lowest
	 */
	private function layerSort(a:Int, b:Int):Int
	{
		return b - a;
	}
	
	/**
	 * Performed by the game loop, renders all contained Entities.
	 * If you override this to give your Scene render code, remember
	 * to call super.render() or your Entities will not be rendered.
	 */
	public function render(painter:Painter) : Void
	{	

	 
		// sort the depth list
		if (_layerSort)
		{
			if (layerList.length > 1) layerList.sort(layerSort);
			_layerSort = false;
		}

		//if (KXP.renderMode == RenderMode.HARDWARE)
			//AtlasData.startScene(this);

		// render the entities in order of depth
		var e:Entity;
		for (layer in layerList)
		{
			if (!layerVisible(layer)) continue;
			e = renderLast.get(layer);
			while (e != null)
			{
				
				if (e.visible) e.render(painter);
				e = e.renderPrev;
			}
		}

		//if (KXP.renderMode == RenderMode.HARDWARE)
		//	AtlasData.endScene();
		
	}
	
	/**
	 * TODO Fix input
	 * X position of the mouse in the Scene.
	 */
	public var mouseX(get, null):Int;
	private inline function get_mouseX():Int
	{
		//return Std.int(KXP.screen.mouseX + camera.x);
		return 0;
	}

	/**
	 * Y position of the mouse in the scene.
	 */
	public var mouseY(get, null):Int;
	private inline function get_mouseY():Int
	{
		//return Std.int(KXP.screen.mouseY + camera.y);
		return 0;
	}
	
	/**
	 * Adds the Entity to the Scene at the end of the frame.
	 * @param	e		Entity object you want to add.
	 * @return	The added Entity object.
	 */
	public function add<E:Entity>(e:E):E
	{
		_add[_add.length] = e;
		return e;
	}
	
	/**
	 * Removes the Entity from the Scene at the end of the frame.
	 * @param	e		Entity object you want to remove.
	 * @return	The removed Entity object.
	 */
	public function remove<E:Entity>(e:E):E
	{
		_remove[_remove.length] = e;
		return e;
	}

	/**
	 * Removes all Entities from the Scene at the end of the frame.
	 */
	public function removeAll()
	{
		var e:Entity = updateFirst;
		while (e != null)
		{
			_remove[_remove.length] = e;
			e = e.updateNext;
		}
	}
	
	
	/**
	 * Adds multiple Entities to the scene.
	 * @param	...list		Several Entities (as arguments) or an Array/Vector of Entities.
	 */
	public function addList<E:Entity>(list:Iterable<E>)
	{
		for (e in list) add(e);
	}
	
	/**
	 * Removes multiple Entities from the scene.
	 * @param	...list		Several Entities (as arguments) or an Array/Vector of Entities.
	 */
	public function removeList<E:Entity>(list:Iterable<E>)
	{
		for (e in list) remove(e);
	}
	
	/**
	 * Adds an Entity to the Scene with the Graphic object.
	 * @param	graphic		Graphic to assign the Entity.
	 * @param	x			X position of the Entity.
	 * @param	y			Y position of the Entity.
	 * @param	layer		Layer of the Entity.
	 * @return	The Entity that was added.
	 */
	public function addGraphic(graphic:Graphic, layer:Int = 0, x:Float = 0, y:Float = 0):Entity
	{
		var e:Entity = new Entity(x, y, graphic);
		e._layer = layer;
		e.active = false;
		return add(e);
	}
	
	/**
	 * Adds an Entity to the Scene with the Mask object.
	 * @param	mask	Mask to assign the Entity.
	 * @param	type	Collision type of the Entity.
	 * @param	x		X position of the Entity.
	 * @param	y		Y position of the Entity.
	 * @return	The Entity that was added.
	 */
	public function addMask(mask:Mask, type:String, x:Int = 0, y:Int = 0):Entity
	{
		var e:Entity = new Entity(x, y, null, mask);
		if (type != "") e.type = type;
		e.active = e.visible = false;
		return add(e);
	}
	
	/**
	 * Returns a new Entity, or a stored recycled Entity if one exists.
	 * @param	classType			The Class of the Entity you want to add.
	 * @param	addToScene			Add it to the Scene immediately.
	 * @param	constructorsArgs	List of the entity constructor arguments (optional).
	 * @return	The new Entity object.
	 */
	public function create<E:Entity>(classType:Class<E>, addToScene:Bool = true, ?constructorsArgs:Array<Dynamic>):E
	{
		var className:String = Type.getClassName(classType);
		var e:Entity = recycled.get(className);
		if (e != null)
		{
			recycled.set(className, e.recycleNext);
			e.recycleNext = null;
		}
		else
		{
			if (constructorsArgs != null)
				e = Type.createInstance(classType, constructorsArgs);
			else
				e = Type.createInstance(classType, []);
		}

		return cast (addToScene ? add(e) : e);
	}
	
	/**
	 * Removes the Entity from the Scene at the end of the frame and recycles it.
	 * The recycled Entity can then be fetched again by calling the create() function.
	 * @param	e		The Entity to recycle.
	 * @return	The recycled Entity.
	 */
	public function recycle<E:Entity>(e:E):E
	{
		_recycle[_recycle.length] = e;
		return remove(e);
	}
	
	/**
	 * Clears stored reycled Entities of the Class type.
	 * @param	classType		The Class type to clear.
	 */
	public function clearRecycled<E:Entity>(classType:Class<E>)
	{
		var className:String = Type.getClassName(classType),
			e:Entity = recycled.get(className),
			n:Entity;
		while (e != null)
		{
			n = e.recycleNext;
			e.recycleNext = null;
			e = n;
		}
		recycled.remove(className);
	}
	
	/**
	 * Clears stored recycled Entities of all Class types.
	 */
	public function clearRecycledAll()
	{
		var e:Entity;
		for (e in recycled)
		{
			clearRecycled(Type.getClass(e));
		}
	}
	
	/**
	 * Brings the Entity to the front of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function bringToFront(e:Entity):Bool
	{
		if (e._scene != this || e.renderPrev == null) return false;
		// pull from list
		e.renderPrev.renderNext = e.renderNext;
		if (e.renderNext != null) e.renderNext.renderPrev = e.renderPrev;
		else renderLast.set(e._layer, e.renderPrev);
		// place at the start
		e.renderNext = renderFirst.get(e._layer);
		e.renderNext.renderPrev = e;
		renderFirst.set(e._layer, e);
		e.renderPrev = null;
		return true;
	}
	
	/**
	 * Sends the Entity to the back of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function sendToBack(e:Entity):Bool
	{
		if (e._scene != this || e.renderNext == null) return false;
		// pull from list
		e.renderNext.renderPrev = e.renderPrev;
		if (e.renderPrev != null) e.renderPrev.renderNext = e.renderNext;
		else renderFirst.set(e._layer, e.renderNext);
		// place at the end
		e.renderPrev = renderLast.get(e._layer);
		e.renderPrev.renderNext = e;
		renderLast.set(e._layer, e);
		e.renderNext = null;
		return true;
	}
	
	/**
	 * Shifts the Entity one place towards the front of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function bringForward(e:Entity):Bool
	{
		if (e._scene != this || e.renderPrev == null) return false;
		// pull from list
		e.renderPrev.renderNext = e.renderNext;
		if (e.renderNext != null) e.renderNext.renderPrev = e.renderPrev;
		else renderLast.set(e._layer, e.renderPrev);
		// shift towards the front
		e.renderNext = e.renderPrev;
		e.renderPrev = e.renderPrev.renderPrev;
		e.renderNext.renderPrev = e;
		if (e.renderPrev != null) e.renderPrev.renderNext = e;
		else renderFirst.set(e._layer, e);
		return true;
	}
	
	/**
	 * Shifts the Entity one place towards the back of its contained layer.
	 * @param	e		The Entity to shift.
	 * @return	If the Entity changed position.
	 */
	public function sendBackward(e:Entity):Bool
	{
		if (e._scene != this || e.renderNext == null) return false;
		// pull from list
		e.renderNext.renderPrev = e.renderPrev;
		if (e.renderPrev != null) e.renderPrev.renderNext = e.renderNext;
		else renderFirst.set(e._layer, e.renderNext);
		// shift towards the back
		e.renderPrev = e.renderNext;
		e.renderNext = e.renderNext.renderNext;
		e.renderPrev.renderNext = e;
		if (e.renderNext != null) e.renderNext.renderPrev = e;
		else renderLast.set(e._layer, e);
		return true;
	}
	
	/**
	 * If the Entity as at the front of its layer.
	 * @param	e		The Entity to check.
	 * @return	True or false.
	 */
	public inline function isAtFront(e:Entity):Bool
	{
		return e.renderPrev == null;
	}
	
	/**
	 * If the Entity as at the back of its layer.
	 * @param	e		The Entity to check.
	 * @return	True or false.
	 */
	public inline function isAtBack(e:Entity):Bool
	{
		return e.renderNext == null;
	}

	/**
	 * Returns the first Entity that collides with the rectangular area.
	 * @param	type		The Entity type to check for.
	 * @param	rX			X position of the rectangle.
	 * @param	rY			Y position of the rectangle.
	 * @param	rWidth		Width of the rectangle.
	 * @param	rHeight		Height of the rectangle.
	 * @return	The first Entity to collide, or null if none collide.
	 */
	public function collideRect(type:String, rX:Float, rY:Float, rWidth:Float, rHeight:Float):Entity
	{
		var e:Entity = _typeFirst.get(type);
		while (e != null)
		{
			if (e.collidable && e.collideRect(e.x, e.y, rX, rY, rWidth, rHeight)) return e;
			e = e.typeNext;
		}
		return null;
	}
	
	/**
	 * Returns the first Entity found that collides with the position.
	 * @param	type		The Entity type to check for.
	 * @param	pX			X position.
	 * @param	pY			Y position.
	 * @return	The collided Entity, or null if none collide.
	 */
	public function collidePoint(type:String, pX:Float, pY:Float):Entity
	{
		var e:Entity = _typeFirst.get(type),
			result:Entity = null;
		while (e != null)
		{
			// only look for entities that collide
			if (e.collidable && e.collidePoint(e.x, e.y, pX, pY))
			{
				// the first one might be the front one
				if (result == null)
				{
					result = e;
				// compare if the new collided entity is above the former one (lower valuer is toward, higher value is backward)
				}
				else if(e._layer < result.layer)
				{
					result = e;
				}
			}
			e = e.typeNext;
		}
		return result;
	}
	
	/**
	 * Returns the first Entity found that collides with the line.
	 * @param	type		The Entity type to check for.
	 * @param	fromX		Start x of the line.
	 * @param	fromY		Start y of the line.
	 * @param	toX			End x of the line.
	 * @param	toY			End y of the line.
	 * @param	precision   Distance between consecutive tests. Higher values are faster but increase the chance of missing collisions.
	 * @param	p           If non-null, will have its x and y values set to the point of collision.
	 * @return	The first Entity to collide, or null if none collide.
	 */
	public function collideLine(type:String, fromX:Int, fromY:Int, toX:Int, toY:Int, precision:Int = 1, p:Vector2 = null):Entity
	{
		// If the distance is less than precision, do the short sweep.
		if (precision < 1) precision = 1;
		if (KXP.distance(fromX, fromY, toX, toY) < precision)
		{
			if (p != null)
			{
				if (fromX == toX && fromY == toY)
				{
					p.x = toX; p.y = toY;
					return collidePoint(type, toX, toY);
				}
				return collideLine(type, fromX, fromY, toX, toY, 1, p);
			}
			else return collidePoint(type, fromX, toY);
		}

		// Get information about the line we're about to raycast.
		var xDelta:Int = Std.int(Math.abs(toX - fromX)),
			yDelta:Int = Std.int(Math.abs(toY - fromY)),
			xSign:Float = toX > fromX ? precision : -precision,
			ySign:Float = toY > fromY ? precision : -precision,
			x:Float = fromX, y:Float = fromY, e:Entity;

		// Do a raycast from the start to the end point.
		if (xDelta > yDelta)
		{
			ySign *= yDelta / xDelta;
			if (xSign > 0)
			{
				while (x < toX)
				{
					if ((e = collidePoint(type, x, y)) != null)
					{
						if (p == null) return e;
						if (precision < 2)
						{
							p.x = x - xSign; p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign; y += ySign;
				}
			}
			else
			{
				while (x > toX)
				{
					if ((e = collidePoint(type, x, y)) != null)
					{
						if (p == null) return e;
						if (precision < 2)
						{
							p.x = x - xSign; p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign; y += ySign;
				}
			}
		}
		else
		{
			xSign *= xDelta / yDelta;
			if (ySign > 0)
			{
				while (y < toY)
				{
					if ((e = collidePoint(type, x, y)) != null)
					{
						if (p == null) return e;
						if (precision < 2)
						{
							p.x = x - xSign; p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign; y += ySign;
				}
			}
			else
			{
				while (y > toY)
				{
					if ((e = collidePoint(type, x, y)) != null)
					{
						if (p == null) return e;
						if (precision < 2)
						{
							p.x = x - xSign; p.y = y - ySign;
							return e;
						}
						return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
					}
					x += xSign; y += ySign;
				}
			}
		}

		// Check the last position.
		if (precision > 1)
		{
			if (p == null) return collidePoint(type, toX, toY);
			if (collidePoint(type, toX, toY) != null) return collideLine(type, Std.int(x - xSign), Std.int(y - ySign), toX, toY, 1, p);
		}

		// No collision, return the end point.
		if (p != null)
		{
			p.x = toX;
			p.y = toY;
		}
		return null;
	}
	
	/**
	 * Populates an array with all Entities that collide with the rectangle. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	type		The Entity type to check for.
	 * @param	rX			X position of the rectangle.
	 * @param	rY			Y position of the rectangle.
	 * @param	rWidth		Width of the rectangle.
	 * @param	rHeight		Height of the rectangle.
	 * @param	into		The Array or Vector to populate with collided Entities.
	 */
	public function collideRectInto<E:Entity>(type:String, rX:Float, rY:Float, rWidth:Float, rHeight:Float, into:Array<E>)
	{
		var e:Entity = _typeFirst.get(type),
			n:Int = into.length;
		while (e != null)
		{
			if (e.collidable && e.collideRect(e.x, e.y, rX, rY, rWidth, rHeight)) into[n ++] = cast e;
			e = e.typeNext;
		}
	}

	/**
	 * Populates an array with all Entities that collide with the circle. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	type 		The Entity type to check for.
	 * @param	circleX		X position of the circle.
	 * @param	circleY		Y position of the circle.
	 * @param	radius		The radius of the circle.
	 * @param	into		The Array or Vector to populate with collided Entities.
	 */
	public function collideCircleInto<E:Entity>(type:String, circleX:Float, circleY:Float, radius:Float , into:Array<E>)
	{
		var e:Entity = _typeFirst.get(type),
			n:Int = into.length;

		radius *= radius;//Square it to avoid the square root
		while (e != null)
		{
			if (KXP.distanceSquared(circleX, circleY, e.x, e.y) < radius) into[n ++] = cast e;
			e = e.typeNext;
		}
	}

	/**
	 * Populates an array with all Entities that collide with the position. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	type		The Entity type to check for.
	 * @param	pX			X position.
	 * @param	pY			Y position.
	 * @param	into		The Array or Vector to populate with collided Entities.
	 */
	public function collidePointInto<E:Entity>(type:String, pX:Float, pY:Float, into:Array<E>)
	{
		var e:Entity = _typeFirst.get(type),
			n:Int = into.length;
		while (e != null)
		{
			if (e.collidable && e.collidePoint(e.x, e.y, pX, pY)) into[n ++] = cast e;
			e = e.typeNext;
		}
	}

	/**
	 * Finds the Entity nearest to the rectangle.
	 * @param	type		The Entity type to check for.
	 * @param	x			X position of the rectangle.
	 * @param	y			Y position of the rectangle.
	 * @param	width		Width of the rectangle.
	 * @param	height		Height of the rectangle.
	 * @return	The nearest Entity to the rectangle.
	 */
	public function nearestToRect(type:String, x:Float, y:Float, width:Float, height:Float):Entity
	{
		var e:Entity = _typeFirst.get(type),
			nearDist:Float = KXP.NUMBER_MAX_VALUE,
			near:Entity = null, dist:Float;
		while (e != null)
		{
			dist = squareRects(x, y, width, height, e.x - e.originX, e.y - e.originY, e.width, e.height);
			if (dist < nearDist)
			{
				nearDist = dist;
				near = e;
			}
			e = e.typeNext;
		}
		return near;
	}

	/**
	 * Finds the Entity nearest to another.
	 * @param	type		The Entity type to check for.
	 * @param	e			The Entity to find the nearest to.
	 * @param	useHitboxes	If the Entities' hitboxes should be used to determine the distance. If false, their x/y coordinates are used.
	 * @return	The nearest Entity to e.
	 */
	public function nearestToEntity(type:String, e:Entity, useHitboxes:Bool = false):Entity
	{
		if (useHitboxes) return nearestToRect(type, e.x - e.originX, e.y - e.originY, e.width, e.height);
		var n:Entity = _typeFirst.get(type),
			nearDist:Float = KXP.NUMBER_MAX_VALUE,
			near:Entity = null,
			dist:Float,
			x:Float = e.x - e.originX,
			y:Float = e.y - e.originY;
		while (n != null)
		{
			dist = (x - n.x) * (x - n.x) + (y - n.y) * (y - n.y);
			if (dist < nearDist)
			{
				nearDist = dist;
				near = n;
			}
			n = n.typeNext;
		}
		return near;
	}


	/**
	 * Finds the Entity nearest to another.
	 * @param	type		The Entity type to check for.
	 * @param	e			The Entity to find the nearest to.
	 * @param	classType	The Entity class to check for.
	 * @param	useHitboxes	If the Entities' hitboxes should be used to determine the distance. If false, their x/y coordinates are used.
	 * @return	The nearest Entity to e.
	 */
	public function nearestToClass(type:String, e:Entity, classType:Dynamic, useHitboxes:Bool = false):Entity
	{
		if (useHitboxes) return nearestToRect(type, e.x - e.originX, e.y - e.originY, e.width, e.height);
		var n:Entity = _typeFirst.get(type),
			nearDist:Float = KXP.NUMBER_MAX_VALUE,
			near:Entity = null,
			dist:Float,
			x:Float = e.x - e.originX,
			y:Float = e.y - e.originY;
		while (n != null)
		{
			dist = (x - n.x) * (x - n.x) + (y - n.y) * (y - n.y);
			if (dist < nearDist && Std.is(e, classType))
			{
				nearDist = dist;
				near = n;
			}
			n = n.typeNext;
		}
		return near;
	}

	/**
	 * Finds the Entity nearest to the position.
	 * @param	type		The Entity type to check for.
	 * @param	x			X position.
	 * @param	y			Y position.
	 * @param	useHitboxes	If the Entities' hitboxes should be used to determine the distance. If false, their x/y coordinates are used.
	 * @return	The nearest Entity to the position.
	 */
	public function nearestToPoint(type:String, x:Float, y:Float, useHitboxes:Bool = false):Entity
	{
		var n:Entity = _typeFirst.get(type),
			nearDist:Float = KXP.NUMBER_MAX_VALUE,
			near:Entity = null,
			dist:Float;
		if (useHitboxes)
		{
			while (n != null)
			{
				dist = squarePointRect(x, y, n.x - n.originX, n.y - n.originY, n.width, n.height);
				if (dist < nearDist)
				{
					nearDist = dist;
					near = n;
				}
				n = n.typeNext;
			}
		}
		else
		{
			while (n != null)
			{
				dist = (x - n.x) * (x - n.x) + (y - n.y) * (y - n.y);
				if (dist < nearDist)
				{
					nearDist = dist;
					near = n;
				}
				n = n.typeNext;
			}
		}
		return near;
	}

	/**
	 * How many Entities are in the Scene.
	 */
	public var count(get, never):Int;
	private inline function get_count():Int { return _count; }

	/**
	 * Returns the amount of Entities of the type are in the Scene.
	 * @param	type		The type (or Class type) to count.
	 * @return	How many Entities of type exist in the Scene.
	 */
	public inline function typeCount(type:String):Int
	{
		return _typeCount.exists(type) ? _typeCount.get(type) : 0;
	}

	/**
	 * Returns the amount of Entities of the Class are in the Scene.
	 * @param	c		The Class type to count.
	 * @return	How many Entities of Class exist in the Scene.
	 */
	public inline function classCount(c:String):Int
	{
		return _classCount.exists(c) ? _classCount.get(c) : 0;
	}

	/**
	 * Returns the amount of Entities are on the layer in the Scene.
	 * @param	layer		The layer to count Entities on.
	 * @return	How many Entities are on the layer.
	 */
	public inline function layerCount(layer:Int):Int
	{
		return _layerCount.exists(layer) ? _layerCount.get(layer) : 0;
	}

	/**
	 * The first Entity in the Scene.
	 */
	public var first(get, null):Entity;
	private inline function get_first():Entity { return updateFirst; }

	/**
	 * How many Entity layers the Scene has.
	 */
	public var layers(get, null):Int;
	private inline function get_layers():Int { return layerList.length; }

	/**
	 * The first Entity of the type.
	 * @param	type		The type to check.
	 * @return	The Entity.
	 */
	public function typeFirst(type:String):Entity
	{
		if (updateFirst == null) return null;
		return _typeFirst.get(type);
	}

	/**
	 * The first Entity of the Class.
	 * @param	c		The Class type to check.
	 * @return	The Entity.
	 */
	public function classFirst<E:Entity>(c:Class<E>):E
	{
		if (updateFirst == null) return null;
		var e:Entity = updateFirst;
		while (e != null)
		{
			if (Std.is(e, c)) return cast e;
			e = e.updateNext;
		}
		return null;
	}

	/**
	 * The first Entity on the Layer.
	 * @param	layer		The layer to check.
	 * @return	The Entity.
	 */
	public function layerFirst(layer:Int):Entity
	{
		if (updateFirst == null) return null;
		return renderFirst.get(layer);
	}

	/**
	 * The last Entity on the Layer.
	 * @param	layer		The layer to check.
	 * @return	The Entity.
	 */
	public function layerLast(layer:Int):Entity
	{
		if (updateFirst == null) return null;
		return renderLast.get(layer);
	}

	/**
	 * The Entity that will be rendered first by the Scene.
	 */
	public var farthest(get, null):Entity;
	private function get_farthest():Entity
	{
		if (updateFirst == null) return null;
		return renderLast.get(layerList[layerList.length - 1]);
	}

	/**
	 * The Entity that will be rendered last by the scene.
	 */
	public var nearest(get, null):Entity;
	private function get_nearest():Entity
	{
		if (updateFirst == null) return null;
		return renderFirst.get(layerList[0]);
	}

	/**
	 * The layer that will be rendered first by the Scene.
	 */
	public var layerFarthest(get, null):Int;
	private function get_layerFarthest():Int
	{
		if (updateFirst == null) return 0;
		return layerList[layerList.length - 1];
	}

	/**
	 * The layer that will be rendered last by the Scene.
	 */
	public var layerNearest(get, null):Int;
	private function get_layerNearest():Int
	{
		if (updateFirst == null) return 0;
		return layerList[0];
	}

	/**
	 * How many different types have been added to the Scene.
	 */
	public var uniqueTypes(get, null):Int;
	private inline function get_uniqueTypes():Int
	{
		var i:Int = 0;
		for (type in _typeCount) i++;
		return i;
	}
	
		/**
	 * Pushes all Entities in the Scene of the type into the Array or Vector. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	type		The type to check.
	 * @param	into		The Array or Vector to populate.
	 */
	public function getType<E:Entity>(type:String, into:Array<E>)
	{
		var e:Entity = _typeFirst.get(type),
			n:Int = into.length;
		while (e != null)
		{
			into[n++] = cast e;
			e = e.typeNext;
		}
	}
	
	
	/**
	 * Pushes all Entities in the Scene of the Class into the Array or Vector. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	c			The Class type to check.
	 * @param	into		The Array or Vector to populate.
	 */
	public function getClass<E:Entity>(c:Class<Dynamic>, into:Array<E>)
	{
		var e:Entity = updateFirst,
			n:Int = into.length;
		while (e != null)
		{
			if (Std.is(e, c))
				into[n++] = cast e;
			e = e.updateNext;
		}
	}
	
	/**
	 * Pushes all Entities in the Scene on the layer into the Array or Vector. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	layer		The layer to check.
	 * @param	into		The Array or Vector to populate.
	 */
	public function getLayer<E:Entity>(layer:Int, into:Array<E>)
	{
		var e:Entity = renderLast.get(layer),
			n:Int = into.length;
		while (e != null)
		{
			into[n ++] = cast e;
			e = e.updatePrev;
		}
	}
	
	/**
	 * Pushes all Entities in the Scene into the array. This
	 * function does not empty the array, that responsibility is left to the user.
	 * @param	into		The Array or Vector to populate.
	 */
	public function getAll<E:Entity>(into:Array<E>) : Void
	{
		var e:Entity = updateFirst,
			n:Int = into.length;
		while (e != null)
		{
			into[n ++] = cast e;
			e = e.updateNext;
		}
	}
	
	/**
	 * Returns the Entity with the instance name, or null if none exists
	 * @param	name
	 * @return	The Entity.
	 */
	public function getInstance(name:String):Entity
	{
		return entityNames.get(name);
	}
	
	/**
	 * Updates the add/remove lists at the end of the frame.
	 * @param	shouldAdd	If new Entities should be added to the scene.
	 */
	public function updateLists(shouldAdd:Bool = true)
	{
		var e:Entity;

		// remove entities
		if (_remove.length > 0)
		{
			for (e in _remove)
			{
				if (e._scene == null)
				{
					var idx = KXP.indexOf(_add, e);
					if (idx >= 0) _add.splice(idx, 1);
					continue;
				}
				if (e._scene != this)
					continue;
				e.removed();
				e._scene = null;
				removeUpdate(e);
				removeRender(e);
				if (e._type != "") removeType(e);
				if (e._name != "") unregisterName(e);
				//if (e.autoClear && e.hasTween) e.clearTweens();
			}
			KXP.clear(_remove);
		}

		// add entities
		if (shouldAdd && _add.length > 0)
		{
			for (e in _add)
			{
				if (e._scene != null) continue;
				e._scene = this;
				addUpdate(e);
				addRender(e);
				if (e._type != "") addType(e);
				if (e._name != "") registerName(e);
				e.added();
			}
			KXP.clear(_add);
		}

		// recycle entities
		if (_recycle.length > 0)
		{
			for (e in _recycle)
			{
				if (e._scene != null || e.recycleNext != null)
					continue;

				e.recycleNext = recycled.get(e._class);
				recycled.set(e._class, e);
			}
			KXP.clear(_recycle);
		}
	}
	
	/** @private Adds Entity to the update list. */
	private function addUpdate(e:Entity)
	{
		// add to update list
		if (updateFirst != null)
		{
			updateFirst.updatePrev = e;
			e.updateNext = updateFirst;
		}
		else e.updateNext = null;
		e.updatePrev = null;
		updateFirst = e;
		_count ++;
		if (_classCount.get(e._class) != 0) _classCount.set(e._class, 0);
		_classCount.set(e._class, _classCount.get(e._class) + 1); // increment
	}
	
	/** @private Removes Entity from the update list. */
	private function removeUpdate(e:Entity)
	{
		// remove from the update list
		if (updateFirst == e) updateFirst = e.updateNext;
		if (e.updateNext != null) e.updateNext.updatePrev = e.updatePrev;
		if (e.updatePrev != null) e.updatePrev.updateNext = e.updateNext;
		e.updateNext = e.updatePrev = null;
		_count --;
		_classCount.set(e._class, _classCount.get(e._class) - 1); // decrement
	}
	
	
	/** @private Adds Entity to the render list. */
	@:allow(com.khapunk.Entity)
	private function addRender(e:Entity)
	{
		var next:Entity = renderFirst.get(e._layer);
		if (next != null)
		{
			// Append entity to existing layer.
			e.renderNext = next;
			next.renderPrev = e;
			_layerCount.set(e._layer, _layerCount.get(e._layer) + 1);
		}
		else
		{
			// Create new layer with entity.
			renderLast.set(e._layer, e);
			layerList[layerList.length] = e._layer;
			_layerSort = true;
			e.renderNext = null;
			_layerCount.set(e._layer, 1);
		}
		renderFirst.set(e._layer, e);
		e.renderPrev = null;
	}
	
	/** @private Removes Entity from the render list. */
	@:allow(com.khapunk.Entity)
	private function removeRender(e:Entity)
	{
		if (e.renderNext != null) e.renderNext.renderPrev = e.renderPrev;
		else renderLast.set(e._layer, e.renderPrev);
		if (e.renderPrev != null) e.renderPrev.renderNext = e.renderNext;
		else
		{
			// Remove this entity from the layer.
			renderFirst.set(e._layer, e.renderNext);
			if (e.renderNext == null)
			{
				// Remove the layer from the layer list if this was the last entity.
				if (layerList.length > 1)
				{
					layerList[KXP.indexOf(layerList, e._layer)] = layerList[layerList.length - 1];
					_layerSort = true;
				}
				layerList.pop();
			}
		}
		var count:Int = _layerCount.get(e._layer) - 1;
		if (count > 0)
		{
			_layerCount.set(e._layer, count);
		}
		else
		{
			// Remove layer from maps if it contains 0 entities.
			_layerCount.remove(e._layer);
			renderFirst.remove(e._layer);
			renderLast.remove(e._layer);
		}
		e.renderNext = e.renderPrev = null;
	}
	
	/** @private Adds Entity to the type list. */
	@:allow(com.khapunk.Entity)
	private function addType(e:Entity)
	{
		// add to type list
		if (_typeFirst.get(e._type) != null)
		{
			_typeFirst.get(e.type).typePrev = e;
			e.typeNext = _typeFirst.get(e._type);
			_typeCount.set(e._type, _typeCount.get(e._type) + 1);
		}
		else
		{
			e.typeNext = null;
			_typeCount.set(e._type, 1);
		}
		e.typePrev = null;
		_typeFirst.set(e._type, e);
	}
	
	/** @private Removes Entity from the type list. */
	@:allow(com.khapunk.Entity)
	private function removeType(e:Entity)
	{
		// remove from the type list
		if (_typeFirst.get(e._type) == e) _typeFirst.set(e._type, e.typeNext);
		if (e.typeNext != null) e.typeNext.typePrev = e.typePrev;
		if (e.typePrev != null) e.typePrev.typeNext = e.typeNext;
		e.typeNext = e.typePrev = null;
		var count:Int = _typeCount.get(e._type) - 1;
		if (count <= 0)
		{
			_typeCount.remove(e._type);
		}
		else
		{
			_typeCount.set(e._type, count);
		}
	}
	
	/** @private Register the entities instance name. */
	@:allow(com.khapunk.Entity)
	private inline function registerName(e:Entity)
	{
		entityNames.set(e._name, e);
	}

	/** @private Unregister the entities instance name. */
	@:allow(com.khapunk.Entity)
	private inline function unregisterName(e:Entity):Void
	{
		entityNames.remove(e._name);
	}
	
	/** @private Calculates the squared distance between two rectangles. */
	private static function squareRects(x1:Float, y1:Float, w1:Float, h1:Float, x2:Float, y2:Float, w2:Float, h2:Float):Float
	{
		if (x1 < x2 + w2 && x2 < x1 + w1)
		{
			if (y1 < y2 + h2 && y2 < y1 + h1) return 0;
			if (y1 > y2) return (y1 - (y2 + h2)) * (y1 - (y2 + h2));
			return (y2 - (y1 + h1)) * (y2 - (y1 + h1));
		}
		if (y1 < y2 + h2 && y2 < y1 + h1)
		{
			if (x1 > x2) return (x1 - (x2 + w2)) * (x1 - (x2 + w2));
			return (x2 - (x1 + w1)) * (x2 - (x1 + w1));
		}
		if (x1 > x2)
		{
			if (y1 > y2) return squarePoints(x1, y1, (x2 + w2), (y2 + h2));
			return squarePoints(x1, y1 + h1, x2 + w2, y2);
		}
		if (y1 > y2) return squarePoints(x1 + w1, y1, x2, y2 + h2);
		return squarePoints(x1 + w1, y1 + h1, x2, y2);
	}

	/** @private Calculates the squared distance between two points. */
	private static function squarePoints(x1:Float, y1:Float, x2:Float, y2:Float):Float
	{
		return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
	}
	
	/** @private Calculates the squared distance between a rectangle and a point. */
	private static function squarePointRect(px:Float, py:Float, rx:Float, ry:Float, rw:Float, rh:Float):Float
	{
		if (px >= rx && px <= rx + rw)
		{
			if (py >= ry && py <= ry + rh) return 0;
			if (py > ry) return (py - (ry + rh)) * (py - (ry + rh));
			return (ry - py) * (ry - py);
		}
		if (py >= ry && py <= ry + rh)
		{
			if (px > rx) return (px - (rx + rw)) * (px - (rx + rw));
			return (rx - px) * (rx - px);
		}
		if (px > rx)
		{
			if (py > ry) return squarePoints(px, py, rx + rw, ry + rh);
			return squarePoints(px, py, rx + rw, ry);
		}
		if (py > ry) return squarePoints(px, py, rx, ry + rh);
		return squarePoints(px, py, rx, ry);
	}
}