// Limb Sand Stroke, variation A
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 800;
int num = 0;
int k = 3;
int maxnum = k*k+1;
int den = 44;
int time;
int points = 11;

int vp1x, vp1y;
int vp2x, vp2y;

Star[] stars;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];

void setup() {
  size(800,800,P3D);
//  size(dim,dim,P3D);
  takecolor("pollockShimmeringBlue.gif");
  background(255);
  framerate(30);

  stars = new Star[maxnum];
  int g=int(dim/k);
  for (int y=0;y<k;y++) {
    for (int x=0;x<k;x++) {
      stars[num] = new Star(x*g+g/2,y*g+3*g/6,0,-HALF_PI,6);
      stars[num].render();
      num++;
    }
  }
}

void draw() {
  for (int n=0;n<num;n++) {
    stars[n].swim();
  }
}


// OBJECTS -------------------------------------------------------------

class Star {
  // feet
  int depth;
  int limbs;
  float time, timev, timevv;
  float x, y;
  float ox, oy;
  float radius;
  float theta, ptheta;

  int numsweep = 2;
  int maxsweep = 11;
  float[] sweep = new float[maxsweep];
  color[] sweepc = new color[maxsweep];
  float[] sweepg = new float[maxsweep];

  Star[] myStars = new Star[2];

  Star(float X, float Y, int Depth, float Theta, float Radius) {
    // init
    ox = x = X;
    oy = y = Y;
    ptheta = Theta;
    radius = Radius;
    depth = Depth;

    limbs = 0;
    time = 0;
    timev = 0.001;
    if (random(100)>50) timev*=-1;

    // add sweeps
    for (int n=0;n<numsweep;n++) {
      sweep[n]=random(1.0);
      sweepc[n] = somecolor();
      sweepg[n] = random(0.1,0.4);
    }
  }

  void render() {
    theta = random(-HALF_PI/4,HALF_PI/4);
    radius *= random(1.0,1.3);

    // set next radial point
    x = ox + radius*cos(theta);
    y = oy + radius*sin(theta);

    if (depth<11) {
      int lnum=1;
      if (random(100)>90) lnum++;
      for (int n=0;n<lnum;n++) {
        myStars[n] = new Star(x,y,depth+1,theta,radius);
        myStars[n].render();
        limbs++;
      }
    }
  }

  void swim() {
    // move through time
    time+=timev;

    // spin in sinusoidal waves
    theta += sin(time)/20;
    radius *= 0.997+0.002*cos(time);

    // set next radius point
    x = ox + radius*cos(theta+ptheta);
    y = oy + radius*sin(theta+ptheta);

    // draw painting sweeps
    for (int n=0;n<numsweep;n++) {
      stroke(red(sweepc[n]),green(sweepc[n]),blue(sweepc[n]),26);
      point(ox+(x-ox)*sin(sweep[n]), oy+(y-oy)*sin(sweep[n]));
      
      sweepg[n]+=random(-0.001,0.001);
      float w = sweepg[n]/5;
      for (int i=0;i<5;i++) {
        float a = 0.1-i/60;
        stroke(red(sweepc[n]),green(sweepc[n]),blue(sweepc[n]),a*256);
        point(ox+(x-ox)*sin(sweep[n] + sin(i*w)), oy+(y-oy)*sin(sweep[n] + sin(i*w)));
        point(ox+(x-ox)*sin(sweep[n] - sin(i*w)), oy+(y-oy)*sin(sweep[n] - sin(i*w)));
      }
    }

    // draw child limbs
    for (int n=0;n<limbs;n++) {
      myStars[n].setOrigin(x,y,theta+ptheta);
      myStars[n].swim();
    }
  }

  void setOrigin(float X, float Y, float Theta) {
    ox = X;
    oy = Y;
    ptheta = Theta;
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
        } else {
          break;
        }
      }
    }
  }
}

// Limb Sand Stroke, variation A
// j.tarbell   January, 2004
