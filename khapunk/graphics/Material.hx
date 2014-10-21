package khapunk.graphics;

import kha.Loader;
import khapunk.math.Matrix4;
import kha.Color;
import kha.graphics4.BlendingOperation;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.Program;
import kha.Image;
import khapunk.KP;

using StringTools;

class Pass
{
	public var shader(default, set):Program;
	public var ambient:Color;
	public var diffuse:Color;
	public var specular:Color;
	public var emissive:Color;
	public var shininess:Float = 0;
	public var depthCheck:Bool = false;

	public function new()
	{
		ambient = Color.fromFloats(0, 0, 0, 1);
		diffuse = Color.fromFloats(1, 1, 1, 1);
		specular = Color.fromFloats(0, 0, 0, 0);
		emissive = Color.fromFloats(0, 0, 0, 0);

#if !unit_test
		shader = _defaultShader;
#end

		_textures = new Array<Image>();
	}

	private function set_shader(value:Program):Program
	{
		_ambientLocation = value.getConstantLocation("uAmbientColor");
		_diffuseLocation = value.getConstantLocation("uDiffuseColor");
		_specularLocation = value.getConstantLocation("uSpecularColor");
		_emissiveLocation = value.getConstantLocation("uEmissiveColor");
		_shininessLocation = value.getConstantLocation("uShininess");
		return shader = value;
	}

	public function addTexture(texture:Image, uniformName:String="tex")
	{
		// keep uniform to allow removal of textures?
		// var uniform = shader.uniform(uniformName);
		// shader.use();
		_textures.push(texture);
	}

	public function getTexture(index:Int):Image
	{
		if (index < 0 || index >= _textures.length) return null;
		return _textures[index];
	}

	public function use()
	{
		KP.backbuffer.g2.program = shader;
		KP.backbuffer.g4.setFloat4(_ambientLocation,ambient.R,ambient.G,ambient.B,ambient.A);
		KP.backbuffer.g4.setFloat4(_diffuseLocation, diffuse.R,diffuse.G,diffuse.B,diffuse.A);
		KP.backbuffer.g4.setFloat4(_specularLocation, specular.R,specular.G,specular.B,specular.A);
		KP.backbuffer.g4.setFloat4(_emissiveLocation, emissive.R,emissive.G,emissive.B,emissive.A);
		KP.backbuffer.g4.setFloat(_shininessLocation, shininess);

		KP.backbuffer.g4.setDepthMode(depthCheck, CompareMode.LessEqual);
		KP.backbuffer.g2.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.InverseSourceAlpha);

		// assign any textures
		for (i in 0..._textures.length)
		{
			//_textures[i].bind(i);
		}
	}

	private static var _defaultShader(get, null):Program;
	private static inline function get__defaultShader():Program {
		if (_defaultShader == null)
		{
			/*#if flash
			var vert = "m44 op, va0, vc0\nmov v0, va1";
			var frag = "tex oc, v0, fs0 <linear nomip 2d wrap>";
			#else*/
			//var vert = Assets.getText("shaders/default.vert");
			//var frag = Assets.getText("shaders/default.frag");
			//#end
			//_defaultShader = new Shader(vert, frag);
		}
		return _defaultShader;
	}

	private var _textures:Array<Image>;
	private var _ambientLocation:ConstantLocation;
	private var _diffuseLocation:ConstantLocation;
	private var _specularLocation:ConstantLocation;
	private var _emissiveLocation:ConstantLocation;
	private var _shininessLocation:ConstantLocation;

}

class Technique
{

	public var passes:Array<Pass>;

	public function new()
	{
		passes = new Array<Pass>();
	}

	public function use():Bool
	{
		for (i in 0...passes.length)
		{
			passes[i].use();
		}
		return true;
	}
}

class Material
{

	public var name:String;
	public var techniques:Array<Technique>;

	public function new()
	{
		techniques = new Array<Technique>();
	}

