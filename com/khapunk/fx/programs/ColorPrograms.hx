package com.khapunk.fx.programs ;
import kha.graphics4.FragmentShader;
import kha.graphics4.Program;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Loader;

/**
 * ...
 * @author Sidar Talei
 */

enum Colorshaders {
	Tritanopia;
	Deuternaopia;
	Protanopia;
	Invert;
	Grayscale;
}
 
class ColorPrograms
{
	public static var tritanopia:Program;
	public static var deuteranopia:Program;
	public static var protanopia:Program;
	public static var invert:Program;
	public static var grayscale:Program;
	
	
	public static function init(colorshader:Colorshaders) : Void {
		
		
		var vert = new VertexShader(Loader.the.getShader("non-color-vertex.vert"));
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
 
		switch(colorshader){
		
		case Colorshaders.Tritanopia:
			tritanopia = new Program();
			tritanopia.setFragmentShader(new FragmentShader(Loader.the.getShader("tritanopia.frag")));
			tritanopia.setVertexShader(vert);
			tritanopia.link(structure);
		case Colorshaders.Deuternaopia:
			deuteranopia = new Program();
			deuteranopia.setFragmentShader(new FragmentShader(Loader.the.getShader("deuteranopia.frag")));
			deuteranopia.setVertexShader(vert);
			deuteranopia.link(structure);
		case Colorshaders.Protanopia:
			protanopia = new Program();
			protanopia.setFragmentShader(new FragmentShader(Loader.the.getShader("protanopia.frag")));
			protanopia.setVertexShader(vert);
			protanopia.link(structure);
		case Colorshaders.Invert:
			invert = new Program();
			invert.setFragmentShader(new FragmentShader(Loader.the.getShader("invert.frag")));
			invert.setVertexShader(vert);
			invert.link(structure);
		case Colorshaders.Grayscale:
			grayscale = new Program();
			grayscale.setFragmentShader(new FragmentShader(Loader.the.getShader("grayscale.frag")));
			grayscale.setVertexShader(vert);
			grayscale.link(structure);
		}
		
		
	}
	
}