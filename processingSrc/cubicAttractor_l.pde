// Cubic Attractors
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 800;
int a, b;
float t;
float dx, dy;
int num = 11;
int maxnum = num*num+1;
int numtravelers = 5000;
boolean blackout = false;
int mind = 128;
float nudge;

City[] cities;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


// MAIN --------------------------------------------------------------------

void setup() {
  size(800,800,P3D);
  // grab palette from image
  takecolor("longvoyage.gif");
  // erase background
  background(255);
  // define all cities
  cities = new City[maxnum];

  // place cities in grid
  nudge = dim/num;
  int i=0;
  for (int x=0;x<num;x++) {
    for (int y=0;y<num;y++) {
      cities[i] = new City(int(x*nudge+nudge/2),int(y*nudge+nudge/2),i);
      i++;
    }
  }
}

void draw() {
  for (int n=0;n<numtravelers;) {
    // pick random city A
    a = int(floor(random(num*num)));
    b = int(floor(random(num*num)));
    if ((a>=num*num) || (b>=num*num)) {
      // why does this happen?
    } else if (a!=b) {
      if (citydistance(a,b)<mind) {
        // pick random distance between city
        t = random(PI);
        dx = sin(t)*(cities[b].x-cities[a].x)+cities[a].x;
        dy = sin(t)*(cities[b].y-cities[a].y)+cities[a].y;

        if (random(1000)>990) {
          // noise
          dx += random(-1.5,1.5);
          dy += random(-1.5,1.5);
        }
        stroke(red(cities[b].myc),green(cities[b].myc),blue(cities[b].myc),44);
        point(dx,dy);
        stroke(red(cities[a].myc),green(cities[a].myc),blue(cities[a].myc),44);
        point(dx,dy);

        n++;
      }
    }
  }

  // move cities
  for (int c=0;c<(num*num);c++) {
    cities[c].move();
  }

}

float citydistance(int a, int b) {
  if (a!=b) {
    // calculate and return distance between cities
    float Dx = cities[b].x-cities[a].x;
    float Dy = cities[b].y-cities[a].y;
    float D = sqrt(Dx*Dx+Dy*Dy);
    return D;
  } else {
    return 0.0;
  }
}

// OBJECTS ------------------------------------------------------------------

class City {

  int x;
  int y;
  float destx, desty;
  float xp, yp;
  float vx, vy;
  int idx;
  color myc = somecolor();

  City(int Dx, int Dy, int Idx) {
    // position
    xp = Dx;
    yp = Dy;
    x = Dx;
    y = Dy;
    idx = Idx;

    // pick destination
    destx = int(random(num))*nudge+nudge/2;
    desty = int(random(num))*nudge+nudge/2;
  }

  void draw() {
    stroke(255,136);
    point(x,y);
  }
  void move() {
    vx+=(destx-xp)/2500;
    vy+=(desty-yp)/2500;

    vx*=0.973;
    vy*=0.973;
    xp+=vx;
    yp+=vy;
    x = int(xp);
    y = int(yp);

    draw();

  }
}

// COLOR METHODS --------------------------------------------------------------------

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
        } else {
          break;
        }
      }
    }
  }

  // pad with whites
  for (int n=0;n<6;n++) {
    goodcolor[numpal] = #FFFFFF;
    numpal++;
  }

  // pad with blacks
  for (int n=0;n<12;n++) {
    goodcolor[numpal] = #000000;
    numpal++;
  }

}
// Cubic Attractors 
// j.tarbell   January, 2004

