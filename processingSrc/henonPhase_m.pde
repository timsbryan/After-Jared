// Henon Phase Diagram
// a mathematical strange attractor
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// based on code from mathworld.wolfram.com/HenonMap.html

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

// number of points to draw in each iteration
int dim = 500;
float gs = 2.0;      // scale the visualization to match the applet size  
float ga = 3.0;
int gc = 0;
int cnt;
int fadebg;
int num = 0;
int maxnum = 500;
int numpoints = 3000;

TravelerHenon[] travelers = new TravelerHenon[maxnum];

// frame counter for animation
float time;

color[] goodcolor = {#000000, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };
color somecolor() {
  // pick some random good color
  return goodcolor[int(random(goodcolor.length))];
}


void newHenon() {
  //background(255);
  fadebg = 255;  
  ga = random(TWO_PI);
  gc = int(random(goodcolor.length));
  for (int i=0;i<num;i++) {
    travelers[i].rebirth();
  }

}

void setup()
{
  size(500,500,P3D);
//  size(dim,dim,P3D);
  background(255);
  noStroke();
  
  // make some travelers
  for (int i=0;i<maxnum;i++) {
    float tx = random(0.0,1.0);
    travelers[i] = new TravelerHenon(tx,0.0);
    num++;
  } 
}

void draw()
{
  if (fadebg>0) {
    cnt++;
    if ((cnt%5)==0) {
      fill(255,255,255,50);
      rectMode(CORNERS);
      rect(0,0,dim-1,dim-1);
      fadebg -= 50;
    }
  }

  for (int i=0;i<num;i++) {
    travelers[i].draw();
  }
}

void keyPressed()
{
  if( key == 's' || key == 'S' ) {
  // do somethin
  
  }else{
    background(0);
  }
}

void mouseClicked()
{
  // reset
  newHenon();
}

class TravelerHenon {
  float ox, oy;
  float x, y;
  
  color myc;
  
  TravelerHenon(float Ox, float Oy) {
    // constructor
    ox = Ox;
    oy = Oy;
    // set travel position
    x = Ox;
    y = Oy;

    // set some good color    
    myc = goodcolor[int(gc+floor(goodcolor.length*ox))%goodcolor.length];
  }
  
  void draw() {
    // move through time
    float t = x * cos(ga) - (y - x*x) * sin(ga);
    y = x * sin(ga) + (y - x*x) * cos(ga);
    x = t;
    // render
    stroke(red(myc),green(myc),blue(myc),32);
    point((x/gs + .5)*dim,(y/gs + .5)*dim);
  }  
  
      
  void render(int maxpoints) {
    for (int i=0;i<maxpoints;i++) {
      draw();
    }
  }
  
  void rebirth() {
    x = ox;
    y = oy;
    myc = goodcolor[int(gc+floor(goodcolor.length*ox))%goodcolor.length];
  }    
 
}    
  
