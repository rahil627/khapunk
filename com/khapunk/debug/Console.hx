package com.khapunk.debug;


import com.khapunk.utils.Input;
import com.khapunk.utils.PunkKey;
import kha.Canvas;
import kha.Rectangle;

import haxe.Log;
import haxe.PosInfos;
import haxe.ds.IntMap;

/**
 * ...
 * @author Sidar Talei
 */

class Console
{
	public var debug(default,null):Bool = false;
	public var togglePunkKey:Int;
	
	
	/*
	 * Get the unscaled screen width for the Console.
	 */
	public var width(get, never):Int;
	private function get_width():Int { return KP.width; }

	/**
	 * Get the unscaled screen height for the Console.
	 */
	public var height(get, never):Int;
	private function get_height():Int { return KP.height; }

	// Console state information.
	private var _enabled:Bool;
	private var _visible:Bool;
	private var _paused:Bool;
	private var _debug:Bool;
	private var _scrolling:Bool;
	private var _selecting:Bool;
	private var _dragging:Bool;
	private var _panning:Bool;

	// Console display objects.

	// FPS panel information.

	// Layer panel information
	//private var _layerList:LayerList;

	// Output panel information.
	private var _logHeight:Int;
	private var _logBar:Rectangle;
	private var _logBarGlobal:Rectangle;
	private var _logScroll:Float;


	private var _entRect:Rectangle;

	// Log information.
	private var _logLines:Int;
	private var LOG:Array<String>;

	// Entity lists.
	private var LAYER_LIST:IntMap<Int>;
	private var ENTITY_LIST:Array<Entity>;
	private var SCREEN_LIST:Array<Entity>;
	private var SELECT_LIST:Array<Entity>;

	// Watch information.
	private var WATCH_LIST:Array<String>;

	// Switch to small text in debug if console width > this threshold.
	private static inline var BIG_WIDTH_THRESHOLD:Int = 420;
	
	@:allow(com.khapunk)
	private function new()
	{
		Input.define("_ARROWS", [PunkKey.RIGHT, PunkKey.LEFT, PunkKey.DOWN, PunkKey.UP]);
		
		
		// Log information.
		LOG = new Array<String>();
		
		LAYER_LIST  = new IntMap<Int>();
		ENTITY_LIST = new Array<Entity>();
		SCREEN_LIST = new Array<Entity>();
		SELECT_LIST = new Array<Entity>();
		
		//_layerList = new LayerList();
		
		_logScroll = 0;
		_logLines = 33;
		
		// Watch information.
		WATCH_LIST = ["x", "y"];
	}
	
	public function update()
	{
		if (Input.pressed(togglePunkKey)) {
			debug = !debug;
		}
	}
	
	private function traceLog(v:Dynamic, ?infos:PosInfos)
	{
		var log:String = infos.className + "(" + infos.lineNumber + "): " + Std.string(v);
		LOG.push(log);
#if (cpp || neko)
		Sys.println(log);
#end
	//	if (_enabled && _sprite.visible) updateLog();
	}
	
	public function enable(togglePunkKey=PunkKey.TAB) : Void
	{
		this.togglePunkKey = togglePunkKey;
		// Quit if the console is already enabled.
		if (_enabled) return;
		_enabled = true;
		_visible = true;
	}
	
	/**
	 * Logs data to the console.
	 * @param	data		The data parameters to log, can be variables, objects, etc. Parameters will be separated by a space (" ").
	 */
	public function log(data:Array<Dynamic>)
	{
		var s:String = "";

		// Iterate through data to build a string.
		for (i in 0...data.length)
		{
			if (i > 0) s += " ";
			s += (data[i] != null ? Std.string(data[i]) : "null");
		}

		// Replace newlines with multiple log statements.
		if (s.indexOf("\n") >= 0)
		{
			var a:Array<String> = s.split("\n");
			for (s in a) LOG.push(s);
		}
		else
		{
			LOG.push(s);
		}

		// If the log is running, update it.
		//if (_enabled && _sprite.visible) updateLog();
	}

	public function drawLog(buffer:Canvas) {
		
	}
	
	/** @private Steps the frame ahead. */
	private function stepFrame()
	{
		KP.engine.update();
		KP.engine.render();
		//updateEntityCount();
		//updateEntityLists();
		//renderEntities();
	}

	/** @private Move the selected Entitites by the amount. */
	private function moveSelected(xDelta:Int, yDelta:Int)
	{
		for (e in SELECT_LIST)
		{
			e.x += xDelta;
			e.y += yDelta;
		}
		KP.engine.render();
		//renderEntities();
		//updateEntityLists(true);
	}

	/** @private Starts camera panning. */
	private function startPanning()
	{
		_panning = true;
		_entRect.x = Input.mouseX;
		_entRect.y = Input.mouseY;
	}

	/** @private Updates camera panning. */
	private function updatePanning()
	{
		if (Input.mouseReleased) _panning = false;
		panCamera(Std.int(_entRect.x - Input.mouseX), Std.int(_entRect.y - Input.mouseY));
		_entRect.x = Input.mouseX;
		_entRect.y = Input.mouseY;
	}

	/** @private Pans the camera. */
	private function panCamera(xDelta:Int, yDelta:Int)
	{
		KP.camera.x += xDelta;
		KP.camera.y += yDelta;
		KP.engine.render();
		//updateEntityLists(true);
		//renderEntities();
	}
	
	/** @private Sets the camera position. */
	private function setCamera(x:Int, y:Int)
	{
		KP.camera.x = x;
		KP.camera.y = y;
		KP.engine.render();
		//updateEntityLists(true);
		//renderEntities();
	}
	
