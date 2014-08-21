package com.khapunk;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.math.Vector2;



typedef AssignCallback = Void -> Void;

/**
 * ...
 * @author ...
 */
class Graphic
{
	// Graphic information.
	private var scroll:Bool;
	private var point:Vector2;
	private var entity:Entity;

	private var _visible:Bool;
	
	/**
	 * If the graphic should update.
	 */
	public var active:Bool;

	/**
	 * If the graphic should render.
	 */
	public var visible(get, set):Bool;
	private inline function get_visible():Bool { return _visible; }
	private inline function set_visible(value:Bool):Bool { return _visible = value; }

	/**
	 * X offset.
	 */
	public var x:Float;

	/**
	 * Y offset.
	 */
	public var y:Float;
	
	/**
	 * X scrollfactor, effects how much the camera offsets the drawn graphic.
	 * Can be used for parallax effect, eg. Set to 0 to follow the camera,
	 * 0.5 to move at half-speed of the camera, or 1 (default) to stay still.
	 */
	public var scrollX:Float;

	/**
	 * Y scrollfactor, effects how much the camera offsets the drawn graphic.
	 * Can be used for parallax effect, eg. Set to 0 to follow the camera,
	 * 0.5 to move at half-speed of the camera, or 1 (default) to stay still.
	 */
	public var scrollY:Float;

	/**
	 * If the graphic should render at its position relative to its parent Entity's position.
	 */
	public var relative:Bool;
	
	
	/**
	 * Constructor.
	 */
	public function new()
	{
		active = true;
		visible = true;
		x = y = 0;
		scrollX = scrollY = 1;
		relative = true;
		scroll = true;
		point = new Vector2();
	}

	/**
	 * Updates the graphic.
	 */
	public function update()
	{
	
	}

	/**
	 * Removes the graphic from the scene
	 */
	public function destroy() { }
	
	/**
	 * Renders the graphic to the screen buffer.
	 * @param  target     The buffer to draw to.
	 * @param  point      The position to draw the graphic.
	 * @param  camera     The camera offset.
	 */
	public function render(buffer:Graphics, point:Vector2, camera:Vector2) { }
	
	/**
	 * Pause updating this graphic.
	 */
	public function pause()
	{
		active = false;
	}

	/**
	 * Resume updating this graphic.
	 */
	public function resume()
	{
		active = true;
	}
	
	
}