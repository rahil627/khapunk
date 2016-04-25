package com.khapunk.debug;
import com.khapunk.debug.DebugDraw.Line;
import haxe.ds.GenericStack;
import kha.Canvas;
import kha.Color;
import kha.math.Vector2;

/**
 * ...
 * @author Sidar Talei
 */
class DebugDraw
{
	
	static var queue:Array<Line> = new Array<Line>();
	
	public static function drawLine(start:Vector2, end:Vector2, color:Color, duration:Float = 2) : Void {
		var l:Line = new Line();
		l.start = start;
		l.end = end;
		l.color = color;
		l.duration = duration;
		l.done = false;
		l.durationDelta = duration;
		queue.push(l);
	}
	
	public static function renderLine(g:Canvas, newBegin:Bool = true) : Void {
		if(newBegin){
			g.g2.pipeline = null;
			g.g2.begin(false);
		}
		var l:Line;
		for (i in 0...queue.length) 
		{
			l = queue[i];
			g.g2.color = l.color;
			g.g2.drawLine(l.start.x - KP.scene.camera.x, l.start.y - KP.scene.camera.y, l.end.x - KP.scene.camera.x, l.end.y - KP.scene.camera.y, 2);
			l.durationDelta -= KP.elapsed; if (l.durationDelta <= 0) l.done = true;
		}
			g.g2.color = Color.White;
		if(newBegin){
			g.g2.end();
		}
		
		
		var i:Int = queue.length-1;
		
		while (i > -1) {

			if (queue[i].done) queue.splice(i, 1);
				i--;
		}
		
	}
	
}

class Line {
	public function new() { }
	public var start:Vector2;
	public var end:Vector2;
	public var color:Color;
	public var duration:Float;
	public var alpha:Float = 1;
	public var durationDelta:Float;
	public var done:Bool = false;
}