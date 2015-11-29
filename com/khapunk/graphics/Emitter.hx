package com.khapunk.graphics;

import com.khapunk.Graphic;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.utils.Ease.EaseFunction;
import haxe.ds.Vector;
import kha.Canvas;
import kha.Color;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.graphics4.BlendingOperation;
import kha.Image;
import kha.math.Vector2;
import com.khapunk.graphics.Rectangle;

/**
 * ...
 * @author Sidar Talei
 */
class Emitter extends Graphic
{

	/**
	 * Amount of currently existing particles.
	 */
	public var particleCount(get, null):Int;
	function get_particleCount(): Int {
		return activeCount;
	}
	var activeCount(default, null):Int;
	
	public var forceSingleImage:Bool;
	private var imgSource:Image;
	
	// Particle information.
	private var _types:Map<String,ParticleType>;
	private var _particle:Particle;
	private var _cache:Particle;
	private var _cache2:Particle;
	private var _color:Color;
	
	// Source information.
	private var _frames:Array<AtlasRegion>;
	
	private var _indices:Map < String, Array<Int> > ;

	// Drawing information.
	private var _p:Vector2;
	//private var _tint:ColorTransform;
	private static var SIN(get,never):Float;
	private static inline function get_SIN():Float { return Math.PI / 2; }
	

	
	private var particles:Vector<Particle>;
	private var next:Int = 0;
	public var maxParticles:Int;
	
	public var shaderDelta:Bool = false;
	public var loopAnim:Bool = true;
	public var loopSpeed:Float = 1.0;
	
	/**
	 * Constructor. Sets the source image to use for newly added particle types.
	 * @param	maxCount maximum particles to be active at once.
	 */
	public function new(maxCount:Int = 100)
	{
		maxParticles = maxCount;
		super();
		_p = new Vector2();
		//_tint = new ColorTransform();
		_types = new Map<String,ParticleType>();
		active = true;
		activeCount = 0;
		_color = Color.White;
		particles = new Vector<Particle>(maxParticles);
	}
	
	/**
	 * Adds frames to be used by different particle types. Returns the indices of the newly added frames.
	 * Source can be an Kha.Image, Atlasregion or an array of Atlasregions retrieved by TextureAtlas.
	 * 
	 * @param	source			Source atlas.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 * @param 	name			cache the indices with this name.
	 * @param 	return			The indices for the added frames.
	 */
	public function addFrames(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0, name:String = "") : Array<Int>
	{
		var image:Image = null;
		var srcWidth:Int = 0;
		var srcHeight:Int = 0;
		var region:AtlasRegion = null;
		var ar:AtlasRegion;
		var fw:Int = 0;
		var fh:Int = 0;
		var frameCount:Int = 0;
		
		var indices:Array<Int> = new Array<Int>();
		if(_frames == null)_frames = new Array<AtlasRegion>();
		var currentIndex:Int = _frames.length > 0 ? _frames.length : 0;
		
		var region:AtlasRegion = null;
		if (Std.is(source, Image)) {
			image = cast(source, Image);
			srcWidth = image.width;
			srcHeight = image.height;
		}
		else if (Std.is(source, AtlasRegion)) {
			region =  cast(source, AtlasRegion);
			image = region.image;
			srcWidth = region.w;
			srcHeight = region.h;
		}

		if (image == null && !Std.is(source,Array))
			throw "Invalid source image.";
		if (forceSingleImage && imgSource != null && imgSource != image)
			throw "'force single image' enabled, use same image source.";
		else if(forceSingleImage)imgSource = image;
			
		fw = (frameWidth != 0) ? frameWidth : srcWidth;
		fh = (frameHeight != 0) ? frameHeight : srcHeight;
		frameCount = Std.int(srcWidth / fw) * Std.int(srcHeight / fh);
		
		if (fw == 0 || fh == 0) 
		throw "Width or Height can not be 0";
		
		if (Std.is(source, Array))
		{
			var arr:Array<AtlasRegion> = cast source;
			for (i in 0...arr.length)
			{
				_frames.push(arr[i]);
				indices.push(currentIndex++);
			}
		}
		else  
		{
			var rect = new Rectangle(0, 0, fw, fh);
			
			for (i in 0...frameCount)
			{
				ar = new AtlasRegion();
				ar.x = Std.int(rect.x);
				ar.y = Std.int(rect.y);
				ar.w = fw;
				ar.h = fh;
				ar.image = image;
				_frames.push(ar);
				rect.x += fw;
				
				indices.push(currentIndex++);
				
				if (rect.x >= srcWidth)
				{
					rect.y += fh;
					rect.x = 0;
				}
			}
		}
		if (name != "") {
			if (_indices == null) _indices = new Map < String, Array<Int> > ();
			_indices.set(name,indices);
		}
		
	
		
		return indices;
	}
	
	/**
	 * Retrieves the cached indices ( if any was set by name )
	 * @param	name the name of the cached indices
	 * @return  Array of indices.
	 */
	public function getFrameIndices(name:String) : Array<Int>
	{
		if (_indices == null && !_indices.exists(name)) return null;
		return _indices.get(name);
	}
	
