package com.khapunk.utils;
import kha.Game;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;
import kha.Key;
import kha.Sys;

/**
 * ...
 * @author ...
 */
class Input
{
	private static inline var kKeyStringMax = 100;

	public static var  touchNum(default,null):Int;
	
	private static var _enabled:Bool = false;
	private static var _key:Map<Int, Bool> = new Map<Int, Bool>();
	private static var _keyNum:Int = 0;
	private static var _press:Array<Int> = new Array<Int>();
	private static var _pressNum:Int = 0;
	private static var _release:Array<Int> = new Array<Int>();
	private static var _releaseNum:Int = 0;
	private static var _mouseWheelDelta:Int = 0;
	private static var _touches:Map<Int,Touch> = new Map<Int,Touch>();
	//private static var _joysticks:Map<Int,Joystick> = new Map<Int,Joystick>();
	private static var _control:Map<String,Array<Int>> = new Map<String,Array<Int>>();
	//private static var _nativeCorrection:Map<String, Int> = new Map<String, Int>();
	
	
	/**
	 * Returns true if the device supports multi touch
	 */
	public static var multiTouchSupported(default, null):Bool = false;

	
	private static var _mouseX:Int = 0;
	private static var _mouseY:Int = 0;
	
	/**
	 * Contains the string of the last keys pressed
	 */
	public static var keyString:String = "";

	/**
	 * Holds the last key pressed
	 */
	public static var lastKey:Int;

	/**
	 * If any mouse button is held down
	 */
	public static var mouseDown:Bool;
	/**
	 * If all mouse button are up
	 */
	public static var mouseAllUp:Bool;
	/**
	 * If any mouse button was recently pressed
	 */
	public static var mousePressed:Bool;
	/**
	 * If any mouse button was recently released
	 */
	public static var mouseReleased:Bool;

	public static var leftMouseDown:Bool = false;
	public static var rightMouseDown:Bool = false;
	public static var midMouseDown:Bool = false;
	
	public static var leftMouseClicked:Bool = false;
	public static var rightMouseClicked:Bool = false;
	public static var midMouseClicked:Bool = false;
	
	public static var leftMouseReleased:Bool = false;
	public static var rightMouseReleased:Bool = false;
	public static var midMouseReleased:Bool = false;
	
	public static var mouseMoved:Bool = false;
	
	/**
	 * If the mouse wheel has moved
	 */
	public static var mouseWheel:Bool;
	
	/**
	 * If the mouse wheel was moved this frame, this was the delta.
	 */
	public static var mouseWheelDelta(get, never):Int;
	public static function get_mouseWheelDelta():Int
	{
		if (mouseWheel)
		{
			mouseWheel = false;
			return _mouseWheelDelta;
		}
		return 0;
	}

	/**
	 * X position of the mouse on the screen.
	 */
	public static var mouseX(get, never):Int;
	private static function get_mouseX():Int
	{
		return Std.int(_mouseX / (Sys.pixelWidth/Game.the.width));//KP.screen.mouseX;
	}

	/**
	 * Y position of the mouse on the screen.
	 */
	public static var mouseY(get, never):Int;
	private static function get_mouseY():Int
	{
		return Std.int(_mouseY / (Sys.pixelHeight/Game.the.height));//KP.screen.mouseX;
	}
	
	
	/**
	 * The absolute mouse x position on the screen (unscaled).
	 */
	public static var screenMouseX(get, never):Int;
	private static function get_screenMouseX():Int
	{
		return _mouseX;//Std.int(KP.stage.mouseX);
	}

	/**
	 * The absolute mouse y position on the screen (unscaled).
	 */
	public static var screenMouseY(get, never):Int;
	private static function get_screenMouseY():Int
	{
		return  _mouseY;// Std.int(KP.stage.mouseY);
	}
	
		/**
	 * Defines a new input.
	 * @param	name		String to map the input to.
	 * @param	keys		The keys to use for the Input.
	 */
	public static function define(name:String, keys:Array<Int>)
	{
		_control.set(name, keys);
	}
	
	/**
	 * If the input or key is held down.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function check(input:Dynamic):Bool
	{
		if (Std.is(input, String))
		{
#if debug
			if (!_control.exists(input))
			{
				//KP.log("Input '" + input + "' not defined");
				return false;
			}
#end
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
			while (i-- > 0)
			{
				
				if (v[i] < 0)
				{
					
					if (_keyNum > 0) return true;
					continue;
				}
				if (_key[v[i]] == true) return true;
			}
			return false;
		}
	
		return input < 0 ? _keyNum > 0 : _key.get(input);
	}
	
	/**
	 * If the input or key was pressed this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function pressed(input:Dynamic):Bool
	{
		
		if (Std.is(input, String) && _control.exists(input))
		{
			
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
				
			while (i-- > 0)
			{
				
				if ((v[i] < 0) ? _pressNum != 0 : KP.indexOf(_press, v[i]) >= 0) return true;
				
			}
			
			return false;
		}
		
		return (input < 0) ? _pressNum != 0 : KP.indexOf(_press, input) >= 0;
	}
	
	/**
	 * If the input or key was released this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function released(input:Dynamic):Bool
	{
		if (Std.is(input, String))
		{
			var v:Array<Int> = _control.get(input),
				i:Int = v.length;
			while (i-- > 0)
			{
				if ((v[i] < 0) ? _releaseNum != 0 : KP.indexOf(_release, v[i]) >= 0) return true;
			}
			return false;
		}
		return (input < 0) ? _releaseNum != 0 : KP.indexOf(_release, input) >= 0;
	}
	
	public static function enable()
	{
		Keyboard.get().notify(onKeyDown, onKeyUp);
		Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, onMouseWheel);
		if (Surface.get() != null) {
			Surface.get().notify(onTouch, onTouchEnd, onTouchMove);
			multiTouchSupported = true;
		}
		touchNum = 0; 
	
	}
	
	/**
	 * Updates the input states
	 */
	public static function update()
	{
		while (_pressNum-- > -1) _press[_pressNum] = -1;
		_pressNum = 0;
		while (_releaseNum-- > -1) _release[_releaseNum] = -1;
		_releaseNum = 0;
		
		if (mousePressed) 		mousePressed = false;
		if (mouseReleased)		mouseReleased = false;
		
		if (leftMouseClicked) 	leftMouseClicked = false;
		if (rightMouseClicked) 	rightMouseClicked = false;
		if (midMouseClicked) 	midMouseClicked = false;
		
		if (leftMouseReleased) 	leftMouseReleased = false;
		if (rightMouseReleased) rightMouseReleased = false;
		if (midMouseReleased) 	midMouseReleased = false;
		
		if (mouseMoved) 		mouseMoved = false;
		
		if (multiTouchSupported)
		{
			for (touch in _touches) {
				if (touch.active)
				touch.update();
			}
		}
	}
	
