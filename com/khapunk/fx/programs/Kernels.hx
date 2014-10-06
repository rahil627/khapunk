package com.khapunk.fx.programs ;

/**
 * ...
 * @author Sidar Talei
 */
class Kernels
{

	static inline var onenine:Float = 1 / 9;
	static inline var oneSixteen:Float = 1 / 16;
	
	public static  var identity:Array<Float> = [0, 0, 0, 0, 1, 0, 0, 0, 0];
	public static  var sketch_bleed:Array<Float> = [1, 0, 0, 0, 1, 0, 0, 0, 1];
	public static  var averaging:Array<Float> = [1, 1, 1, 1, 1, 1, 1, 1, 1];
	public static  var edge_enhance:Array<Float> = [0, 0, -1, 1, 0, 0, 0, 0, 0];
	public static  var edge_detect:Array<Float> = [0, 1, 0, 1, -4, 1, 0, 1, 0];
	public static  var edge_vertical:Array<Float> = [-1, 0, 1 ,-1, 0, 1, -1, 0,1];
	public static  var edge_horizontal:Array<Float> = [-1, -1, -1 ,0, 0, 0, 1, 1,1];
	public static  var edgeA:Array<Float> = [1, 0, -1, 0, 0, 0, -1, 0, 1];
	public static  var edgeB:Array<Float> = [ -1, -1, -1, -1, 8, -1, -1, -1, -1];
	public static  var sharpen:Array<Float> = [0, -1, 0, -1, 5, -1, 0, -1, 0];
	public static  var emboss:Array<Float> = [-2, -1, 0, -1, 1, 1, 0, 1, 2];
	public static  var sobel_horizontal:Array<Float> = [1, 2, 1, 0, 0, 0, -1, -2, -1];
	public static  var sobel_vertical:Array<Float> = [-1, 0, 1, -2, 0, 2, -1, 0, 1];
	public static  var sobel:Array<Float> = [ -1, -2, -1, 0, 0, 0, 1, 2, 1];
	public static  var box_blur:Array<Float> = [onenine, onenine, onenine, onenine, onenine, onenine, onenine, onenine, onenine];
	public static  var gaussian_blur:Array<Float> = [
	oneSixteen, 2*oneSixteen, oneSixteen,
	2*oneSixteen, 4*oneSixteen, 2*oneSixteen,
	oneSixteen, 2 * oneSixteen, oneSixteen];
	
}