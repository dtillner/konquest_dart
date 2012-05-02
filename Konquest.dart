#import('dart:dom');
#import('lib/Toolbox.dart');

final String svgNS = 'http://www.w3.org/2000/svg';

class TextField {
    SVGElement _node;
    Vector2D _position;
    List<String> _lines;
    List<SVGElement> _lineNodes;
    String _color;
    String _font;
    num _size;

    TextField(num lines) {
        _node = document.createElementNS(svgNS, 'text');
        document.documentElement.appendChild(_node);
        
        _lines = new List<String>(lines);
        _lineNodes = new List<SVGElement>(lines);
        
        for(int i=0; i<_lineNodes.length; i++) {
            _lineNodes[i] = document.createElementNS(svgNS, 'tspan');
            _node.appendChild(_lineNodes[i]);
        }
    }
    
    Vector2D get position() => _position;
    set position(Vector2D position) {
        _position = position;

        for(int i=0; i<_lineNodes.length; i++) {
            _lineNodes[i].setAttribute('x', _position.x.toString());
        }
        _node.setAttribute('y', _position.y.toString());
    }
    
    String getLine(num line) => _lines[line];
    setLine(num line, String text) {
        _lines[line] = text;
        _node.childNodes[line].textContent = text;
    }
    
    String get color() => _color;
    set color(String color) {
        _color = color;
        _node.setAttribute('style', 'fill:$_color; font-family:$_font; font-size:$_size;');
    }
    
    String get font() => _font;
    set font(String font) {
        _font = font;
        _node.setAttribute('style', 'fill:$_color; font-family:$_font; font-size:$_size;');
    }
    
    num get size() => _size;
    set size(String size) {
        _size = size;
        _node.setAttribute('style', 'fill:$_color; font-family:$_font; font-size:$_size;');
        
        for(int i=0; i<_lineNodes.length; i++) {
            _lineNodes[i].setAttribute('dy', '${i*size}');
        }
    }
}

class Circle {
    SVGElement _node;
    Map _values;
    
    //Circle([num this.size, Vector2D this.center, String this.stroke, String this.style]) {
    Circle() {
        _node = document.createElementNS(svgNS, 'circle');
        _values = new Map();
        document.documentElement.appendChild(_node);
    }
    
    num get size() => _values['size'];
    set size(num size) {
        _node.setAttribute('r', size.toString());
        _values['size'] = size;
    }
    
    Vector2D get center() => _values['center'];
    set center(Vector2D center) {
        _node.setAttribute('cx', center.x.toString());
        _node.setAttribute('cy', center.y.toString());
        _values['center'] = center;        
    }
    
    num get stroke() => _values['stroke'];
    set stroke(String stroke) {
        _node.setAttribute('stroke', stroke);
        _values['stroke'] = stroke;
    }
    
    num get style() => _values['style'];
    set style(String style) {
        _node.setAttribute('style', style);
        _values['style'] = style;
    }
}

class Planet extends Circle {
    TextField _text;
    int _ships;
    int _player;
    num rotation;

    Planet() {
        _text = new TextField(2);
        //TODO: player color;
        _text.color = 'red';
        _text.font = 'Iceland';
    }
    
    set size(num size) {
        super.size = size;
        //TODO: correct font size and position;
        _text.size = 15;
    }
    
    set center(Vector2D center) {
        super.center = center;
        //TODO: correct font size and position;
        _text.position = super.center;
        _text.size = 15;
    }
    
    int get player() => _player;
    set player(int player) {
        _player = player;
        _text.setLine(0, 'Player: $player');
    }
    
    int get ships() => _ships;
    set ships(int ships) {
        _ships = ships;
        _text.setLine(1, 'Ships: $ships');
    }
}

class Konquest {
    Vector2D screenSize;

    List<Circle> grid;
    List<Circle> stars;
    List<Planet> planets;
    Circle sun;
    
    Konquest() {
        screenSize = new Vector2D(window.innerWidth, window.innerHeight);
        
        num outerCircle = (screenSize.x > screenSize.y) ? screenSize.y / 2 : screenSize.x / 2;
        num innerCircle = outerCircle / 100 * 20;   

        grid = new List<Circle>(4);
        for(int i=0; i<grid.length; i++) {
            grid[i] = new Circle();
            grid[i].center = screenSize/2;
            grid[i].size = (outerCircle / 100) * (25 * (4-i));
            grid[i].stroke = 'green';
        }

        stars = new List<Circle>(50);
        for(int i=0; i<stars.length; i++) {
            stars[i] = new Circle();
            stars[i].center = new Vector2D(Math.random() * screenSize.x, Math.random() * screenSize.y);
            stars[i].size = outerCircle / 250;
            stars[i].style = 'fill:white';
        }
        
        planets = new List<Planet>(10);
        for(int i=0; i<planets.length; i++) {
            num tmpX = Math.random() * (outerCircle - innerCircle) + innerCircle;
            num tmpRot = Math.random()*360;
        
            planets[i] = new Planet();
            planets[i].center = new Vector2D(tmpX, 0);
            planets[i].center.rotate(tmpRot);
            planets[i].center += screenSize / 2;
            planets[i].size = Math.random() * (outerCircle / 80) + (outerCircle / 80);
            planets[i].style = 'fill:url(#gradient_white_grey)';
            planets[i].rotation = Math.random() / 3;
            planets[i].player = 1;
            planets[i].ships = 5;
        }

        sun = new Circle();
        sun.center = screenSize / 2;
        sun.size = outerCircle / 100 * 10;
        sun.style = 'fill:url(#gradient_yellow_red)';
        
        window.setInterval((){update();}, 1000 / 25);
        window.addEventListener('resize', (e){resize();});
    }

    void resize() {                
        Vector2D oldScreenSize = new Vector2D(screenSize.x, screenSize.y);
        screenSize.x = window.innerWidth;
        screenSize.y = window.innerHeight;
        
        Vector2D scale = screenSize / oldScreenSize;
        Vector2D scale2 = screenSize / (grid[0].size * 2);
        
        num maxScale = (screenSize.x > screenSize.y) ? scale2.y : scale2.x;
        
        for(int i=0; i<grid.length; i++) {
            grid[i].center *= scale;
            grid[i].size *= maxScale;
        }
        
        for(int i=0; i<stars.length; i++) {
            stars[i].center *= scale;
            stars[i].size *= maxScale;
        }
        
        for(int i=0; i<planets.length; i++) {
            planets[i].center -= oldScreenSize / 2;
            planets[i].center *= maxScale;
            planets[i].size *= maxScale;
            planets[i].center += screenSize / 2;
        }

        sun.center *= scale;
        sun.size *= maxScale;
    }
    
    void update() {
        for(var i=0; i<planets.length; i++) {
            planets[i].center -= screenSize/2;
            planets[i].center.rotate(planets[i].rotation);
            planets[i].center += screenSize/2;
        }
    }
}

main() {
    new Konquest();
}