	public static function fromText(text:String):Material
	{
		var data = new MaterialData(text);
		return data.materials[0];
	}

	public static inline function fromAsset(id:String):Material
	{
		return fromText(Loader.the.getBlob(id).toString());
	}

	public var firstPass(get, never):Pass;
	private inline function get_firstPass():Pass
	{
		if (techniques.length < 1) techniques.push(new Technique());
		if (techniques[0].passes.length < 1) techniques[0].passes.push(new Pass());
		return techniques[0].passes[0];
	}

	public function use()
	{
		for (i in 0...techniques.length)
		{
			if (techniques[i].use()) break;
		}
	}

	public inline function disable()
	{
	}

}

#if !unit_test private #end class MaterialData
{

	public var materials:Array<Material>;

	public function new(text:String)
	{
		_text = text;

		materials = new Array<Material>();
		materials.push(material());
	}

	private function scan():String
	{
		if (_next == null)
		{
			_next = next();
		}
		return _next;
	}

	private function next():String
	{
		var buffer:String;
		if (_next == null)
		{
			buffer = "";
			var inComment = false;
			while (_index++ < _text.length)
			{
				var c = _text.charAt(_index-1);
				if (c == '\n' || c == '\r')
				{
					if (buffer != "") return buffer;
					inComment = false;
					continue;
				}
				if (c == '/' && _text.charAt(_index) == '/')
				{
					inComment = true;
				}
				if (inComment) continue;

				if (c == ' ' || c == '\t')
				{
					if (buffer != "") return buffer;
					continue;
				}
				buffer += c;
			}
		}
		else
		{
			buffer = _next;
			_next = null;
		}
		return buffer;
	}

	private function material():Material
	{
		expected("material");
		var material = new Material();
		material.name = next();
		expected("{");
		while (scan() == "technique")
		{
			material.techniques.push(technique(material));
		}
		expected("}");
		return material;
	}

	private function float():Float
	{
		var next = next();
		var value = Std.parseFloat(next);
		if (Math.isNaN(value)) throw 'Expected numeric value got "$next"';
		return value;
	}

	private function bool():Bool
	{
		var next = next();
		return next == "true" ? true : next == "false" ? false : throw 'Expected boolean value got "$next"';
	}

	private function color(color:Color):Void
	{
		next();
		color = Color.fromFloats(float(),float(),float(),1);
	}

	private function pass(technique:Technique)
	{
		expected("pass");
		expected("{");
		var pass = new Pass();
		while (true)
		{
			switch (scan())
			{
				case "ambient":
					color(pass.ambient);
				case "diffuse":
					color(pass.diffuse);
				case "specular":
					color(pass.specular);
				case "emissive":
					color(pass.emissive);
				case "program":
					expected("program");
					///pass.shader = new Shader(Assets.getText(next()), Assets.getText(next())); TODO FIX
				case "depth_check":
					expected("depth_check");
					pass.depthCheck = bool();
				case "texture_unit":
					textureUnit();
				default:
					break;
			}
		}
		expected("}");
		technique.passes.push(pass);
	}

	private function textureUnit()
	{
		expected("texture_unit");
		expected("{");
		texture();
		expected("}");
	}

	private function texture()
	{
		expected("texture");
		var texture = next();
		if (Loader.the.getImage(texture) != null)
		{
			// addTexture(Texture.fromAsset(texture));
		}
		else
		{
			throw 'Texture "$texture" does not exist';
		}
	}

	private function technique(material:Material):Technique
	{
		expected("technique");
		expected("{");
		var technique = new Technique();
		while (scan() == "pass")
		{
			pass(technique);
		}
		expected("}");
		return technique;
	}

	private inline function expected(expected:String):String
	{
		var token = next();
		if (token != expected) throw 'Expected "$expected" but got "$token"';
		return token;
	}

	private var _text:String;
	private var _next:String;
	private var _index:Int = 0;

}