	/** @private Starts Entity selection. */
	private function startSelection()
	{
		_selecting = true;
		_entRect.x = Input.screenMouseX;
		_entRect.y = Input.screenMouseY;
		_entRect.width = 0;
		_entRect.height = 0;
	}
	
		/** @private Updates Entity selection. */
	private function updateSelection()
	{
		_entRect.width = Input.screenMouseX - _entRect.x;
		_entRect.height = Input.screenMouseY - _entRect.y;
		if (Input.mouseReleased)
		{
			selectEntities(_entRect);
			//renderEntities();
			_selecting = false;
			//_entSelect.graphics.clear();
		}
		else
		{
			//_entSelect.graphics.clear();
			//_entSelect.graphics.lineStyle(1, 0xFFFFFF);
			//_entSelect.graphics.drawRect(_entRect.x, _entRect.y, _entRect.width, _entRect.height);
		}
	}
	
	
	/** @private Selects the Entitites in the rectangle. */
	private function selectEntities(rect:Rectangle)
	{
		if (rect.width < 0) rect.x -= (rect.width = -rect.width);
		else if (rect.width == 0) rect.width = 1;
		if (rect.height < 0) rect.y -= (rect.height = -rect.height);
		else if (rect.height == 0) rect.height = 1;

		KP.rect.width = KP.rect.height = 6;
		var //sx:Float = KP.screen.fullScaleX,
			//sy:Float = KP.screen.fullScaleY,
			e:Entity;

		if (!Input.check(PunkKey.CONTROL))
		{
			// Replace selections with new selections.
			KP.clear(SELECT_LIST);
		}
		// Append/Remove selected Entitites.
		for (e in SCREEN_LIST)
		{
			KP.rect.x = (e.x - KP.camera.x)  - 3;
			KP.rect.y = (e.y - KP.camera.y)  - 3;
			if (rect.collision(KP.rect))
			{
				if (KP.indexOf(SELECT_LIST, e) < 0)
				{
					SELECT_LIST.push(e);
				}
				else
				{
					SELECT_LIST.remove(e);
				}
			}
		}
	}
	
	/** @private Selects all entities on screen. */
	private function selectAll()
	{
		// capture number selected before clearing selection list
		var numSelected = SELECT_LIST.length;
		KP.clear(SELECT_LIST);

		// if the number of entities on screen is the same as selected, leave the list cleared
		if (numSelected != SCREEN_LIST.length)
		{
			for (e in SCREEN_LIST) SELECT_LIST.push(e);
		}
		//renderEntities();
	}
	
	/** @private Starts log text scrolling. */
	private function startScrolling()
	{
		//if (LOG.length > _logLines) _scrolling = _logBarGlobal.contains(Input.screenMouseX, Input.screenMouseY);
	}

	
	/**
	 * Show the console, no effect if the console insn't hidden.
	 */
	public function show()
	{
		if (!_visible)
		{
			//KP.stage.addChild(_sprite);
			_visible = true;
		}
	}

	/** @private Updates log text scrolling. */
	private function updateScrolling()
	{
		_scrolling = Input.mouseDown;
		//_logScroll = KP.scaleClamp(Input.screenMouseY, _logBarGlobal.y, _logBarGlobal.bottom, 0, 1);
		//updateLog();
	}
	
	/** @private Moves Entities with the arrow PunkKeys. */
	private function updatePunkKeyMoving()
	{
		KP.point.x = (Input.pressed(PunkKey.RIGHT) ? 1 : 0) - (Input.pressed(PunkKey.LEFT) ? 1 : 0);
		KP.point.y = (Input.pressed(PunkKey.DOWN) ? 1 : 0) - (Input.pressed(PunkKey.UP) ? 1 : 0);
		if (KP.point.x != 0 || KP.point.y != 0) moveSelected(Std.int(KP.point.x), Std.int(KP.point.y));
	}

	/** @private Pans the camera with the arrow PunkKeys. */
	private function updatePunkKeyPanning()
	{
		KP.point.x = (Input.check(PunkKey.RIGHT) ? 1 : 0) - (Input.check(PunkKey.LEFT) ? 1 : 0);
		KP.point.y = (Input.check(PunkKey.DOWN) ? 1 : 0) - (Input.check(PunkKey.UP) ? 1 : 0);
		if (KP.point.x != 0 || KP.point.y != 0) panCamera(Std.int(KP.point.x), Std.int(KP.point.y));
	}
	
	
	/** @private Update the Entity list information. */
	private function updateEntityLists(fetchList:Bool = true)
	{
		// If the list should be re-populated.
		if (fetchList)
		{
			KP.clear(ENTITY_LIST);
			KP.scene.getAll(ENTITY_LIST);

			for (key in LAYER_LIST.keys())
			{
				LAYER_LIST.set(key, 0);
			}
		}

		// Update the list of Entities on screen.
		KP.clear(SCREEN_LIST);
		for (e in ENTITY_LIST)
		{
			var layer = e.layer;
			if (e.onCamera && KP.scene.layerVisible(layer))
				SCREEN_LIST.push(e);

			if (fetchList)
				LAYER_LIST.set(layer, LAYER_LIST.exists(layer) ? LAYER_LIST.get(layer) + 1 : 1);
		}

		if (fetchList)
		{
			//_layerList.set(LAYER_LIST);
		}
	}
	
	/**
	 * Hide the console, no effect if the console isn't visible.
	 */
	public function hide()
	{
		if (_visible)
		{
			//	KP.stage.removeChild(_sprite);
			_visible = false;
		}
	}
	
	
	
}