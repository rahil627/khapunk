Khapunk
========

Khapunk is a port of [Haxepunk] ( which is a port of Flashpunk... )  
Haxepunk credits go to :  [Matt Tuttle] 

~~~~
> Khapunk is currently under development!
~~~~  
  
Should work on every kha backend as long they are up to date.  

* Tested so far on  
    - Flash  
    - HTML5 
    - Android

TODO
-----
* Input  
    - [x] Mouse and keyboard  
    - [0] Joystick/Gamepad
    - [x] Touchsupport 


* Masks are done except for Pixel based masks...I have to figure that one out
* All Graphic object 
    - [x] Graphic
    - [x] Tilemap
    - [x] Spritemap & Atlasmap*
    - [x] Graphicslist
    - [x] PunkImage ( Originally known as Image )
    - [x] Backdrop
    - [x] Emitter
    - [x] Particle/Particletype
    - [0] TiledImage
    - [0] TiledSpritemap
    - [x] Text


* Debug console
* Create example pack


###How To:###
```
#!haxe

package;

import com.khapunk.Engine;
import com.khapunk.Entity;
import com.khapunk.graphics.PunkImage;
import com.khapunk.KP;
import com.khapunk.Scene;
import kha.Game;
import kha.Canvas;
import kha.Loader;

class Empty extends Game {
	
	var engine:Engine;
	var kpScene:Scene;
	var ent:Entity;

	
	public function new() {
		engine = new Engine();
		super("KhaPunk");
	}
	
	override public function update():Void 
	{
		engine.update();
	}
	
	override public function render(buffer:Framebuffer):Void 
	{
		KP.backbufferA.g2.begin();
		engine.render(KP.backbufferA);
		KP.backbufferA.g2.end();
		
		//Scale and draw our backbuffer into our screen buffer.
		startRender(buffer);
		Scaler.scale(KP.backbufferA, buffer, kha.Sys.screenRotation);
		endRender(buffer);
		
	}
	
	override public function init():Void 
	{
		Loader.the.loadRoom("MyRoom", onLoaded);
		engine.setup();
	}
	
	function onLoaded() : Void
	{
		//Create scene;
		kpScene = new Scene();
		//Init a graphic object
		var g:PunkImage = new PunkImage(Loader.the.getImage("myImage"));
		//create entity and add graphic
		//Set this entities graphic to g
		ent = new Entity(100, 100, g);
		//Add entity to scene
		kpScene.add(ent);
		//Set current scene
		KP.scene = kpScene;
	}
	
	
}
```

###Shaders###

With Graphics2 and Graphics4 Khapunk is able to use shaders with ease. 
To use a shader simply compile and link your shader:
	
```
#!haxe

	//Program object
	var myProgram:Program = new Program();
	myProgram.setVertexShader(new VertexShader(Loader.the.getShader("vertex.vert")));
	myProgram.setFragmentShader(new FragmentShader(Loader.the.getShader("fragment.frag")));
	
	//Standard kha vertex shader attributes
	//Check kha/Shaders/painter-image.vert.glsl for example
	var structure:VertexStructure = new VertexStructure();
	myProgram.add("vertexPosition", VertexData.Float3);
	myProgram.add("texPosition", VertexData.Float2);
	myProgram.add("vertexColor", VertexData.Float4);
		
	//Links and compiles our shader
	program.link(structure);
		

```

Then simply assign the program to your graphics:

```
#!haxe

	myBuffer.g2.begin();

	myBuffer.g2.program = myProgram;
	//set uniform
	myBuffer.g4.setFloat(
		myProgram.getConstantLocation("myUniform"),
		10.0
	);

	
	//Drawcalls
	myBuffer.g2.end();
	
```

Your shaders should be placed in projectRoot/Sources/Shaders/

---

Tiled 
---
tmx loader can be found here
https://bitbucket.org/stalei/khapunktiled  
	
Nape physics
---
Nape scene and entity can be found here
https://bitbucket.org/stalei/khapunk-nape/

---

Check out the [Demo]! 

---
[Demo]:https://47cbfe828dfc48a5eb5b8e3b381243284edffd44.googledrive.com/host/0B97j9rSYGvSsTzctM2F2YW1VN0E/
[Haxepunk/tiled]:https://github.com/HaxePunk/tiled
[Matt Tuttle]:https://github.com/MattTuttle
[Haxepunk]:https://github.com/HaxePunk/HaxePunk


MIT License
----

Copyright (C) 2014 Sidar Talei

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.