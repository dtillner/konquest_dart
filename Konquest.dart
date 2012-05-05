#import('dart:dom');
#import('lib/Toolbox.dart');
#source('SVGHelper.dart');

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
    Circle sun;
    List<Planet> planets;
    
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
        
        sun = new Circle();
        sun.center = screenSize / 2;
        sun.size = outerCircle / 100 * 10;
        sun.addGradient('SunGradient', 'rgb(255,255,0)', 'rgb(255,0,0)');
        sun.style = 'fill:url(#SunGradient)';
        
        planets = new List<Planet>(10);
        for(int i=0; i<planets.length; i++) {
            num tmpX = Math.random() * (outerCircle - innerCircle) + innerCircle;
            num tmpRot = Math.random()*360;
        
            planets[i] = new Planet();
            planets[i].center = new Vector2D(tmpX, 0);
            planets[i].center.rotate(tmpRot);
            planets[i].center += screenSize / 2;
            planets[i].size = Math.random() * (outerCircle / 80) + (outerCircle / 80);
            planets[i].addGradient('WhitePlanetGradient', 'rgb(255,255,255)', 'rgb(128,128,128)');
            planets[i].style = 'fill:url(#WhitePlanetGradient)';
            planets[i].rotation = Math.random() / 3;
            planets[i].player = 1;
            planets[i].ships = 5;
        }
        
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
        
        sun.center *= scale;
        sun.size *= maxScale;
        
        for(int i=0; i<planets.length; i++) {
            planets[i].center -= oldScreenSize / 2;
            planets[i].center *= maxScale;
            planets[i].size *= maxScale;
            planets[i].center += screenSize / 2;
        }
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
