// Stitches, variation A
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 25;            // grid dimensions (square window)
int distc = 20;           // distance between grid points
int num = 128;           // number of stitch heads
int maxage = 100;        // length of thread

Bit[] bit = new Bit[num];            
boolean drawing = true;

color[] goodcolor = {#000000, #000000, #000000, #000000, #000000, #000000, #000000, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };



void setup() {
  // set up drawing area
  size(500,500,P3D);
  background(255);

  for (int n=0;n<num;n++) {
    bit[n] = new Bit(n);
    bit[n].awaken();  
  }      
  
}

void draw() {
  if (drawing) {
    for (int n=0;n<num;n++) {
      bit[n].draw();
    }      
  }
}

void mousePressed() {
  if (drawing) {
    drawing=false;
  } else {
    drawing=true;
  }
}


class Bit {

  int id;
  int x, y;
  int ox, oy;
  int state;
  int age;
  color myc;
  
  Bit (int ID) {
    id = ID;
    x = int(random(dim));
    y = int(random(dim));
    ox = x;
    oy = y;
  
    int i = int(floor(goodcolor.length*y/dim));
    myc = goodcolor[i];
  
    state = 0;                   
  }
  
  void awaken() {
    state=1;
  }

     
  void draw() {
    if (state>0) {
      int dx = getX();
      int dy = getY();
      stroke(red(myc),green(myc),blue(myc),100);
      point(dx,dy);
      
      // draw smear
      float b = distc/2;
      for (int k=int(-b);k<int(b);k++) {
        float a = 0.2 - 0.19*abs(k/b);
        stroke(red(myc),green(myc),blue(myc),a*256);
        point(dx,dy+k);
        point(dx+k,dy);
      }
      stroke(0,44);
      point(dx-1,dy-1);
      stroke(255,44);
      point(dx+11,dy-1);


      
      x+=int(floor(random(-100,199)/100));
      y+=int(floor(random(-100,199)/100));
      
      age++;

      if ((x<0) || (x>=dim) || (age>maxage)) {
        x = ox;
        age=0;
      }
      if ((y<0) || (y>=dim) || (age>maxage)) {
        y = oy;
        age=0;
      }
      if (random(10000)>9600) {
       state+=int(random(4));
      }
    }
 }

                 
  int getState() {
    return state;
  }

  int getX() {
    return int(x*distc + state%distc);
  }
  int getY() {
    return int(y*distc + state/distc);
  }
  
  void setState(int s) {
    state = s;
  }
  
                
}



color somecolor() {
  // pick some random good color
  return goodcolor[int(random(goodcolor.length))];
}

