package haxepunk;

import haxepunk.math.Math;
import haxepunk.math.Matrix4;
import haxepunk.scene.Scene;
import haxepunk.graphics.Material;
import haxepunk.inputs.Input;

class Engine
{

	public var scene(get, set):Scene;
	private inline function get_scene():Scene { return _scenes.first(); }
	private inline function set_scene(scene:Scene):Scene { return replaceScene(scene); }

	public function new(?scene:Scene)
	{
		super();
		_scenes = new List<Scene>();
		pushScene(scene == null ? new Scene() : scene);
	}

	override public function setup():Void
	{
		// Init the input system
		Input.init();
	}

	override public function render():Void
	{
		scene.draw();
	}

	override public function update(deltaTime:Float):Void
	{
		scene.update(deltaTime);

		// Update the input system
		Input.update();
	}

	/**
	 * Replaces the current scene
	 * @param scene The replacement scene
	 */
	public function replaceScene(scene:Scene):Scene
	{
		_scenes.pop();
		_scenes.push(scene);
		return scene;
	}

	/**
	 * Pops a scene from the stack
	 */
	public function popScene():Scene
	{
		// should always have at least one scene
		return (_scenes.length > 1 ? _scenes.pop() : _scenes.first());
	}

	/**
	 * Pushes a scene (keeping the old one to use later)
	 * @param scene The scene to push
	 */
	public function pushScene(scene:Scene):Scene
	{
		_scenes.push(scene);
		return scene;
	}

	private var _scenes:List<Scene>;

}
