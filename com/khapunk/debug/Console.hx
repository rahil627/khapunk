package com.khapunk.debug;


import com.khapunk.utils.Input;
import com.khapunk.utils.PunkKey;

/**
 * ...
 * @author Sidar Talei
 */

class Console
{
	public var debug(default,null):Bool = false;
	public var toggleKey:Int;
	
	var _enabled:Bool = false;
	
	@:allow(com.khapunk)
	private function new()
	{
		Input.define("_ARROWS", [PunkKey.RIGHT, PunkKey.LEFT, PunkKey.DOWN, PunkKey.UP]);
	}
	
	public function update()
	{
		if (Input.pressed(toggleKey)) {
			debug = !debug;
		}
	}
	
	public function enable(toggleKey=PunkKey.TILDE) : Void
	{
		this.toggleKey = toggleKey;
		// Quit if the console is already enabled.
		if (_enabled) return;
		_enabled = true;
	}
	
}