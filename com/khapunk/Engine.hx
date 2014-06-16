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
		
		
		//KXP.assignedFrameRate = frameRate;
		//KXP.fixed = fixed;

		// global game objects
		KXP.engine = this;
		//KXP.width = width;
		//KXP.height = height;

		// miscellaneous startup stuff
		if (KXP.randomSeed == 0) KXP.randomizeSeed();

		KXP.entity = new Entity();

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
		
		KXP.width = Game.the.width;
		KXP.height = Game.the.height;
		KXP.bounds = new Rectangle(0, 0, KXP.width, KXP.height);
		
		KXP.init();
		
		// enable input
		/** enable input */
		Input.enable();

		// switch scenes
		if (!KXP.gotoIsNull()) checkScene();

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
		
		KXP.elapsed = Scheduler.deltaTime;
		
		// update input
		Input.update();
		
		// update console
		//if (KXP.consoleEnabled()) KXP.console.update();
		
		KXP.scene.updateLists();
		if (!KXP.gotoIsNull()) checkScene();
		//if (KXP.tweener.active && KXP.tweener.hasTween) KXP.tweener.updateTweens();
		if (KXP.scene.active)
		{
			//if (KXP.scene.hasTween) KXP.scene.updateTweens();
			KXP.scene.update();
			
		}
		KXP.scene.updateLists(false);
	}
	
	/**
	 * Renders the game, rendering the Scene and Entities.
	 */
	public function render(painter:Painter): Void
	{
		
		//if (KXP.screen.needsResize) KXP.resize(KXP.windowWidth, KXP.windowHeight);

		// timing stuff
		//var t:Float = Lib.getTimer();
		//if (_frameLast == 0) _frameLast = Std.int(t);

		// render loop
		/*if (KXP.renderMode == RenderMode.BUFFER)
		{
			KXP.screen.swap();
			KXP.screen.refresh();
		}*/
		//Draw.resetTarget();

		if (KXP.scene.visible) KXP.scene.render(painter);

		// more timing stuff ?
		/** TODO Oi, btf is this mate? */
		/*t = Lib.getTimer();
		_frameListSum += (_frameList[_frameList.length] = Std.int(t - _frameLast));
		if (_frameList.length > 10) _frameListSum -= _frameList.shift();
		KXP.frameRate = 1000 / (_frameListSum / _frameList.length);
		_frameLast = t;*/
	}
	
	
	/** @private Event handler for stage resize */
	private function resize() : Void
	{
		/** TODO fix resize */
		
		/**if (KXP.width == 0) KXP.width = KXP.stage.stageWidth;
		if (KXP.height == 0) KXP.height = KXP.stage.stageHeight;
		// calculate scale from width/height values
		KXP.windowWidth = KXP.stage.stageWidth;
		KXP.windowHeight = KXP.stage.stageHeight;
		KXP.screen.scaleX = KXP.stage.stageWidth / KXP.width;
		KXP.screen.scaleY = KXP.stage.stageHeight / KXP.height;
		KXP.resize(KXP.stage.stageWidth, KXP.stage.stageHeight);**/
	}
	
	/** @private Switch scenes if they've changed. */
	private function checkScene()
	{
		if (KXP.gotoIsNull()) return;

		if (KXP.scene != null)
		{
			KXP.scene.end();
			KXP.scene.updateLists();
			//if (KXP.scene.autoClear && KXP.scene.hasTween) KXP.scene.clearTweens();
			//if (contains(KXP.scene.sprite)) removeChild(KXP.scene.sprite);
			KXP.swapScene();
			//addChild(KXP.scene.sprite);
			KXP.camera = KXP.scene.camera;
			KXP.scene.updateLists();
			KXP.scene.begin();
			KXP.scene.updateLists();
		}
	}
	
	
}