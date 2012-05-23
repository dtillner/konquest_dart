# Konquest #

Konquest is a small Tech demo to experiment with the __dart__ language and __SVG__.
It is inspired by [Qonk Game](http://anthony.liekens.net/index.php/Computers/Qonk)

![Konquest Screenshot @ revision 522378ec24abdaecd7f4cdd03457f7fc0e464c1](http://cloud.github.com/downloads/dtillner/konquest_dart/konquest_screenshoot_522378ec24abdaecd7f4cdd03457f7fc0e464c1.png)

## Status ##

The code is in a very early development state. There is a working solar system and some basic infrastructure for the game logic.

It compiles fine with frogc compiler from the _dart sdk revision 7692_. Currently it does not compile withe the dart2js compiler because it is missing support for some language features such as member access to super.

It runs with some bugs in dartium. This bugs are mostly caused by a bug of dartiums random number generator.

You can try the demo with dartium [here](http://dtillner.github.com/konquest_dart/konquest.svg)

But it is recommended to compile the dart code with frogc to js and test it with chromium.