	/**
	 * Clears the frames
	 */
	public function clearFrames() : Void
	{
		_frames = null;
		_indices = null;
		activeCount = 0;
	}
	
	override public function update()
	{
		// quit if there are no particles
		if (activeCount == 0) return;

		// loop through the particles
		for (i in 0...activeCount )
		{
			_particle = particles[i];
			_particle._time += KP.elapsed; // Update particle time elapsed
			if (_particle._time >= _particle._duration) // remove on time-out
			{
				_cache = particles[i];
				_cache2 = particles[activeCount - 1];
				
				particles[i] = _cache2;
				particles[activeCount - 1] = _cache;
				activeCount--;
				continue;
			}
		}
	}
	
	/**
	 * Clears all particles.
	 */
	public function clear() 
	{
		activeCount = 0;
	}
	
	override public function render(buffer:Canvas , point:Vector2, camera:Vector2)
	{
		
		material.apply(buffer);
		
		// quit if there are no particles
		if (activeCount == 0)
		{
			return;
		}
		else
		{
			
			// get rendering position
			this.point.x = point.x + x - camera.x * scrollX;
			this.point.y = point.y + y - camera.y * scrollY;

			// particle info
			var t:Float, td:Float,
				type:ParticleType;

			var frameIndex:Int;
			var ar:AtlasRegion;
			var scale:Float;
			var rotation:Float;
			var hw:Float;
			var hh:Float;
			
			var loopDelta:Int;
			
			// loop through the particles
			for(i in 0...activeCount)
			{
				_particle = particles[i];
				// get time scale
				t = _particle._time / _particle._duration;
				
				// get particle type
				type = _particle._type;
				
				//setblend
				//buffer.g2.setBlendingMode(type._sourceBlend, type._destinationBlend);
				
				
				td = (type._ease == null) ? t : type._ease(t);
				
				
				/*if (shaderDelta && material.constants != null) {
					material.constants.setFloat("delta", td);
					material.updateConsts(buffer);
				}*/
				
				// get position
				_p.x = this.point.x + _particle._x + _particle._moveX * (type._backwards ? 1 - td : td);
				_p.y = this.point.y + _particle._y + _particle._moveY * (type._backwards ? 1 - td : td);
				_particle._moveY += _particle._gravity * td;
				
				if (type._loopAnim) {
					loopDelta = Std.int(_particle._time / (1 / type._loopSpeed));
					frameIndex = type._frames[loopDelta % (type._frames.length - 1)];
				}
				else {
					frameIndex = type._frames[Std.int(td * (type._frames.length-1))];
				}
				
				ar =  _frames[frameIndex];
				
				_color.R = (type._red + type._redRange * td); // Red
				_color.G = (type._green + type._greenRange * td); // Green
				_color.B = (type._blue + type._blueRange * td); //Blue
				_color.A = type._alpha + type._alphaRange * ((type._alphaEase == null) ? t : type._alphaEase(t)); // Alpha;
				
				scale = type._scale + type._scaleRange * ((type._scaleEase == null) ? t : type._scaleEase(t));  
				rotation = type._angle + type._rotation + type._rotationRange * ((type._rotationEase == null) ? t : type._rotationEase(t));
				
				hw = (ar.w * scale) / 2;
				hh = (ar.h * scale) / 2;
				
				buffer.g2.color = (_color);
				buffer.g2.set_opacity(_color.A);
				
				buffer.g2.pushRotation(rotation, _p.x, _p.y);
				
				buffer.g2.drawScaledSubImage(forceSingleImage?imgSource:ar.image, 
				ar.x, 
				ar.y, 
				ar.w, 
				ar.h, 
				_p.x - hw, 
				_p.y - hh, 
				ar.w * scale,
				ar.h * scale);
				
				buffer.g2.popTransformation();
				
				buffer.g2.color = (Color.White);
				buffer.g2.set_opacity(1);
			}
			
		
		} 
	}
	
	/**
	 * Creates a new Particle type for this Emitter.
	 * @param	name		Name of the particle type.
	 * @param	frames		Array of frame indices for the particles to animate.
	 * @return	A new ParticleType object.
	 */
	public function newType(name:String, frames:Array<Int> = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);

		if (pt != null)
			throw "Cannot add multiple particle types of the same name";

		pt = new ParticleType(name, frames);
		_types.set(name, pt);

