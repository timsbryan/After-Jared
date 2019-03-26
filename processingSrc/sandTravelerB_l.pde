// Sand Traveler 
// Special commission for Sónar 2004, Barcelona
// sand painter implementation of City Traveler + complexification.net

// j.tarbell   May, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 1000;
float t;
int dx, dy;
int num = 200;
int maxnum = 201;
int cnt = 0;
// minimum distance to draw connections
int mind = 256;

City[] cities;

color[] goodcolor = {#3a242b, #3b2426, #352325, #836454, #7d5533, #8b7352, #b1a181, #a4632e, #bb6b33, #b47249, #ca7239, #d29057, #e0b87e, #d9b166, #f5eabe, #fcfadf, #d9d1b0, #fcfadf, #d1d1ca, #a7b1ac, #879a8c, #9186ad, #776a8e,#000000,#000000,#000000,#000000,#000000,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#000000,#000000,#000000,#000000,#000000,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF,#FFFFFF};

void setup() {
  size(1000,1000,P3D);
//  size(dim,dim,P3D);  
  background(255);

  cities = new City[maxnum];
  
  resetAll();
}

void draw() {
  // move cities
  for (int c=0;c<num;c++) {
    cities[c].move();
  }
  // cycle limiter
  if (cnt++>(120*30)) {
    cnt=0;
    resetAll();
  }
}


void mousePressed() {
  resetAll();
}

// METHODS -------------------------------------------------------------------

void resetAll() {
  background(255);
  float vt = 20.0;
  float vvt = 0.2;
  float ot = random(TWO_PI);
  for (int t=0;t<num;t++) {
    float tinc = ot+(1.1-t/num)*2*t*TWO_PI/num;
    float vx = vt*sin(tinc);
    float vy = vt*cos(tinc);
    cities[t] = new City(dim/2+vx*2,dim/2+vy*2,vx,vy,t);
    vvt-=0.00033;
    vt+=vvt;
  }
  
  for (int t=0;t<num;t++) {
    cities[t].findFriend();
  }
}

float citydistance(int a, int b) {
  if (a!=b) {
    // calculate and return distance between cities
    float dx = cities[b].x-cities[a].x;
    float dy = cities[b].y-cities[a].y;
    float d = sqrt(dx*dx+dy*dy);
    return d;
  } else {
    return 0.0;
  }
}


// OBJECTS ------------------------------------------------------------------

class City {

  int friend;
  float x, y;
  float vx, vy;
  int idx;
  color myc = somecolor();
  
  // sand painters
  int numsands = 3;
  SandPainter[] sands = new SandPainter[numsands];

  City(float Dx, float Dy, float Vx, float Vy, int Idx) {
    // position
    x = Dx;
    y = Dy;
    vx = Vx;
    vy = Vy;
    idx = Idx;

    // create sand painters
    for (int n=0;n<numsands;n++) {
      sands[n] = new SandPainter();
    }
  }

  void move() {
    vx+=(cities[friend].x-x)/1000;
    vy+=(cities[friend].y-y)/1000;

    vx*=.936;
    vy*=.936;
    x+=vx;
    y+=vy;

    if (citydistance(idx,friend)<mind) {
      drawSandPainters();
    }
    
  }
  void findFriend() {
    // pick a node to follow just out ahead
    friend = (idx + int(1+random(num/5)))%num;
  }
    
   
  void drawSandPainters() {
    for (int s=0;s<numsands;s++) {
      sands[s].render(x,y,cities[friend].x,cities[friend].y);
    }
  }
}

class SandPainter {

  float p;
  color c;
  float g;

  SandPainter() {

    p = random(1.0);
    c = somecolor();
    g = random(0.01,0.1);
  }
  void render(float x, float y, float ox, float oy) {
    // draw painting sweeps
    stroke(red(c),green(c),blue(c),22);
    point(ox+(x-ox)*sin(p),oy+(y-oy)*sin(p));

    g+=random(-0.050,0.050);
    float maxg = 0.22;
    if (g<-maxg) g=-maxg;
    if (g>maxg) g=maxg;
    p+=random(-0.050,0.050);
    if (p<0) p=0;
    if (p>1.0) p=1.0;

    float w = g/10.0;
    for (int i=0;i<11;i++) {
      float a = 0.1-i/110.0;
      stroke(red(c),green(c),blue(c),256*a);
      point(ox+(x-ox)*sin(p + sin(i*w)),oy+(y-oy)*sin(p + sin(i*w)));
      point(ox+(x-ox)*sin(p - sin(i*w)),oy+(y-oy)*sin(p - sin(i*w)));
    }
  }

  void renderPerp(float x, float y, float ox, float oy) {
    // transform perpendicular
    float mx = (x+ox)/2;
    float my = (y+oy)/2;
    
    float g = 0.42;
    float x1 = mx + (y-my)*g;
    float y1 = my - (x-mx)*g;
    
    float ox1 = mx + (oy-my)*g;
    float oy1 = my - (ox-mx)*g;
  
    // draw painting sweeps
    stroke(red(c),green(c),blue(c),22);
    point(ox1+(x1-ox1)*sin(p),oy1+(y1-oy1)*sin(p));

    g+=random(-0.050,0.050);
    float maxg = 0.22;
    if (g<-maxg) g=-maxg;
    if (g>maxg) g=maxg;
    p+=random(-0.050,0.050);
    if (p<0) p=0;
    if (p>1.0) p=1.0;

    float w = g/10.0;
    for (int i=0;i<11;i++) {
      float a = 0.1-i/110.0;
      stroke(red(c),green(c),blue(c),256*a);
      point(ox1+(x1-ox1)*sin(p + sin(i*w)),oy1+(y1-oy1)*sin(p + sin(i*w)));
      point(ox1+(x1-ox1)*sin(p - sin(i*w)),oy1+(y1-oy1)*sin(p - sin(i*w)));
    }
  }
}


// COLOR ROUTINES -------------------------------------------------------------

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(goodcolor.length))];
}

// j.tarbell   May, 2004
// Albuquerque, New Mexico
// complexification.net
