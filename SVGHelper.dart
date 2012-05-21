class Gradient implements Hashable {
    SVGElement _node;
    Map<String, String> _attributes;
    List<String> _offsets;
    List<String> _colors;
    List<String> _opacities;
    
    Gradient(String name) {
        _attributes = new Map<String, String>();
        _offsets = new List<String>();
        _colors = new List<String>();
        _opacities = new List<String>();
        
        _attributes['id'] = name;
    }
    
    String get name() => _attributes['id'];
    set name(String name) {
        _attributes['id'] = name;
    }
    
    SVGElement get node() {
        _node = new SVGElement.tag('radialGradient');
        
        _attributes.forEach((k,v) => _node.attributes[k] = v);
        
        for(int i=0; i<_colors.length; i++) {
            SVGElement stop = new SVGElement.tag('stop');
            stop.attributes['offset'] = _offsets[i];
            stop.attributes['style'] = 'stop-color:${_colors[i]}; stop-opacity:${_opacities[i]}';
            _node.nodes.add(stop);
        }
        
        return _node;
    }
    
    void setOuterCircle(Vector2D c, String r) {
        _attributes['cx'] = c.x.toString();
        _attributes['cy'] = c.y.toString();
        _attributes['r'] = r;
    }
    
    void setFocalPoint(Vector2D f) {
        _attributes['fx'] = f.x.toString();
        _attributes['fy'] = f.y.toString();
    }
    
    void addColor(String offset, String color, String opacity) {
        _offsets.add(offset);
        _colors.add(color);
        _opacities.add('opacity');
    }
    
    int hashCode() => name.hashCode();
}

class TextField {
    SVGElement _node;
    Vector2D _position;
    List<String> _lines;
    List<SVGElement> _lineNodes;
    String _color;
    String _font;
    num _size;

    TextField(num lines) {
        _node = new SVGElement.tag('text');
        document.documentElement.nodes.add(_node);
        
        _lines = new List<String>(lines);
        _lineNodes = new List<SVGElement>(lines);
        
        for(int i=0; i<_lineNodes.length; i++) {
            _lineNodes[i] = new SVGElement.tag('tspan');
            _node.nodes.add(_lineNodes[i]);
        }
    }
    
    Vector2D get position() => _position;
    set position(Vector2D position) {
        _position = position;

        for(int i=0; i<_lineNodes.length; i++) {
            _lineNodes[i].attributes['x'] = _position.x.toString();
        }
        _node.attributes['y'] = _position.y.toString();
    }
    
    String getLine(num line) => _lines[line];
    setLine(num line, String text) {
        _lines[line] = text;
        //_node.nodes[line].textContent = text;
        _node.nodes[line].text = text;
    }
    
    String get color() => _color;
    set color(String color) {
        _color = color;
        _node.attributes['style'] = 'fill:$_color; font-family:$_font; font-size:$_size;';
    }
    
    String get font() => _font;
    set font(String font) {
        _font = font;
        _node.attributes['style'] = 'fill:$_color; font-family:$_font; font-size:$_size;';
    }
    
    num get size() => _size;
    set size(num size) {
        _size = size;
        _node.attributes['style'] = 'fill:$_color; font-family:$_font; font-size:$_size;';
        
        _lineNodes[0].attributes['dy'] = 0;
        for(int i=1; i<_lineNodes.length; i++) {
            _lineNodes[i].attributes['dy'] = size;
        }
    }
}

class Circle {
    SVGElement _node;
    Map _values;
    
    //FIXIT: multiple instances of static variable (dart bug?) 
    static Set<Gradient> _gradients;

    Circle() {
        _node = new SVGElement.tag('circle');
        _values = new Map();
        _gradients = new Set<Gradient>();
        document.documentElement.nodes.add(_node);
    }
    
    num get size() => _values['size'];
    set size(num size) {
        _node.attributes['r'] = size.toString();
        _values['size'] = size;
    }
    
    Vector2D get center() => _values['center'];
    set center(Vector2D center) {
        _node.attributes['cx'] = center.x.toString();
        _node.attributes['cy'] = center.y.toString();
        _values['center'] = center;        
    }
    
    String get stroke() => _values['stroke'];
    set stroke(String stroke) {
        _node.attributes['stroke'] = stroke;
        _values['stroke'] = stroke;
    }
    
    String get style() => _values['style'];
    set style(String style) {
        _node.attributes['style'] = style;
        _values['style'] = style;
    }
    
    static addGradient(String name, String color1, String color2) {
        Gradient g = new Gradient(name);
        g.addColor('0%', color1, '1');
        g.addColor('100%', color2, '1');

        if(!_gradients.contains(g)) {
            _gradients.add(g);
            document.queryAll('defs')[0].nodes.add(g.node);
        }
    }
}
