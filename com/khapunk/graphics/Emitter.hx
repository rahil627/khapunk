package com.khapunk.graphics;

import com.khapunk.Graphic;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.utils.Ease.EaseFunction;
import kha.Color;
import kha.Image;
import kha.math.Vector2;
import kha.Painter;
import kha.Rectangle;

/**
 * ...
 * @author Sidar Talei
 */
class Emitter extends Graphic
{

	/**
	 * Amount of currently existing particles.
	 */
	public var particleCount(default, null):Int;

	// Particle information.
	private var _types:Map<String,ParticleType>;
	private var _particle:Particle;
	private var _cache:Particle;
	private var _color:Color;
	
	// Source information.
	private var _source:Image;
	private var _width:Int;
	private var _height:Int;
	private var _frameWidth:Int;
	private var _frameHeight:Int;
	private var _frameCount:Int;
	private var _frames:Array<AtlasRegion>;
	
	private var _indices:Map < String, Array<Int> > ;

	// Drawing information.
	private var _p:Vector2;
	//private var _tint:ColorTransform;
	private static var SIN(get,never):Float;
	private static inline function get_SIN():Float { return Math.PI / 2; }
	
	/**
	 * Constructor. Sets the source image to use for newly added particle types.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 */
	public function new()
	{
		super();
		_p = new Vector2();
		//_tint = new ColorTransform();
		_types = new Map<String,ParticleType>();
		active = true;
		particleCount = 0;
		_color = Color.White;
	}
	
	/**
	 * Changes the source image to use for newly added particle types.
	 * @param	source			Source image.
	 * @param	frameWidth		Frame width.
	 * @param	frameHeight		Frame height.
	 * @param 	return			The indices for the added frames.
	 */
	public function addSource(source:Dynamic, frameWidth:Int = 0, frameHeight:Int = 0, name:String = "") : Array<Int>
	{
		var indices:Array<Int> = new Array<Int>();
		if(_frames == null)_frames = new Array<AtlasRegion>();
		var currentIndex:Int = _frames.length > 0 ? _frames.length : 0;
		
		var region:AtlasRegion = null;
		if (Std.is(source, Image)) setBitmapSource(cast(source,Image));
		else if(Std.is(source, AtlasRegion)) region = setAtlasRegion(cast(source,AtlasRegion));

		if (_source == null && region == null && Std.is(source,Array))
			throw "Invalid source image.";

		_frameWidth = (frameWidth != 0) ? frameWidth : _width;
		_frameHeight = (frameHeight != 0) ? frameHeight : _height;
		_frameCount = Std.int(_width / _frameWidth) * Std.int(_height / _frameHeight);
		
		if (_frameWidth == 0 || _frameHeight == 0) 
		throw "Width or Height can not be 0";
		
		var ar:AtlasRegion;
		
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
			var rect = new Rectangle(0, 0, _frameWidth, _frameHeight);
			//var center = new Vector2(_frameWidth / 2, _frameHeight / 2);
			
			for (i in 0..._frameCount)
			{
				ar = new AtlasRegion();
				ar.x = Std.int(rect.x);
				ar.y = Std.int(rect.y);
				ar.w = _frameWidth;
				ar.h = _frameHeight;
				ar.image = _source;
				_frames.push(ar);
				rect.x += _frameWidth;
				
				indices.push(currentIndex++);
				
				if (rect.x >= _width)
				{
					rect.y += _frameHeight;
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
	}
	
	private inline function setBitmapSource(bitmap:Image)
	{
		_source = bitmap;
		_width = Std.int(bitmap.width);
		_height = Std.int(bitmap.height);
	}
	
	private inline function setAtlasRegion(region:AtlasRegion):AtlasRegion
	{
		_source = region.image;
		_width = Std.int(region.w);
		_height = Std.int(region.h);
		return region;
	}
	
	override public function update()
	{
		// quit if there are no particles
		if (_particle == null) return;

		// particle info
		var e:Float = KP.elapsed,
			p:Particle = _particle,
			n:Particle;

		// loop through the particles
		while (p != null)
		{
			p._time += e; // Update particle time elapsed
			if (p._time >= p._duration) // remove on time-out
			{
				if (p._next != null) p._next._prev = p._prev;
				if (p._prev != null) p._prev._next = p._next;
				else _particle = p._next;
				n = p._next;
				p._next = _cache;
				p._prev = null;
				_cache = p;
				p = n;
				particleCount --;
				continue;
			}

			// get next particle
			p = p._next;
		}
	}
	
	/**
	 * Clears all particles.
	 */
	public function clear() 
	{
		// quit if there are no particles
		if (_particle == null) 
		{
			return;
		}
		
		// particle info
		var p:Particle = _particle, 
			n:Particle;

		// loop through the particles
		while (p != null)
		{
			// move this particle to the cache
			n = p._next;
			p._next = _cache;
			p._prev = null;
			_cache = p;
			p = n;
			particleCount--;
		}

		_particle = null;
	}
	
	override public function render(painter:Painter , point:Vector2, camera:Vector2)
	{

		
		
		// quit if there are no particles
		if (_particle == null)
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
				p:Particle = _particle,
				type:ParticleType;

			var frameIndex:Int;
			var ar:AtlasRegion;
			var scale:Float;
			var rotation:Float;
			var hw:Float;
			var hh:Float;
			// loop through the particles
			while (p != null)
			{
				// get time scale
				t = p._time / p._duration;

				// get particle type
				type = p._type;

				// get position
				td = (type._ease == null) ? t : type._ease(t);
				_p.x = this.point.x + p._x + p._moveX * (type._backwards ? 1 - td : td);
				_p.y = this.point.y + p._y + p._moveY * (type._backwards ? 1 - td : td);
				p._moveY += p._gravity * td;

				frameIndex = type._frames[Std.int(td * type._frames.length)];
				ar =  _frames[frameIndex];

				_color.R = (type._red + type._redRange * td); // Red
				_color.G = (type._green + type._greenRange * td); // Green
				_color.B = (type._blue + type._blueRange * td); //Blue
				_color.A = type._alpha + type._alphaRange * ((type._alphaEase == null) ? t : type._alphaEase(t)); // Alpha;
				
				scale = type._scale + type._scaleRange * ((type._scaleEase == null) ? t : type._scaleEase(t));  
				rotation = type._rotation + type._rotationRange * ((type._rotationEase == null) ? t : type._rotationEase(t));
				
				hw = (ar.w * scale) / 2;
				hh = (ar.h * scale) / 2;
				
				painter.setColor(_color);
				painter.set_opacity(_color.A);
				painter.drawImage2(ar.image, ar.x, ar.y, ar.w, ar.h, _p.x - hw, _p.y - hh, ar.w * scale, ar.h * scale, rotation, hw, hh);
				painter.setColor(Color.White);
				painter.set_opacity(1);

				// get next particle
				p = p._next;
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

		pt = new ParticleType(name, frames, _width, _frameWidth, _frameHeight);
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
		var p:Particle, type:ParticleType = _types.get(name);

		if (type == null)
			throw "Particle type \"" + name + "\" does not exist.";

		if (_cache != null)
		{
			p = _cache;
			_cache = p._next;
		}
		else
		{
			p = new Particle();
		}
		p._next = _particle;
		p._prev = null;
		if (p._next != null) p._next._prev = p;

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
		particleCount ++;
		return (_particle = p);
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