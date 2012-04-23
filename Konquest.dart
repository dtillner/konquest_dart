#import('dart:dom');
#source('Vector2D.dart');


class Konquest {
    final String svgNS = 'http://www.w3.org/2000/svg';

    Vector2D screenSize;    

    num outerCircle;
    num innerCircle;

    SVGElement sunNode;
    num sunSize;
    Vector2D sunCoords;

    List<SVGElement> gridNode;
    List<num> gridSize;
    List<Vector2D> gridCoords;

    List<SVGElement> planetNode;
    List<num> planetSize;
    List<Vector2D> planetCoords;
    List<num> planetRotation;

    Konquest() {
        screenSize = new Vector2D();
        screenSize.x = window.innerWidth;
        screenSize.y = window.innerHeight;
        
        outerCircle = (screenSize.x > screenSize.y) ? screenSize.y / 2 : screenSize.x / 2;
        innerCircle = outerCircle / 100 * 20;
        
        initGrid();
        initSun();
        initPlanets();
        
        window.setInterval((){update();}, 1000 / 25);
        window.addEventListener('resize', (e){resize();});
    }
    
    void initSun() {
        sunCoords = screenSize / 2;
        sunSize = outerCircle / 100 * 10;

        sunNode = document.createElementNS(svgNS, 'circle');
        sunNode.setAttribute('cx', sunCoords.x.toString());
        sunNode.setAttribute('cy', sunCoords.y.toString());
        sunNode.setAttribute('r', sunSize.toString());
        sunNode.setAttribute('style', 'fill:url(#gradient_yellow_red)');
        document.documentElement.appendChild(sunNode);
    }
    
    void initGrid() {        
        gridNode = new List<SVGElement>(4);
        gridSize = new List<num>(4);
        gridCoords = new List<Vector2D>(4);
        
        for(int i=0; i<gridNode.length; i++) {
            gridCoords[i] = screenSize / 2;
            gridSize[i] = outerCircle / 100 * (25 * (4-i));
            
            gridNode[i] = document.createElementNS(svgNS, 'circle');
            gridNode[i].setAttribute('cx', gridCoords[i].x.toString());
            gridNode[i].setAttribute('cy', gridCoords[i].y.toString());
            gridNode[i].setAttribute('r', gridSize[i].toString());
            gridNode[i].setAttribute('stroke', 'green');
            document.documentElement.appendChild(gridNode[i]);
        }
    }
    
    void initPlanets() {
        planetNode = new List<SVGElement>(10);
        planetSize = new List<num>(10);
        planetCoords = new List<Vector2D>(10);
        planetRotation = new List<num>(10);
    
        for(int i=0; i<planetNode.length; i++) {
            num tmpX = Math.random() * (outerCircle - innerCircle) + innerCircle;
            num tmpRot = Math.random()*360;
            
            planetCoords[i] = new Vector2D(tmpX, 0);
            planetCoords[i].rotate(tmpRot);
            planetCoords[i] += screenSize / 2;
            
            planetSize[i] = Math.random() * (outerCircle / 80) + (outerCircle / 80);
            planetRotation[i] = Math.random() / 3;

            planetNode[i] = document.createElementNS(svgNS, 'circle');
            planetNode[i].setAttribute('cx', planetCoords[i].x.toString());
            planetNode[i].setAttribute('cy', planetCoords[i].y.toString());
            planetNode[i].setAttribute('r', planetSize[i].toString());
            planetNode[i].setAttribute('style', 'fill:url(#gradient_white_grey)');
            document.documentElement.appendChild(planetNode[i]);
        }
    }
    
    void resize() {    
        Vector2D oldScreenSize = new Vector2D(screenSize.x, screenSize.y);
        screenSize.x = window.innerWidth;
        screenSize.y = window.innerHeight;
        
        Vector2D scale = new Vector2D(screenSize.x, screenSize.y);
        scale /= oldScreenSize;
        num maxScale = (window.innerWidth > window.innerHeight) ? scale.y : scale.x;
        
        for(int i=0; i<gridNode.length; i++) {
            gridCoords[i] *= scale;
            gridSize[i] *= maxScale;

            gridNode[i].setAttribute('cx', gridCoords[i].x.toString());
            gridNode[i].setAttribute('cy', gridCoords[i].y.toString());
            gridNode[i].setAttribute('r', gridSize[i].toString());
        }
        
        sunCoords *= scale;
        sunSize *= maxScale;

        sunNode.setAttribute('cx', sunCoords.x.toString());
        sunNode.setAttribute('cy', sunCoords.y.toString());
        sunNode.setAttribute('r', sunSize.toString());
        
        for(int i=0; i<planetNode.length; i++) {
            planetCoords[i] -= oldScreenSize / 2;
            planetCoords[i] *= maxScale;
            planetSize[i] *= maxScale;
            planetCoords[i] += screenSize / 2;

            planetNode[i].setAttribute('cx', planetCoords[i].x.toString());
            planetNode[i].setAttribute('cy', planetCoords[i].y.toString());
            planetNode[i].setAttribute('r', planetSize[i].toString());
        }
    }
    
    void update() {
        for(var i=0; i<planetNode.length; i++) {
            planetCoords[i] -= screenSize/2;
            planetCoords[i].rotate(planetRotation[i]);
            planetCoords[i] += screenSize/2;

            planetNode[i].setAttribute('cx', planetCoords[i].x.toString());
            planetNode[i].setAttribute('cy', planetCoords[i].y.toString());
        }
    }
}

main() {
    new Konquest();
}
