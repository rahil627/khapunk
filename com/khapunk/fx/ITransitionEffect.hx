package com.khapunk.fx;
import kha.Canvas;

/**
 * ...
 * @author Sidar Talei
 */
interface ITransitionEffect
{

	public function update(): Void;
	public function init(): Void;
	public function render(backbuffer:Canvas, transitionBuffer:Canvas):Void;
	public function done(): Bool;
	public var state:TransitionState;
	
}

enum TransitionState{
	IN;
	OUT;
}