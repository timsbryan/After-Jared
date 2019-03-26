// City Traveler, variation B
// j.tarbell   December, 2003
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005


int a, b;
float t;
int num = 22;
int maxnum = num+1;
int numtravelers = 2000;
int dim = 500;
int mind = 128;

City[] cities;
color[] goodcolor = {#000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };

void setup() {
  size(500,500,P3D);
  background(255);

  cities = new City[maxnum];

  float tinc = TWO_PI/num;
  for (int t=0;t<num;t++) {
    float vx = (1+random(11))*sin(tinc*t);
    float vy = (1+random(11))*cos(tinc*t);
    cities[t] = new City(int(dim/2),int(dim/2),vx,vy,t);
    cities[t].draw();
  }
}

void draw() {
  for (int n=0;n<numtravelers;n++) {
    // pick random city A
    a = int(floor(random(num)));
    b = int(floor(random(num)));
    int trys = 0;
    while ((a!=b) && (citydistance(a,b)>mind) && (trys<100)) {
      b = int(floor(random(num)));
      trys++;
    }

    if (trys<100) {
      // pick random distance between city
      t = random(PI);
      float dx = sin(t)*(cities[b].x-cities[a].x)+cities[a].x;
      float dy = sin(t)*(cities[b].y-cities[a].y)+cities[a].y;

      if (random(1000)>990) {
        // noise
        dx += random(-1.5,1.5);
        dy += random(-1.5,1.5);
      }
      stroke(red(cities[b].myc),green(cities[b].myc),blue(cities[b].myc),56);
      point(dx,dy);
      stroke(red(cities[a].myc),green(cities[a].myc),blue(cities[a].myc),56);
      point(dx,dy);
    }
  }

  // move cities
  for (int c=0;c<num;c++) {
    cities[c].move();
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


// OBJECTS -------------------------------------------------------------
class City {

  int friend;
  float x,y;
  float vx, vy;
  int population=5;
  int idx;
  color myc = somecolor();

  City(float Dx, float Dy, float Vx, float Vy, int Idx) {
    // position
    x = Dx;
    y = Dy;
    vx = Vx;
    vy = Vy;
    idx = Idx;

    friend = int(random(num));
  }

  void draw() {
    stroke(0,187);
    point(x,y);
  }
  void move() {
    vx+=(cities[friend].x-x)/2500;
    vy+=(cities[friend].y-y)/2500;

    vx*=.973;
    vy*=.973;
    x+=vx;
    y+=vy;
 
    draw();

    // at random switch friend
//    if (random(10000)>9990) {
//      friend = int(random(num));
//    }
  }

}

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(goodcolor.length))];
}


// City Traveler (variation B)
// j.tarbell   January, 2004
