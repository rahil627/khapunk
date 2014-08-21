package com.khapunk;
import com.khapunk.utils.Input;
import kha.Framebuffer;
import kha.Game;
import kha.graphics2.Graphics;
import kha.Rectangle;
import kha.Scheduler;

/**
 * ...
 * @author ...
 */
class Engine
{

	// Timing information.
	//private var _delta:Float;
	//private var _time:Float;
	//private var _last:Float;
	//private var _timer:Timer;
	//private var	_rate:Float;
	//private var	_skip:Float;
	//private var _prev:Float;

	// Debug timing information.
	//private var _updateTime:Float;
	//private var _renderTime:Float;
	//private var _gameTime:Float;
	//private var _systemTime:Float;

	// FrameRate tracking.
	//private var _frameLast:Float;
	//private var _frameListSum:Int;
	//private var _frameList:Array<Int>;
	
	private var _scene:Scene = new Scene();
	private var _scenes:List<Scene> = new List<Scene>();
	
		/**
	 * If the game should stop updating/rendering.
	 */
	public var paused:Bool;

	/**
	 * Cap on the elapsed time (default at 30 FPS). Raise this to allow for lower framerates (eg. 1 / 10).
	 */
	public var maxElapsed:Float;

	/**
	 * The max amount of frames that can be skipped in fixed framerate mode.
	 */
	public var maxFrameSkip:Int;

	/**
	 * The amount of milliseconds between ticks in fixed framerate mode.
	 */
	public var tickRate:Int;
	
	/**
	 * Constructor. Defines startup information about your game.
	 * @param	width			The width of your game.
	 * @param	height			The height of your game.
	 * @param	frameRate		The game framerate, in frames per second.
	 * @param	fixed			If a fixed-framerate should be used.
	 * @param   renderMode      Overrides the default render mode for this target
	 */
	public function new()
	{
		
		
		//KP.assignedFrameRate = frameRate;
		//KP.fixed = fixed;

		// global game objects
		KP.engine = this;
		//KP.width = width;
		//KP.height = height;

		// miscellaneous startup stuff
		if (KP.randomSeed == 0) KP.randomizeSeed();

		KP.entity = new Entity();

		paused = false;
		maxElapsed = 0.0333;
		maxFrameSkip = 5;
		tickRate = 4;
		//_frameList = new Array<Int>();
		//_systemTime = _delta = _frameListSum = 0;
		//_frameLast = 0;
		
		
		
	}
	@:allow(kha.Game)
	private function setup() : Void {
		
		// global game properties
		
		KP.width = Game.the.width;
		KP.height = Game.the.height;
		KP.bounds = new Rectangle(0, 0, KP.width, KP.height);
		
		KP.init();
		
		// enable input
		/** enable input */
		Input.enable();

		// switch scenes
		checkScene();

		// game start
		
		init();
	}
	
	/**
	 * Override this, It's called after setup();
	 */
	public function init() { }

	/**
	 * Override this, called when game gains focus
	 */
	public function focusGained() { }

	/**
	 * Override this, called when game loses focus
	 */
	public function focusLost() { }
	
	/**
	 * Updates the game, updating the Scene and Entities.
	 */
	public function update() : Void
	{
		
		/** TODO 
		 *  Update console
		 *  Update input
		 * */
		
		if (paused) return;
		
		KP.elapsed = Scheduler.deltaTime;
		
		// update console
		//if (KP.consoleEnabled()) KP.console.update();
		
		_scene.updateLists();
		checkScene();
		//if (KP.tweener.active && KP.tweener.hasTween) KP.tweener.updateTweens();
		if (_scene.active)
		{
			//if (KP.scene.hasTween) KP.scene.updateTweens();
			_scene.update();
		}
		
		_scene.updateLists(false);
		KP.update();
	}
	
	/**
	 * Renders the game, rendering the Scene and Entities.
	 */
	public function render(buffer:Graphics): Void
	{
		
		// update input
		Input.update();
		
		if (_scene.visible) _scene.render(buffer);
	}
	
	
	/** @private Event handler for stage resize */
	private function resize() : Void
	{
		/** TODO fix resize */
		
		/**if (KP.width == 0) KP.width = KP.stage.stageWidth;
		if (KP.height == 0) KP.height = KP.stage.stageHeight;
		// calculate scale from width/height values
		KP.windowWidth = KP.stage.stageWidth;
		KP.windowHeight = KP.stage.stageHeight;
		KP.screen.scaleX = KP.stage.stageWidth / KP.width;
		KP.screen.scaleY = KP.stage.stageHeight / KP.height;
		KP.resize(KP.stage.stageWidth, KP.stage.stageHeight);**/
	}
	
	/** @private Switch scenes if they've changed. */
	private inline function checkScene()
	{
		if (_scene != null && !_scenes.isEmpty() && _scenes.first() != _scene)
		{
			_scene.end();
			_scene.updateLists();
			//if (_scene.autoClear && _scene.hasTween) _scene.clearTweens();
			_scene = _scenes.first();
			KP.camera = _scene.camera;
			_scene.updateLists();
			_scene.begin();
			_scene.updateLists();
		}
	}
	
	public function pushScene(value:Scene): Void
	{
		_scenes.push(value);
	}
	
	public function popScene(value:Scene): Scene
	{
		return _scenes.pop();
	}
	
	/**
	 * The currently active Scene object. When you set this, the Scene is flagged
	 * to switch, but won't actually do so until the end of the current frame.
	 */
	public var scene(get, set):Scene;
	private inline function get_scene():Scene { return _scene; }
	private function set_scene(value:Scene):Scene
	{
		if (_scene == value) return value;
		if (_scenes.length > 0)
		{
			_scenes.pop();
		}
		_scenes.push(value);
		return _scene;
	}
	
	
	
}