		return pt;
	}
	
	/**
	 * Defines the motion range for a particle type.
	 * @param	name			The particle type.
	 * @param	angle			Launch Direction.
	 * @param	distance		Distance to travel.
	 * @param	duration		Particle duration.
	 * @param	angleRange		Random amount to add to the particle's direction.
	 * @param	distanceRange	Random amount to add to the particle's distance.
	 * @param	durationRange	Random amount to add to the particle's duration.
	 * @param	ease			Optional ease function.
	 * @param	backwards		If the motion should be played backwards.
	 * @return	This ParticleType object.
	 */
	public function setMotion(name:String, angle:Float, distance:Float, duration:Float, ?angleRange:Float = 0, ?distanceRange:Float = 0, ?durationRange:Float = 0, ?ease:EaseFunction = null, ?backwards:Bool = false):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setMotion(angle, distance, duration, angleRange, distanceRange, durationRange, ease, backwards);
	}
	
	/**
	 * Sets the gravity range for a particle type.
	 * @param	name      		The particle type.
	 * @param	gravity      	Gravity amount to affect to the particle y velocity.
	 * @param	gravityRange	Random amount to add to the particle's gravity.
	 * @return	This ParticleType object.
	 */
	public function setGravity(name:String, ?gravity:Float = 0, ?gravityRange:Float = 0):ParticleType
	{
		return cast(_types.get(name) , ParticleType).setGravity(gravity, gravityRange);
	}
	
	/**
	 * Sets the alpha range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting alpha.
	 * @param	finish		The finish alpha.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setAlpha(name:String, ?start:Float = 1, ?finish:Float = 0, ?ease:EaseFunction = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setAlpha(start, finish, ease);
	}

	public function setBlend(name:String, source:BlendingOperation, destination:BlendingOperation) : ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setBlend(source,destination);
	}
	
	
	/**
	 * Sets the scale range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting scale.
	 * @param	finish		The finish scale.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setScale(name:String, ?start:Float = 1, ?finish:Float = 0, ?ease:EaseFunction = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setScale(start, finish, ease);
	}
	
		
	/**
	 * Sets the scale range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting rotation.
	 * @param	finish		The finish rotation.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setRotation(name:String, ?start:Float = 0, ?finish:Float = 360, ?ease:EaseFunction = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setRotation(start, finish, ease);
	}
	
	
	/**
	 * 
	 * @param	shouldLoop		Whether it should loop or not. 
	 * 							If set to false the animation is distributed over lifetime.
	 * @param	speed		How fast it should animate.
	 * @param	speedRange		Random speed to add to speed.
	 * @return	This ParticleType object.
	 */
	public function setAnimLoop(name:String, shouldLoop:Bool, ?speed:Float = 1, ?speedRange:Float = 0):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setAnimLoop(shouldLoop, speed, speedRange);
	}
	
	/**
	 * Sets the color range of the particle type.
	 * @param	name		The particle type.
	 * @param	start		The starting color.
	 * @param	finish		The finish color.
	 * @param	ease		Optional easer function.
	 * @return	This ParticleType object.
	 */
	public function setColor(name:String, ?start:Int = 0xFFFFFF, ?finish:Int = 0, ?ease:EaseFunction = null):ParticleType
	{
		var pt:ParticleType = _types.get(name);
		if (pt == null) return null;
		return pt.setColor(start, finish, ease);
	}
	
	/**
	 * Emits a particle.
	 * @param	name		Particle type to emit.
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @return	The Particle emited.
	 */
	public function emit(name:String, ?x:Float = 0, ?y:Float = 0):Particle
	{
		//TODO FIX CONTINUES EMIT
		if (activeCount + 1 > maxParticles) return null;
		
		var p:Particle, type:ParticleType = _types.get(name);

		if (type == null)
			throw "Particle type \"" + name + "\" does not exist.";

		if (particles.get(activeCount) != null)
		{
			p = particles.get(activeCount);
		}
		else
		{
			p = particles.set(activeCount, new Particle());
		}

		p._type = type;
		p._time = 0;
		p._duration = type._duration + type._durationRange * KP.random;
		var a:Float = type._angle + type._angleRange * KP.random,
			d:Float = type._distance + type._distanceRange * KP.random;
		p._moveX = Math.cos(a) * d;
		p._moveY = Math.sin(a) * d;
		p._x = x;
		p._y = y;
		p._gravity = type._gravity + type._gravityRange * KP.random;
		activeCount ++;
		return p;
	}
	
	/**
	 * Randomly emits the particle inside the specified radius
	 * @param	name		Particle type to emit.
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @param	radius		Radius to emit inside.
	 *
	 * @return The Particle emited.
	 */
	public function emitInCircle(name:String, x:Float, y:Float, radius:Float):Particle
	{
		var angle = Math.random() * Math.PI * 2;
		radius *= Math.random();
		return emit(name, x + Math.cos(angle) * radius, y + Math.sin(angle) * radius);
	}
	
	/**
	 * Randomly emits the particle inside the specified area
	 * @param	name		Particle type to emit
	 * @param	x			X point to emit from.
	 * @param	y			Y point to emit from.
	 * @param	width		Width of the area to emit from.
	 * @param	height		height of the area to emit from.
	 *
	 * @return The Particle emited.
	 */
	public function emitInRectangle(name:String, x:Float, y:Float, width:Float ,height:Float):Particle
	{
		return emit(name, x + KP.random * width, y + KP.random * height);
	}
}