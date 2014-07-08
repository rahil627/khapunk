Khapunk
========

Khapunk is a port of [Haxepunk] ( which is a port of Flashpunk... )  
Haxepunk credits go to :  [Matt Tuttle] 

~~~~
> Khapunk is currently under development!
~~~~

TODO
-----
* Input  
    - [x] Mouse and keyboard  
    - [0] Joystick/Gamepad
    - [0] Touchsupport ( although Khas mouse input works for single touch )  


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
* Add Tiled support ( based on : [Haxepunk/tiled] )
---

*Atlasmap wasn't originally in Haxepunk. It allows you to quickly create animations with a texturepacker. For example add("walk") would add the atlas regions named "walk_1" "walk_2" "walk_3". This way you don't have to define the regions or keep your atlas in uniform shape.

---

Check out the [Demo]! 

---
[Demo]:https://47cbfe828dfc48a5eb5b8e3b381243284edffd44.googledrive.com/host/0B97j9rSYGvSsTzctM2F2YW1VN0E/
[Haxepunk/tiled]:https://github.com/HaxePunk/tiled
[Matt Tuttle]:https://github.com/MattTuttle
[Haxepunk]:https://github.com/HaxePunk/HaxePunk

----
MIT License
----

Copyright (C) 2014 Sidar Talei

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
