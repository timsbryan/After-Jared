// City Traveler
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005


int a, b;
float t;
float dx, dy;
int num = 100;
int maxnum = 1000;
int numtravelers = 500;
int dim = 400;
int mind = 100;

City[] cities;
color[] goodcolor = {#000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };

void setup() {
  size(400,400,P3D);
  framerate(30);
  background(255);
  cities = new City[maxnum];

  for (int i=0;i<num;i++) {
    cities[i] = new City(random(dim),random(dim));
    cities[i].draw();
  }

}

void draw() {
  for (int n=0;n<numtravelers;n++) {
    // pick random city A
    a = int(random(num-1));
    b = int(random(num-1));
    while (citydistance(a,b)>mind) {
      b = int(random(num-1));
    }

    // pick random distance between city
    t = random(PI);
    dx = sin(t)*(cities[b].xp-cities[a].xp)+cities[a].xp;
    dy = sin(t)*(cities[b].yp-cities[a].yp)+cities[a].yp;

    if (random(1000)>900) {
      // noise
      dx = dx+random(-1.5,1.5);
      dy = dy+random(-1.5,1.5);
    }
    stroke(red(cities[b].myc),green(cities[b].myc),blue(cities[b].myc),51);
    point(dx,dy);
    stroke(red(cities[a].myc),green(cities[a].myc),blue(cities[a].myc),51);
    point(dx,dy);
  }

  // move cities
  for (int c=0;c<num;c++) {
    cities[c].move();
  }
}

void mousePressed() {
  // reset
  background(255);

  for (int i=0;i<num;i++) {
    cities[i] = new City(random(dim),random(dim));
    cities[i].draw();
  }
}



float citydistance(int a, int b) {
  if (a!=b) {
    // calculate and return distance between cities
    float dx = cities[b].xp-cities[a].xp;
    float dy = cities[b].yp-cities[a].yp;
    float d = sqrt(dx*dx+dy*dy);
    return d;
  } else {
    return 0.0;
  }
}

// translucent line
class City {

  float xp, yp;
  float vx, vy;
  int population=5;
  color myc = somecolor();

  City(float Dx, float Dy) {
    // position
    xp = Dx;
    yp = Dy;

  }

  void draw() {
    stroke(0);
    point(xp,yp);
  }
  void move() {
    for (int j=0;j<num;j++) {
      if (cities[j]!=this) {
        if (myc == cities[j].myc) {
          vx+=(cities[j].xp-xp)/500;
          vy+=(cities[j].yp-yp)/500;
        }
      }
    }
    vx*=.97;
    vy*=.97;
    xp+=vx;
    yp+=vy;
    
    draw();
  }
}

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(goodcolor.length))];
}



// City Traveler
// j.tarbell   January, 2004
