#import('dart:dom');
#source('Vector2D.dart');

class Circle {
    final String svgNS = 'http://www.w3.org/2000/svg';
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
    num rotation;
}

class Konquest {
    Vector2D screenSize;
    Circle sun;
    List<Planet> planets;
    List<Circle> grid;
    
    Konquest() {
        screenSize = new Vector2D(window.innerWidth, window.innerHeight);
        
        num outerCircle = (screenSize.x > screenSize.y) ? screenSize.y / 2 : screenSize.x / 2;
        num innerCircle = outerCircle / 100 * 20;   

        grid = new List<Circle>(4);
        for(int i=0; i<grid.length; i++) {
            grid[i] = new Circle();
            grid[i].center = screenSize/2;
            grid[i].size = outerCircle / 100 * (25 * (4-i));
            grid[i].stroke = 'green';
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
