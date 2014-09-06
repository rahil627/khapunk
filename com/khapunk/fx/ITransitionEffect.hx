package com.khapunk.fx;
import kha.Canvas;

/**
 * ...
 * @author Sidar Talei
 */
class ITransitionEffect
{

	function new() { }
	public function update(): Void{}
	public function init(): Void{}
	public function render(backbuffer:Canvas, transitionBuffer:Canvas):Void{}
	public function stateDone(): Bool { return false; }
	public function completed(): Bool { return false; }
	public function changeState(): Void {
		if (state == TransitionState.IN)
			state = TransitionState.OUT;
		else
			state = TransitionState.IN;
			
			init();
	}
	
	public function reset(): Void {
		init();
		state = TransitionState.OUT;
	}
	
	public var state:TransitionState;
	
}

enum TransitionState{
	IN;
	OUT;
}