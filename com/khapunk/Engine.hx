package com.khapunk;
import com.khapunk.utils.Input;
import kha.Game;
import kha.Painter;
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
		if (!KP.gotoIsNull()) checkScene();

		// game start
		
		init();
	}
	
	/**
	 * Override this, called after Engine has been added to the stage.
	 */
	public function init() { }

	/**
	 * Override this, called when game gains focus
	 */
	//public function focusGained() { }

	/**
	 * Override this, called when game loses focus
	 */
	//public function focusLost() { }
	
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
		
		KP.scene.updateLists();
		if (!KP.gotoIsNull()) checkScene();
		//if (KP.tweener.active && KP.tweener.hasTween) KP.tweener.updateTweens();
		if (KP.scene.active)
		{
			//if (KP.scene.hasTween) KP.scene.updateTweens();
			KP.scene.update();
			
		}
		// update input
		Input.update();
		
		KP.scene.updateLists(false);
	}
	
	/**
	 * Renders the game, rendering the Scene and Entities.
	 */
	public function render(painter:Painter): Void
	{
		if (KP.scene.visible) KP.scene.render(painter);
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
	private function checkScene()
	{
		if (KP.gotoIsNull()) return;

		if (KP.scene != null)
		{
			KP.scene.end();
			KP.scene.updateLists();
			//if (KP.scene.autoClear && KP.scene.hasTween) KP.scene.clearTweens();
			//if (contains(KP.scene.sprite)) removeChild(KP.scene.sprite);
			KP.swapScene();
			//addChild(KP.scene.sprite);
			KP.camera = KP.scene.camera;
			KP.scene.updateLists();
			KP.scene.begin();
			KP.scene.updateLists();
		}
	}
	
	
}