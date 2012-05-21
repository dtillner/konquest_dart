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
        
        addGradient('Player${player}PlanetGradient', playerColors[_player], 'black');        
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
        
        num orbitRange = (Konquest.outerCircle - Konquest.innerCircle) / (numOfPlanets);
        
        for(int i=0; i<numOfPlanets; i++) {
            planets[i] = new Planet();
            
            planets[i].type = (Math.random()*10).truncate() % 4;
            planets[i].size = orbitRange * (0.2 + planets[i].type * 0.05);
            planets[i].textSize = 18;

            planets[i].center = new Vector2D(orbitRange*i + Konquest.innerCircle + orbitRange/2, 0);
            planets[i].center.rotate(Math.random()*360);
            planets[i].center += Konquest.screenSize / 2;
            
            planets[i].rotation = (Math.random() - 0.5) / 5;
            
            planets[i].player = 0;
            planets[i].ships = (Math.random()*10).round();
        }
        
        num p1 = (Math.random() * 10).truncate() % 5;
        num p2 = ((Math.random() * 10).truncate() % 5) + 5;     
                
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

class Konquest {
    static Vector2D screenSize;
    static num outerCircle;
    static num innerCircle;

    List<Circle> grid;
    List<Circle> stars;
    Circle sun;
    List<Planet> planets;
    
    Konquest() {
        screenSize = new Vector2D(window.innerWidth, window.innerHeight);
        
        outerCircle = (screenSize.x > screenSize.y) ? screenSize.y / 2 : screenSize.x / 2;
        innerCircle = outerCircle / 100 * 20;   
        
        stars = new List<Circle>(50);
        for(int i=0; i<stars.length; i++) {
            stars[i] = new Circle();
            stars[i].center = new Vector2D(Math.random() * screenSize.x, Math.random() * screenSize.y);
            stars[i].size = outerCircle / 250;
            stars[i].style = 'fill:white';
        }

        grid = new List<Circle>(6);
        for(int i=0; i<grid.length; i++) {
            grid[i] = new Circle();
            grid[i].center = screenSize/2;
            grid[i].size = ((outerCircle - innerCircle) / 5) * i + innerCircle; 
            grid[i].stroke = 'green';
            grid[i].style = 'fill-opacity:0.0';
        }
        
        sun = new Circle();
        sun.center = screenSize / 2;
        sun.size = outerCircle / 100 * 10;
        sun.addGradient('SunGradient', 'rgb(255,255,0)', 'rgb(255,0,0)');
        sun.style = 'fill:url(#SunGradient)';

        planets = Planet.Factory(10);
        
        window.setInterval((){update();}, 5000);
        window.setInterval((){render();}, 1000 / 25);
        window.on.resize.add((e){resize();});
    }

    void update() {
        for(int i=0; i<planets.length; i++) {
            if(planets[i].player > 0) {
                planets[i].ships++;
            }
        }
    }

    void render() {
        for(var i=0; i<planets.length; i++) {
            planets[i].center -= screenSize/2;
            planets[i].center.rotate(planets[i].rotation);
            planets[i].center += screenSize/2;
        }
    }

    void resize() {                
        Vector2D oldScreenSize = new Vector2D(screenSize.x, screenSize.y);
        screenSize.x = window.innerWidth;
        screenSize.y = window.innerHeight;
        
        Vector2D scale = screenSize / oldScreenSize;
        Vector2D scale2 = screenSize / (grid[grid.length-1].size * 2);
        
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
            planets[i].textSize *= maxScale;
            planets[i].center += screenSize / 2;
        }
    }
}

main() {
    new Konquest();
}
