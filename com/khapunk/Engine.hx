package com.khapunk;
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
		
		
		//HXP.assignedFrameRate = frameRate;
		//HXP.fixed = fixed;

		// global game objects
		HXP.engine = this;
		//HXP.width = width;
		//HXP.height = height;

		// miscellaneous startup stuff
		if (HXP.randomSeed == 0) HXP.randomizeSeed();

		HXP.entity = new Entity();

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
		
		HXP.width = Game.the.width;
		HXP.height = Game.the.height;
		HXP.bounds = new Rectangle(0, 0, HXP.width, HXP.height);
		
		// enable input
		/** enable input */
		//Input.enable();

		// switch scenes
		if (!HXP.gotoIsNull()) checkScene();

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
		
		HXP.elapsed = Scheduler.deltaTime;
		
		// update input
		//Input.update();
		
		// update console
		//if (HXP.consoleEnabled()) HXP.console.update();
		
		HXP.scene.updateLists();
		if (!HXP.gotoIsNull()) checkScene();
		//if (HXP.tweener.active && HXP.tweener.hasTween) HXP.tweener.updateTweens();
		if (HXP.scene.active)
		{
			//if (HXP.scene.hasTween) HXP.scene.updateTweens();
			HXP.scene.update();
			
		}
		HXP.scene.updateLists(false);
	}
	
	/**
	 * Renders the game, rendering the Scene and Entities.
	 */
	public function render(painter:Painter): Void
	{
		
		//if (HXP.screen.needsResize) HXP.resize(HXP.windowWidth, HXP.windowHeight);

		// timing stuff
		//var t:Float = Lib.getTimer();
		//if (_frameLast == 0) _frameLast = Std.int(t);

		// render loop
		/*if (HXP.renderMode == RenderMode.BUFFER)
		{
			HXP.screen.swap();
			HXP.screen.refresh();
		}*/
		//Draw.resetTarget();

		if (HXP.scene.visible) HXP.scene.render(painter);

		// more timing stuff ?
		/** TODO Oi, btf is this mate? */
		/*t = Lib.getTimer();
		_frameListSum += (_frameList[_frameList.length] = Std.int(t - _frameLast));
		if (_frameList.length > 10) _frameListSum -= _frameList.shift();
		HXP.frameRate = 1000 / (_frameListSum / _frameList.length);
		_frameLast = t;*/
	}
	
	
	/** @private Event handler for stage resize */
	private function resize() : Void
	{
		/** TODO fix resize */
		
		/**if (HXP.width == 0) HXP.width = HXP.stage.stageWidth;
		if (HXP.height == 0) HXP.height = HXP.stage.stageHeight;
		// calculate scale from width/height values
		HXP.windowWidth = HXP.stage.stageWidth;
		HXP.windowHeight = HXP.stage.stageHeight;
		HXP.screen.scaleX = HXP.stage.stageWidth / HXP.width;
		HXP.screen.scaleY = HXP.stage.stageHeight / HXP.height;
		HXP.resize(HXP.stage.stageWidth, HXP.stage.stageHeight);**/
	}
	
	/** @private Switch scenes if they've changed. */
	private function checkScene()
	{
		if (HXP.gotoIsNull()) return;

		if (HXP.scene != null)
		{
			HXP.scene.end();
			HXP.scene.updateLists();
			//if (HXP.scene.autoClear && HXP.scene.hasTween) HXP.scene.clearTweens();
			//if (contains(HXP.scene.sprite)) removeChild(HXP.scene.sprite);
			HXP.swapScene();
			//addChild(HXP.scene.sprite);
			HXP.camera = HXP.scene.camera;
			HXP.scene.updateLists();
			HXP.scene.begin();
			HXP.scene.updateLists();
		}
	}
	
	
}