# Konquest #

Konquest is a small Tech demo to experiment with the dart language and svg.
It is inspired by [Qonk Game](http://anthony.liekens.net/index.php/Computers/Qonk)

## Status ##

The code is in a very early development state. There is a working solar system and some basic infrastructure for the game logic.

It compiles fine with frogc compiler from the dart sdk revision 7692. Currently it does not compile withe the dart2js compiler because it is missing support for some language features such as member access to super.

It runs with some bugs in dartium. This bugs are mostly caused by a bug of dartiums random number generator.

You can try the demo with dartium [here](http://dtillner.github.com/konquest_dart/konquest.svg)

But it is recommended to compile the dart code with frogc to js and test it with chromium.
