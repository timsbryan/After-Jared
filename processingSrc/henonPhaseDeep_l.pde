// Henon Phase Deep
// a mathematical strange attractor
// j.tarbell   May, 2004
// Albuquerque, New Mexico
// complexification.net

// based on code from mathworld.wolfram.com/HenonMap.html

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

// number of points to draw in each iteration
int dim = 1000;
float offx, offy;
float gs = 1.4;      // scale the visualization to match the applet size
float ga = PI;       // slice constant (0...TWO_PI)
float[] aList;
int num = 0;
int maxnum = 4000;

boolean drawing = true;

// palette series attributes
int gifID = 0;
int gifNum = 9;
String[] palette = new String[gifNum];

// OBJECTS
TravelerHenon[] travelers = new TravelerHenon[maxnum];

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


// MAIN METHODS
void setup() {
  // set window display properties
  size(1000,1000,P3D);
//  size(dim,dim,P3D);
  background(255);

      
  // some palettes to choose from
  palette[0] = "garnerA1";
  palette[1] = "garnerA2";
  palette[2] = "garnerA3";
  palette[3] = "garnerB1";
  palette[4] = "garnerB2";
  palette[5] = "garnerB3";
  palette[6] = "garnerC1";
  palette[7] = "garnerC2";
  palette[8] = "garnerC3";

  // gen slice
  renderSlice();

  // make some travelers
  for (int i=0;i<maxnum;i++) {
    travelers[i] = new TravelerHenon();
    num++;
  }
  
}

void draw() {
    // accelerator
    for (int k=0;k<20;k++) {
      // draw all travelers
      for (int i=0;i<num;i++) {
        if (drawing) travelers[i].draw();
      }
    }
  
    // random mutations
    for (int k=0;k<2;k++) {
      travelers[int(random(num))].rebirth();
    }
}


void mousePressed() {
  // stop drawing, clear screen, and reset
  drawing=false;
  background(255);
  renderSlice();
}



// METHODS ----------------------------------------------------------------------------

void renderSlice() {
  // pick random palette
  gifID = int(random(gifNum));
  // convert GIF palette into usable palette
  takecolor(palette[gifID]+".gif");
  
  // set random slice constant 0..TWO_PI
  ga = random(0.2,TWO_PI-0.2);
  // avoid noid space
  if ((ga>2.05) && (ga<2.6)) {
    ga = random(1.2,1.7);
  }
  
  // scale
  gs = .73;
  
  // random offset
  offx = random(1.0);
  offy = -0.1;
  
  // begin drawing again
  drawing = true;
}


// OBJECTS ----------------------------------------------------------------------------

class TravelerHenon {
  float x, y;
  int outofbounds;

  color myc;

  TravelerHenon() {
    rebirth();
  }

  void draw() {
    // move through time
    float t = x * cos(ga) - (y - x*x) * sin(ga);
    y = x * sin(ga) + (y - x*x) * cos(ga);
    x = t;
    float fuzx = random(-0.004,0.004);
    float fuzy = random(-0.004,0.004);
    
    float px = fuzx + (x/gs+offx)*dim;
    float py = fuzy + (y/gs+offy)*dim;
    
    if ((px>0) && (px<dim) && (py>0) && (py<dim)) {
      // render  
      stroke(red(myc),green(myc),blue(myc),56);
      point(px,py);
    }
  }

  void rebirth() {
    x = random(0,1.0);
    y = random(0,1.0);
    outofbounds = 0;
    float d = sqrt(x*x+y*y);
    int idx = int(numpal*d)%numpal;
    if (idx>=numpal) {
      idx = numpal-1;
    } else if (idx<0) {
      idx = 0;
    }
    myc = goodcolor[idx];
  }

}


// COLOR METHODS ------------------------------------------------------------------

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(numpal))];
}

void takecolor(String fn) {
  // clear background to begin
  background(255);
  
  // load color source
  PImage b;
  b = loadImage(fn);
  image(b,0,0);
  
  // initialize palette length
  numpal=0;

  // find all distinct colors
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
        // add color to palette
        if (numpal<maxpal) {
          goodcolor[numpal] = c;
          numpal++;
        } else {
          break;
        }
      }
    }
  }

  background(255);
}

