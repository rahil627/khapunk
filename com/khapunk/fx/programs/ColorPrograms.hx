package com.khapunk.fx.programs;
import kha.graphics4.FragmentShader;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;

import kha.Shaders;

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
	Gameboy;
}
 
class ColorPrograms
{
	public static var tritanopia:PipelineState;
	public static var deuteranopia:PipelineState;
	public static var protanopia:PipelineState;
	public static var invert:PipelineState;
	public static var grayscale:PipelineState;
	public static var gameboy:PipelineState;
	
	
	public static function init(colorshader:Colorshaders) : Void {
		
		
		var vert = Shaders.non_color_vertex_vert;
		var structure:VertexStructure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("texPosition", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		
 
		switch(colorshader){
		
		case Colorshaders.Tritanopia:
			tritanopia = new PipelineState();
			tritanopia.fragmentShader = Shaders.tritanopia_frag;
			tritanopia.vertexShader = vert;
			tritanopia.inputLayout = [structure];
			tritanopia.compile();
		case Colorshaders.Deuternaopia:
			deuteranopia =  new PipelineState();
			deuteranopia.fragmentShader = Shaders.deuteranopia_frag;
			deuteranopia.vertexShader = vert;
			deuteranopia.inputLayout = [structure];
			deuteranopia.compile();
		case Colorshaders.Protanopia:
			protanopia =  new PipelineState();
			protanopia.fragmentShader = Shaders.protanopia_frag;
			protanopia.vertexShader = vert;
			protanopia.inputLayout = [structure];
			protanopia.compile();
		case Colorshaders.Invert:
			invert =  new PipelineState();
			invert.fragmentShader = Shaders.invert_frag;
			invert.vertexShader = vert;
			invert.inputLayout = [structure];
			invert.compile();
		case Colorshaders.Grayscale:
			grayscale = new PipelineState();
			grayscale.fragmentShader = Shaders.grayscale_frag;
			grayscale.vertexShader = vert;
			grayscale.inputLayout = [structure];
			grayscale.compile();
		case Colorshaders.Gameboy:
			gameboy =  new PipelineState();
			gameboy.fragmentShader =  Shaders.gameboy_palette_frag;
			gameboy.vertexShader = vert;
			gameboy.inputLayout = [structure];
			gameboy.compile();
			
		}
		
		
	}
	
}