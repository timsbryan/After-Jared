// City Traveling, variation A
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int a, b;
float t;
int num = 64;
int maxnum = num*num+1;
int numtravelers = 5000;
int dim = 1000;
int mind = 200;

City[] cities;
color[] goodcolor = {#000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #000000, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };

void setup() {
  size(1000,1000,P3D);
  background(255);
  cities = new City[maxnum];
  int i=0;
  float nudge= dim/sqrt(num);
  for (int x=0;x<sqrt(num);x++) {
    for (int y=0;y<sqrt(num);y++) {
      cities[i] = new City(x*nudge+nudge/2,y*nudge+nudge/2);
      cities[i].draw();
      i++;
    }
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
    float dx = sin(t)*(cities[b].x-cities[a].x)+cities[a].x;
    float dy = sin(t)*(cities[b].y-cities[a].y)+cities[a].y;

    if (random(1000)>990) {
      // noise
      dx += random(-1.5,1.5);
      dy += random(-1.5,1.5);
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

color somecolor() {
  // pick some random good color
  return goodcolor[int(random(goodcolor.length))];
}


// OBJECTS ------------------------------------------------------------
class City {

  float x, y;
  int friend;
  float vx, vy;
  int population=5;
  color myc = somecolor();

  City(float Dx, float Dy) {
    // position
    x = Dx;
    y = Dy;

    friend = int(random(num));
  }

  void draw() {
    stroke(0,220);
    point(x,y);
  }
  
  void move() {
    vx+=(cities[friend].x-x)/2500;
    vy+=(cities[friend].y-y)/2500;

    vx*=.96;
    vy*=.96;
    x+=vx;
    y+=vy;

    draw();

    if (random(10000)>9990) {
      friend=int(random(num));
    }
  }

}


// City Traveling
// j.tarbell   January, 2004

