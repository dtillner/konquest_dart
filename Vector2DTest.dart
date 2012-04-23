#import('unittest/unittest.dart');
#source('Vector2D.dart');


vector2DTests() {
    group('Constructor', () {
        test('Default Values', () {
            Vector2D v = new Vector2D();
            Expect.equals(0, v.x);
            Expect.equals(0, v.y);
        });
    
        test('Int Values', () {
            Vector2D v = new Vector2D(1,2);
            Expect.equals(1, v.x);
            Expect.equals(2, v.y);
        });
        
        test('Double Values', () {
            Vector2D v = new Vector2D(1.23456,2.34567);
            Expect.equals(1.23456, v.x);
            Expect.equals(2.34567, v.y);
        });
        
        test('Negative Values', () {
            Vector2D v = new Vector2D(-1,-2);
            Expect.equals(-1, v.x);
            Expect.equals(-2, v.y);
        });
        
        test('Named Values', () {
            Vector2D v = new Vector2D(y: -1, x: -2);
            Expect.equals(-2, v.x);
            Expect.equals(-1, v.y);
        });
    });
    
    group('Read and Write', () {
        test('Write', () {
            Vector2D v = new Vector2D(0,0);
            v.x = 1;
            v.y = -1;
            Expect.equals(1, v.x);
            Expect.equals(-1, v.y);
        });
        
        test('Overwrite', () {
            Vector2D v = new Vector2D(0,0);
            v.x = 1;
            v.y = -1;
            v.y = v.x;
            
            Expect.equals(1, v.x);
            Expect.equals(1, v.y);
        });        
    });
    
    group('Rotate', () {
        test('rotate 90 degree', () {
            Vector2D v = new Vector2D(0,1);
            v.rotate(90);
            Expect.equals(-1, v.x);
            Expect.equals(0, v.y.toInt());
        });
        
        test('rotate -90 degree', () {
            Vector2D v = new Vector2D(0,1);
            v.rotate(-90);
            Expect.equals(1, v.x);
            Expect.equals(0, v.y.toInt());
        });
        
        test('rotate 450 degree', () {
            Vector2D v = new Vector2D(0,1);
            v.rotate(450);
            Expect.equals(-1, v.x);
            Expect.equals(0, v.y.toInt());
        });
        
        test('rotate -270 degree', () {
            Vector2D v = new Vector2D(0,1);
            v.rotate(-270);
            Expect.equals(-1, v.x);
            Expect.equals(0, v.y.toInt());
        });
        
        test('rotate 360 degree', () {
            Vector2D v = new Vector2D(0,1);
            v.rotate(360);
            Expect.equals(0, v.x.toInt());
            Expect.equals(1, v.y.toInt());
        });
    });
    
    group('Normalize', () {
        test('Test 1', () {
            Vector2D v = new Vector2D(3,4);
            v.normalize();
            Expect.equals(0.6, v.x);
            Expect.equals(0.8, v.y);
        });
    });

    group('Magnitude', () {
        test('Test 1', () {
            Vector2D v = new Vector2D(5,6);
            Expect.equals(Math.sqrt(5*5+6*6), v.magnitude);
        });
      
        test('Test 2', () {
            Vector2D v = new Vector2D(0,0);
            Expect.equals(0, v.magnitude);
        });
      
        test('Test 3', () {
            Vector2D v = new Vector2D(-5,6);
            Expect.equals(Math.sqrt(-5*-5+6*6), v.magnitude);
        });
      
        test('Test 4', () {
            Vector2D v = new Vector2D(5,-6);
            Expect.equals(Math.sqrt(5*5+(-6)*-6), v.magnitude);
        });
      
        test('Test 5', () {
            Vector2D v = new Vector2D(-5,-6);
            Expect.equals(Math.sqrt((-5)*(-5)+(-6)*(-6)), v.magnitude);
        });
    });

    group('Cross', () {
        test('Test 1', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(0,0);
            Expect.equals(0, v1.cross(v2));
        });
      
        test('Test 2', () {
            Vector2D v1 = new Vector2D(2,2);
            Vector2D v2 = new Vector2D(5,4);
            Expect.equals(-2, v1.cross(v2));
        });
      
        test('Test 3', () {
            Vector2D v1 = new Vector2D(2,2);
            Vector2D v2 = new Vector2D(-5,4);
            Expect.equals(18, v1.cross(v2));
        });
      
        test('Test 4', () {
            Vector2D v1 = new Vector2D(-1,2);
            Vector2D v2 = new Vector2D(5,4);
            Expect.equals(-14, v1.cross(v2));
        });
    });

    group('Negate', () {
        test('Test 1', () {
            Vector2D v = new Vector2D(3,4);
            v = -v;
            Expect.equals(-3, v.x);
            Expect.equals(-4, v.y);
        });

        test('Test 2', () {
            Vector2D v = new Vector2D(-3,-4);
            v = -v;
            Expect.equals(3, v.x);
            Expect.equals(4, v.y);
        });
        
        test('Test 3', () {
            Vector2D v = new Vector2D(3,-4);
            v = -v;
            Expect.equals(-3, v.x);
            Expect.equals(4, v.y);
        });
        
        test('Test 4', () {
            Vector2D v = new Vector2D(-3,4);
            v = -v;
            Expect.equals(3, v.x);
            Expect.equals(-4, v.y);
        });
    });
    
    group('Addition', () {
        test('Test 1', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(0,0);
            Vector2D v3 = v1 + v2;
            Expect.equals(0, v3.x);
            Expect.equals(0, v3.y);
        });

        test('Test 2', () {
            Vector2D v1 = new Vector2D(1,2);
            Vector2D v2 = new Vector2D(3,4);
            Vector2D v3 = v1 + v2;
            Expect.equals(4, v3.x);
            Expect.equals(6, v3.y);
        });
        
        test('Test 3', () {
            Vector2D v1 = new Vector2D(-1,2);
            Vector2D v2 = new Vector2D(3,-4);
            Vector2D v3 = v1 + v2;
            Expect.equals(2, v3.x);
            Expect.equals(-2, v3.y);
        });
        
        test('Test 4', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(-3,4);
            Vector2D v3 = v1 + v2;
            Expect.equals(-3, v3.x);
            Expect.equals(4, v3.y);
        });
        
        test('Test 5', () {
            Vector2D v1 = new Vector2D(1,2);
            Vector2D v2 = new Vector2D(0,0);
            Vector2D v3 = v1 + v2;
            Expect.equals(1, v3.x);
            Expect.equals(2, v3.y);
        });
        
        test('Test 6', () {
            Vector2D v1 = new Vector2D(1,2);
            Vector2D v2 = new Vector2D(3,4);
            v1 += v2;
            Expect.equals(4, v1.x);
            Expect.equals(6, v1.y);
            Expect.equals(3, v2.x);
            Expect.equals(4, v2.y);
        });
        
        test('Test 7', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(3,-4);
            v1 += v2;
            Expect.equals(3, v1.x);
            Expect.equals(-4, v1.y);
            Expect.equals(3, v2.x);
            Expect.equals(-4, v2.y);
        });
    });
    
    group('Subtraction', () {
        test('Test 1', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(0,0);
            Vector2D v3 = v1 - v2;
            Expect.equals(0, v3.x);
            Expect.equals(0, v3.y);
        });

        test('Test 2', () {
            Vector2D v1 = new Vector2D(1,2);
            Vector2D v2 = new Vector2D(3,4);
            Vector2D v3 = v1 - v2;
            Expect.equals(-2, v3.x);
            Expect.equals(-2, v3.y);
        });
        
        test('Test 3', () {
            Vector2D v1 = new Vector2D(-1,2);
            Vector2D v2 = new Vector2D(3,-4);
            Vector2D v3 = v1 - v2;
            Expect.equals(-4, v3.x);
            Expect.equals(6, v3.y);
        });
        
        test('Test 4', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(-3,4);
            Vector2D v3 = v1 - v2;
            Expect.equals(3, v3.x);
            Expect.equals(-4, v3.y);
        });
        
        test('Test 5', () {
            Vector2D v1 = new Vector2D(1,2);
            Vector2D v2 = new Vector2D(0,0);
            Vector2D v3 = v1 - v2;
            Expect.equals(1, v3.x);
            Expect.equals(2, v3.y);
        });
        
        test('Test 6', () {
            Vector2D v1 = new Vector2D(1,2);
            Vector2D v2 = new Vector2D(3,4);
            v1 -= v2;
            Expect.equals(-2, v1.x);
            Expect.equals(-2, v1.y);
            Expect.equals(3, v2.x);
            Expect.equals(4, v2.y);
        });
        
        test('Test 7', () {
            Vector2D v1 = new Vector2D(0,0);
            Vector2D v2 = new Vector2D(3,-4);
            v1 -= v2;
            Expect.equals(-3, v1.x);
            Expect.equals(4, v1.y);
            Expect.equals(3, v2.x);
            Expect.equals(-4, v2.y);
        });
    });
}

void main() {
    vector2DTests();
}
