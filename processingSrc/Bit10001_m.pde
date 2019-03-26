// Bit 10001
// j.tarbell   January, 2004
// Processing 0085 Beta syntax update April, 2005
// Albuquerque, New Mexico
// complexification.net

// based on original code by Keith Peters
// bit-101.com

int zcenter;
float angleX;
float angleY;
float cosangleX;
float sinangleX;
float cosangleY;
float sinangleY;

boolean expose;

int maxnum = 10001;
int fl = 500;
int dim = 600;

BitBit[] bits;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


// MAIN -----------------------------------------------------------

void setup(){
  size(600, 600, P3D);
//  size(dim,dim,P3D);
  background(255);
  takecolor("longcolor.gif");
  expose = false;
  
  bits = new BitBit[maxnum];
  
  // start
  angleX = 0;
  angleY = 0;
  zcenter = 2500;
  for(int i=0; i<maxnum; i++){
    float x = random(-200, 200);
    float y = random(-400, 400);
    float z = random(100, 400);
    float vx = random(1,3);
    float vy = 0;
    float vz = 0;
    bits[i] = new BitBit(x,y,z,vx,vy,vz);
  }
}

void draw(){
  if (!expose) {
    background(255);
  }
  
  angleX += ((mouseY-dim/2)*.005-angleX)*.05;
  angleY += ((mouseX-dim/2)*.005-angleY)*.05;
  
  cosangleX = cos(angleX);
  sinangleX = sin(angleX);
  cosangleY = cos(angleY);
  sinangleY = sin(angleY);
  for(int i=0; i<maxnum; i++){
    // move bitbit
    bits[i].move();
  }
}

void keyPressed() {
  // toggle exposure mode
  expose = !expose;
}

// OBJECTS -----------------------------------------------------------

class BitBit {
  // position
  float x;
  float y;
  float z;
  float xp;
  float yp;
  float vx;
  float vy;
  float vz;
  color myc;


  BitBit(float X, float Y, float Z, float Vx, float Vy, float Vz) {
    // constructor
    x = X;
    y = Y;
    z = Z;
    vx = Vx;
    vy = Vy;
    vz = Vz;
    myc = 0;
  }
  void move() {
    float distSQ = x*x+z*z;
    float dist = sqrt(distSQ);
    float force = (y+200)*5/distSQ;
    vx -= force*x/dist;
    vz -= force*z/dist;
    x += vx;
    z += vz;
    float ya = cosangleX*y-sinangleX*z;
    float za = cosangleX*z+sinangleX*y;
    float xb = cosangleY*x-sinangleY*za;
    float zb = cosangleY*za+sinangleX*x;
    float sc = fl/(fl+zb+zcenter);
    float xplast = xb * sc + dim/2;
    float yplast = ya * sc + dim/2;
    if (myc==0) {
      myc=somecolor();
    } else {
      if(-zb-zcenter < fl){
        if ((xp>-10) && (xp<dim+10) && (yp>-10) && (yp<dim+10)) {
          if (expose) {
            stroke(red(myc),green(myc),blue(myc),24);
            line(xp,yp,xplast,yplast);
          } else {
            stroke(myc);
            line(xp,yp,xplast,yplast);
          }
        }
      }
    }
    xp = xplast;
    yp = yplast;
  }
}



// COLOR METHODS -------------------------------------------------------

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


// translucent point
void tpoint(int x1, int y1, color myc, float a) {
  int r, g, b;
  color c;

  c = get(x1, y1);

  r = int(red(c) + (red(myc) - red(c)) * a);
  g = int(green(c) +(green(myc) - green(c)) * a);
  b = int(blue(c) + (blue(myc) - blue(c)) * a);
  color nc = color(r, g, b);
  stroke(nc);
  point(x1,y1);
}


void tline(int x1, int y1, int x2, int y2, color lnc, float lna) {
  int xinc1;
  int xinc2;
  int yinc1;
  int yinc2;
  
  int den;
  int num;
  int numadd;
  int numpixels;
  int deltax = abs(x2 - x1);        // The difference between the x's
  int deltay = abs(y2 - y1);        // The difference between the y's
  int x = x1;                       // Start x off at the first pixel
  int y = y1;                       // Start y off at the first pixel

  if (x2 >= x1) {
    xinc1 = 1;
    xinc2 = 1;
  } else {
    xinc1 = -1;
    xinc2 = -1;
  }

  if (y2 >= y1) {
    yinc1 = 1;
    yinc2 = 1;
  } else                          // The y-values are decreasing
  {
    yinc1 = -1;
    yinc2 = -1;
  }

  if (deltax >= deltay)         // There is at least one x-value for every y-value
  {
    xinc1 = 0;                  // Don't change the x when numerator >= denominator
    yinc2 = 0;                  // Don't change the y for every iteration
    den = deltax;
    num = deltax / 2;
    numadd = deltay;
    numpixels = deltax;         // There are more x-values than y-values
  }
  else                          // There is at least one y-value for every x-value
  {
    xinc2 = 0;                  // Don't change the x for every iteration
    yinc1 = 0;                  // Don't change the y when numerator >= denominator
    den = deltay;
    num = deltay / 2;
    numadd = deltax;
    numpixels = deltay;         // There are more y-values than x-values
  }

  for (int i = 0; i <= numpixels; i++)
  {
    tpoint(x,y,lnc,lna);
    
    num += numadd;              // Increase the numerator by the top of the fraction
    if (num >= den)             // Check if numerator >= denominator
    {
      num -= den;               // Calculate the new numerator value
      x += xinc1;               // Change the x as appropriate
      y += yinc1;               // Change the y as appropriate
    }
    x += xinc2;                 // Change the x as appropriate
    y += yinc2;                 // Change the y as appropriate
  }
}
