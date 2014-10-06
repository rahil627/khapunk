package com.khapunk.graphics;
import com.khapunk.graphics.primitives.Geometry;
import kha.graphics4.CompareMode;
import kha.Image;
import kha.math.Matrix4;
import kha.math.Vector2;

import com.khapunk.Graphic;
import kha.Canvas;

/**
 * ...
 * @author Sidar Talei
 */
class Mesh extends Graphic
{
	static var helperMatrix:Matrix4;
	
	var geom:Geometry;
	public var textured(default, null) : Bool = false;
	
	public var texture(default, set):Image;
	function set_texture(t:Image): Image {
		if (t == null) {
			texture = null;
			textured = false; 
			return null;
		}
		textured = true;
		texture = t;
		return texture;
	}
	public var matrix:Matrix4;
	
		

	private var _scale:Float;
	
	/**
	 * Rotation of the image, in degrees.
	 */
	public var angle:Float;

	/**
	 * Scale of the image, effects both x and y scale.
	 */
	public var scale(get, set):Float;
	private inline function get_scale():Float { return _scale; }
	private inline function set_scale(value:Float):Float { return _scale = value; }

	
	public function setRotationX(a:Float) : Void
	{
		helperMatrix.matrix[0] = 1; helperMatrix.matrix[1] = 0; helperMatrix.matrix[2] = 0; helperMatrix.matrix[3] = 1;
		helperMatrix.matrix[4] = 0; helperMatrix.matrix[5] = Math.cos(a) ; helperMatrix.matrix[6]  = -Math.sin(a); helperMatrix.matrix[7] = 1;
		helperMatrix.matrix[8] = 0; helperMatrix.matrix[9] = Math.sin(a) ; helperMatrix.matrix[10] = Math.cos(a); helperMatrix.matrix[11] = 1;
		helperMatrix.matrix[12] = 1; helperMatrix.matrix[13] = 1; helperMatrix.matrix[14] = 1; helperMatrix.matrix[15] = 1;
		
		matrix.multmat(helperMatrix);
		
	}
	/*
	public function setRotationY(a:Float) : Void
	{
		helperMatrix[0] = Math.cos(a); helperMatrix[1] = 0; helperMatrix[2] = Math.sin(a); helperMatrix[3] = 1;
		helperMatrix[4] = 0; helperMatrix[5] = 1 ; helperMatrix[6]  = 0 ; helperMatrix[7] = 1;
		helperMatrix[8] = -Math.sin(a); helperMatrix[9] = 0; helperMatrix[10] = Math.cos(a); helperMatrix[11] = 1;
		helperMatrix[12] = 1; helperMatrix[13] = 1; helperMatrix[14] = 1; helperMatrix[15] = 1;
		
		matrix.multmat(helperMatrix);
		
	}
	
	public function setRotationZ(a:Float) : Void
	{
		helperMatrix[0] = Math.cos(a); helperMatrix[1] =  -Math.sin(a); helperMatrix[2] = 0; helperMatrix[3] = 1;
		helperMatrix[4] =  Math.sin(a); helperMatrix[5] = Math.cos(a) ; helperMatrix[6] = 0 ; helperMatrix[7] = 1;
		helperMatrix[8] = 0; helperMatrix[9] = Math.sin(a) ; helperMatrix[10] = Math.cos(a); helperMatrix[11] = 1;
		helperMatrix[12] = 1; helperMatrix[13] = 1; helperMatrix[14] = 1; helperMatrix[15] = 1;
		
		matrix.multmat(helperMatrix);
		
	}
	*/
	
	
	/**
	 * X scale of the image.
	 */
	public var scaleX:Float;

	/**
	 * Y scale of the image.
	 */
	public var scaleY:Float;

	/**
	 * X origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originX:Float;

	/**
	 * Y origin of the image, determines transformation point.
	 * Defaults to top-left corner.
	 */
	public var originY:Float;
	
	public function new(g:Geometry) 
	{
		if (helperMatrix == null)  helperMatrix = Matrix4.identity();
		geom = g;
		matrix = Matrix4.identity();
		super();
		
		scaleX = scaleY = scale = 1;
		originX = originY = 0;
		
		geom.build();
	}
	
	override public function render(buffer:Canvas, point:Vector2, camera:Vector2) : Void
	{
		var sx = scale * scaleX,
		sy = scale * scaleY;
		
		buffer.g4.setDepthMode(true , CompareMode.Less );
		buffer.g4.setProgram(Geometry.meshProgram);
		
		// determine drawing location
		matrix.matrix[3 ] = point.x + x - originX * sx - camera.x * scrollX;
		matrix.matrix[7 ] = point.y + y - originY * sy - camera.y * scrollY;
		matrix.matrix[11] = 100;
		
		///var proj = matrix.multmat(Matrix4.orthogonalProjection(0, 640, 0, 480, 0.01, 100));
	
		buffer.g4.setBool(Geometry.meshProgram.getConstantLocation("texturing"), textured);
		buffer.g4.setBool(Geometry.meshProgram.getConstantLocation("lighted"), textured);
		if (textured)
		buffer.g4.setTexture(Geometry.meshProgram.getTextureUnit("tex"), texture);
		buffer.g4.setMatrix(Geometry.meshProgram.getConstantLocation("mvpMatrix"), matrix);
		
		buffer.g4.setVertexBuffer(geom.vertexBuffer);
		buffer.g4.setIndexBuffer(geom.indexBuffer);
		buffer.g4.drawIndexedVertices();
		
		buffer.g4.setDepthMode(false , CompareMode.Always );
		
		buffer.g2.program = null;
		
		
	}
	
	
	
}