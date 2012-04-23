
class Vector2D {
    num x, y;

    Vector2D([num this.x = 0, num this.y = 0]);
    
    void rotate(num deg) {
        num rad = deg * Math.PI/180;
        
        num tmp = x*Math.cos(rad) - y*Math.sin(rad);
        y = x*Math.sin(rad) + y*Math.cos(rad);
        x = tmp;
    } 
   
    void normalize() {
        num length = magnitude;
        x /= length;
        y /= length;
    }
   
    num get magnitude() {
        return Math.sqrt(x*x+y*y);
    }
   
    num cross(Vector2D v) {
        return x*v.y - y*v.x;
    }
   
    Vector2D negate() {
        return new Vector2D(-x, -y);
    }
   
    Vector2D operator+(d) {
        return (d is num) ? new Vector2D(x + d, y + d) : new Vector2D(x + d.x, y + d.y);
    }

    Vector2D operator-(d) {
        return (d is num) ? new Vector2D(x - d, y - d) : new Vector2D(x - d.x, y - d.y);
    }

    Vector2D operator*(d) {
        return (d is num) ? new Vector2D(x * d, y * d) : new Vector2D(x * d.x, y * d.y);
    }

    Vector2D operator/(d) {       
        return (d is num) ? new Vector2D(x / d, y / d) : new Vector2D(x / d.x, y / d.y);
    }

    String toString() {
        return '(${x.toStringAsFixed(3)}, ${y.toStringAsFixed(3)})';
    }
}
