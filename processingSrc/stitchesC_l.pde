// Stitches (variation c)
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 10;            // grid dimensions (square window)
int distc = 80;           // pixels between grid points
int num = 22;  
int maxage = 12;         // thread length

Bit[] bit = new Bit[num];              // 2D array to hold bits
boolean drawing = true;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


void setup() {
  // set up drawing area
  size(800,800,P3D);
  takecolor("longcolor.gif");
  background(255);
  framerate(30);

  for (int n=0;n<num;n++) {
    bit[n] = new Bit(n);
    bit[n].awaken();  
  }      
  
}

void draw() {
  if (drawing) {
    for (int k=0;k<10;k++) {
    for (int n=0;n<num;n++) {
      bit[n].draw();
    }      }
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
  
    myc = somecolor();
  
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
      float b = (maxage-age);
      for (int k=int(-b);k<int(b);k++) {
        float a = 0.2-0.19*abs(k/b);
        stroke(red(myc),green(myc),blue(myc),a*256);
        point(dx,dy+k);
        point(dx+k,dy);
      }
      stroke(0,44);
      point(dx-1,dy-1);
      
      x+=int(Math.round(random(-100,101)/100));
      y+=int(Math.round(random(-100,101)/100));
      
      age++;

      if ((x<0) || (x>=dim) || (age>maxage)) {
        x = ox;
        y = oy;
        age=0;
      }
      if ((y<0) || (y>=dim) || (age>maxage)) {
        y = oy;
        x = ox;
        age=0;
      }
      if (random(10000)>2400) {
       state+=int(random(distc));
       if (state>(distc*distc)) {
         state = 1;
       }
      }
    }
 }

                 
  int getState() {
    return state;
  }

  int getX() {
    return x*distc + state%distc;
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
  return goodcolor[int(random(numpal))];
}

void takecolor(String fn) {
  PImage b;
  b = loadImage(fn); 
  image(b,0,0);
  
  for (int x=0;x<b.width;x++){
    for (int y=0;y<b.height;y++) {
      color c = get(x,y);
      boolean exists = false;
      for (int n=0;n<numpal;n++) {
        if (c==goodcolor[n]) {
          exists = true;
          break;
        }
      }
      if (!exists) {
        // add color to pal
        if (numpal<maxpal) {
          goodcolor[numpal] = c;
          numpal++;
        }
      }
    }
  }
}



// Stitches, variation c
// j.tarbell   January, 2004
