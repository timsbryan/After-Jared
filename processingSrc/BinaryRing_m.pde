// Binary Ring
// j.tarbell   March, 2004
// Albuquerque, New Mexico
// complexification.net
// Processing 0085 Beta syntax update April, 2005


int num = 5000;           // total number of particles
int dim = 500;            // dimensions of rendering window

// blackout is production control of white or black filaments
boolean blackout = false;

// kaons is array of path tracing particles
Particle[] kaons;


// ENVIRONMENTAL METHODS ----------------------------------------------

void setup() {
  size(500,500,P3D);          // required for web publishing
//  size(dim,dim,P3D);
  background(0);
  framerate(30);

  kaons = new Particle[num];

  // begin with particle sling-shot around ring origin
  for (int i=0;i<num;i++) {
    int emitx = int(30*sin(TWO_PI*i/num)+dim/2);
    int emity = int(30*cos(TWO_PI*i/num)+dim/2);
    float r = PI*i/num;
    kaons[i] = new Particle(emitx,emity,r);
  }

}

void draw() {
  for (int i=0;i<num;i++) {
    kaons[i].move();
  }
  
  // randomly switch blackout periods
  if (random(10000)>9950) {
    if (blackout) {
      blackout = false;
    } else {
      blackout = true;
    }
  }
}

void mousePressed() {
    // manually switch blackout periods
    if (blackout) {
      blackout = false;
    } else {
      blackout = true;
    }
}



// OBJECTS ----------------------------------------------

// wandering particle
class Particle {
  float ox, oy;
  float x, y;
  float xx, yy;

  float vx;
  float vy;
  int age=int(random(200));
  color i;

  Particle(int Dx, int Dy, float r) {
    // initialize particle origin
    ox = dim/2;
    oy = dim/2;

    x = int(ox-Dx);    // position x
    y = int(oy-Dy);    // position y
    xx = 0;            // position x'
    yy = 0;            // position y'

    vx = 2*cos(r);     // velocity x
    vy = 2*sin(r);     // velocity y

    if (blackout) {
      i = #000000;
    } else {
      i = #FFFFFF;
    }
  }

  void move() {
    xx=x;
    yy=y;

    x+=vx;
    y+=vy;

    vx += (random(100)-random(100))*0.005;
    vy += (random(100)-random(100))*0.005;

    stroke(red(i),green(i),blue(i),24);
    line(ox+xx,oy+yy,ox+x,oy+y);
    line(ox-xx,oy+yy,ox-x,oy+y);

    // grow old
    age++;
    if (age>200) {
      // die and be reborn
      float t = random(TWO_PI);
      x=30*sin(t);
      y=30*cos(t);
      xx=0;
      yy=0;
      vx=0;
      vy=0;
      age=0;
      if (blackout) {
        i = #000000;
      } else {
        i = #ffffff;
      }
    }
  }
}



