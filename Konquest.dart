#import('dart:html');
#import('lib/Toolbox.dart');
#source('SVGHelper.dart');

class Planet extends Circle {
    TextField _text;
    int _ships;
    int _player;
    int _type;
    num rotation;

    static final List<String>playerColors = const ['white', 'red', 'blue'];

    Planet() {
        _text = new TextField(2);
        _text.font = 'Iceland';
    }

    num get textSize() => _text.size;
    set textSize(num textSize) {
        _text.size = textSize;
    }

    set center(Vector2D center) {
        super.center = center;
        _text.position = new Vector2D(center.x + size * 1.5, center.y);
    }

    int get player() => _player;
    set player(int player) {
        _player = player;
        _text.color = playerColors[player];

        Circle.addGradient('Player${player}PlanetGradient', playerColors[_player], 'black');
        style = 'fill:url(#Player${player}PlanetGradient)';
    }

    int get ships() => _ships;
    set ships(int ships) {
        _ships = ships;
        _text.setLine(1, 'Ships: $ships');
    }

    int get type() => _type;
    set type(int type) {
        _type = type;
        _text.setLine(0, 'Type: ${type+1}');
    }

    static List<Planet> Factory(int numOfPlanets) {
        List<Planet> planets = new List<Planet>(numOfPlanets);

        num orbitRange = (Canvas.outerCircle - Canvas.innerCircle) / (numOfPlanets);

        for(int i=0; i<numOfPlanets; i++) {
            planets[i] = new Planet();

            planets[i].type = (Math.random()*10).truncate() % 4;
            planets[i].size = orbitRange * (0.2 + planets[i].type * 0.05);
            planets[i].textSize = 18;

            planets[i].center = new Vector2D(orbitRange*i + Canvas.innerCircle + orbitRange/2, 0);
            planets[i].center.rotate(Math.random()*360);
            planets[i].center += Canvas.screenSize / 2;

            planets[i].rotation = (Math.random() - 0.5) / 5;

            planets[i].player = 0;
            planets[i].ships = (Math.random()*10).round();
        }

        //FIXIT: double to int conversion?
        int p1 = ((Math.random() * 10).truncate() % 5).toInt();
        int p2 = (((Math.random() * 10).truncate() % 5) + 5).toInt();

        num type = (Math.random()*10).truncate() % 4;
        num size = orbitRange * (0.2 + type * 0.05);

        planets[p1].player = 1;
        planets[p1].ships = 10;
        planets[p1].type = type;
        planets[p1].size = size;
        planets[p2].player = 2;
        planets[p2].ships = 10;
        planets[p2].type = type;
        planets[p2].size = size;

        return planets;
    }
}

class Canvas {
    Map<String, List> elements;

    static Vector2D screenSize;
    static num outerCircle;
    static num innerCircle;

    Canvas() {
        elements = new Map<String, List>();

        screenSize = new Vector2D(window.innerWidth, window.innerHeight);

        outerCircle = (screenSize.x > screenSize.y) ? screenSize.y / 2 : screenSize.x / 2;
        innerCircle = outerCircle / 100 * 20;

        window.on.resize.add((e){resize();});
    }

    void resize() {
        Vector2D oldScreenSize = new Vector2D(screenSize.x, screenSize.y);
        screenSize.x = window.innerWidth;
        screenSize.y = window.innerHeight;

        Vector2D scale = screenSize / oldScreenSize;
        Vector2D scale2 = screenSize / (elements["grid"][elements["grid"].length-1].size * 2);

        num maxScale = (screenSize.x > screenSize.y) ? scale2.y : scale2.x;

        List<String> keys = elements.getKeys();
        for(int i=0; i<elements.length; i++) {
            for(int j=0; j<elements[keys[i]].length; j++) {
                elements[keys[i]][j].center -= oldScreenSize / 2;
                elements[keys[i]][j].center *= maxScale;
                elements[keys[i]][j].size *= maxScale;
                //TODO: planet should set textsize
                if(keys[i] == 'planets') {
                    elements[keys[i]][j].textSize *= maxScale;
                }
                elements[keys[i]][j].center += screenSize / 2;
            }
        }
    }
}

class Konquest {
    Canvas _canvas;

    Konquest() {
        _canvas = new Canvas();

        _canvas.elements['stars'] = new List<Circle>(50);
        for(int i=0; i<_canvas.elements['stars'].length; i++) {
            _canvas.elements['stars'][i] = new Circle();
            num cx = Math.random() * Canvas.outerCircle * 2  + (Canvas.screenSize.x / 2 - Canvas.outerCircle);
            num cy = Math.random() * Canvas.outerCircle * 2  + (Canvas.screenSize.y / 2 - Canvas.outerCircle);
            _canvas.elements['stars'][i].center = new Vector2D(cx, cy);
            _canvas.elements['stars'][i].size = Canvas.outerCircle / 250;
            _canvas.elements['stars'][i].style = 'fill:white';
        }

        _canvas.elements['grid']  = new List<Circle>(6);
        for(int i=0; i<_canvas.elements['grid'].length; i++) {
            _canvas.elements['grid'][i] = new Circle();
            _canvas.elements['grid'][i].center = Canvas.screenSize/2;
            _canvas.elements['grid'][i].size = ((Canvas.outerCircle - Canvas.innerCircle) / 5) * i + Canvas.innerCircle;
            _canvas.elements['grid'][i].stroke = 'green';
            _canvas.elements['grid'][i].style = 'fill-opacity:0.0';
        }

        _canvas.elements['suns'] = new List<Circle>(1);
        _canvas.elements['suns'][0] = new Circle();
        _canvas.elements['suns'][0].center = Canvas.screenSize / 2;
        _canvas.elements['suns'][0].size = Canvas.outerCircle / 100 * 10;
        Circle.addGradient('SunGradient', 'rgb(255,255,0)', 'rgb(255,0,0)');
        _canvas.elements['suns'][0].style = 'fill:url(#SunGradient)';

        _canvas.elements['planets'] = Planet.Factory(10);

        window.setInterval((){update();}, 5000);
        window.setInterval((){render();}, 1000 / 25);
    }

    void update() {
        for(int i=0; i<_canvas.elements['planets'].length; i++) {
            if(_canvas.elements['planets'][i].player > 0) {
                _canvas.elements['planets'][i].ships++;
            }
        }
    }

    void render() {
        for(var i=0; i<_canvas.elements['planets'].length; i++) {
            _canvas.elements['planets'][i].center -= Canvas.screenSize/2;
            _canvas.elements['planets'][i].center.rotate(_canvas.elements['planets'][i].rotation);
            _canvas.elements['planets'][i].center += Canvas.screenSize/2;
        }
    }
}

main() {
    new Konquest();
}