	//------------------------------------------------
	//Touch input
	//public static var touches(get, never):Map<Int,Touch>;
	//private static inline function get_touches():Map < Int, Touch > { return _touches; }
	
	private static var cTouch:Touch;
	private static function onTouch(id:Int, x:Int, y:Int) : Void {
		
		if (!_touches.exists(id)) {
			_touches.set(id, new Touch(x, y, id));
			cTouch = _touches.get(id);
		}
		else {
			cTouch = _touches.get(id);
			cTouch.x = x;
			cTouch.y = y;
		}
		cTouch.init();
		cTouch.active = true;
		++touchNum;
		
	}
	
	private static function onTouchEnd(id:Int, x:Int, y:Int) : Void
	{
		cTouch = _touches.get(id);
		cTouch.active = false;
		cTouch.init();
		--touchNum;
	}
	
	private static function onTouchMove(id:Int, x:Int, y:Int) : Void
	{
		cTouch = _touches.get(id);
		cTouch.x = x;
		cTouch.y = y;
	}
	
	/**
	 * Iterate over the currently active touch points
	 * @param	touchCallback
	 */
	public static function touchPoints(touchCallback:Touch->Bool) : Void
	{
		for (touch in _touches)
		{
			if(touch.active)
				if (!touchCallback(touch))
					break;
		}
	}
	//------------------------------------------------
	private static function onKeyDown(key:Key, char:String) : Void
	{
	
		//var code:Int = keyCode(e);
		var code:Int = char.toUpperCase().charCodeAt(0);
		
		if (code == -1) // No key
			return;

		lastKey = code;
		
		if (key == Key.BACKSPACE) keyString = keyString.substr(0, keyString.length - 1);
		else if ((code > 47 && code < 58) || (code > 64 && code < 91) || code == 32)
		{
			if (keyString.length > kKeyStringMax) keyString = keyString.substr(1);
			
		
			if (key == Key.SHIFT)
				char = char.toUpperCase();
			else char = char.toLowerCase();

			keyString += char;
			 
		}

		if (!_key[code])
		{
			_key[code] = true;
			_keyNum++;
			_press[_pressNum++] = code;
		}
	}
	
	private static function onKeyUp(key:Key, char:String) : Void
	{
		//var code:Int = keyCode(e);
		var code:Int = char.toUpperCase().charCodeAt(0);
		if (code == -1) // No key
			return;

		if (_key[code])
		{
			_key[code] = false;
			_keyNum--;
			_release[_releaseNum++] = code;
		}
	}
	
	/*public static function keyCode(k:String) : Int
	{
	#if (flash || js)
		return k;
	#else
		var code = _nativeCorrection.get(e + "_" + e.keyCode);

		if (code == null)
			return e.keyCode;
		else
			return code;
	#end
	}*/

	private static function onMouseMove(x: Int, y: Int)
	{
		mouseMoved = true;
		_mouseX = x;
		_mouseY = y;
	}
	
	public static var downCount:Int = 0;
	
	private static function onMouseDown(button: Int, x: Int, y: Int) : Void
	{
		
		downCount++;
		switch(button)
		{
			case 0:
				leftMouseDown = true;
				leftMouseClicked = true;
			case 1:
				rightMouseDown = true;
				rightMouseClicked = true;
			case 2:
				midMouseDown = true;
				midMouseClicked = true;
		}
		
		if (!mouseDown)
		{
			mouseDown = true;
			mouseAllUp = false;
		}
		mousePressed = true;
	}

	private static function onMouseUp(button: Int, x: Int, y: Int)
	{
		switch(button)
		{
			case 0:
				leftMouseDown = false;
				leftMouseReleased = true;
			case 1:
				rightMouseDown = false;
				rightMouseReleased = true;
			case 2:
				midMouseDown = false;
				midMouseReleased = true;
		}
		
		if (!leftMouseDown && !rightMouseDown && !midMouseDown)
		{ 
		 mouseDown = false;
		 mouseAllUp = true;
		}
		 mouseReleased = true;
	}

	private static function onMouseWheel(delta: Int)
	{
		mouseWheel = true;
		_mouseWheelDelta = delta;
	}
	

	
}