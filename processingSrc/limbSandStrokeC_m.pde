// Limb Sand Stroke, variation C
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 500;
int num = 0;
int maxnum = 1;
int time;
int points = 11;

Star[] stars;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];

void setup() {
  size(500,500,P3D);
//  size(dim,dim,P3D);
  takecolor("question.gif");
  background(255);
  framerate(30);

  stars = new Star[maxnum];
  stars[0] = new Star(dim/2,dim/2,0,-HALF_PI,10.0);
  stars[0].render();
}

void draw() {
  //background(0);
  stars[0].swim();
}

class Star {
  // feet
  int depth;
  int limbs;
  float time, timev, timevv;
  float x, y;
  float ox, oy;
  float radius;
  float theta, ptheta;

  int drag = int(18+random(4));
  int numsweep = 9;
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
      sweepg[n] = random(0.01,0.1);
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
      if (random(100)>90-depth*1.618) lnum++;
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
    theta += sin(time)/drag;
    radius *= 0.997+0.002*cos(time);

    // set next radius point
    x = ox + radius*cos(theta+ptheta);
    y = oy + radius*sin(theta+ptheta);

    // draw painting sweeps
    for (int n=0;n<numsweep;n++) {
      stroke(red(sweepc[n]),green(sweepc[n]),blue(sweepc[n]),32);
      point(ox+(x-ox)*sin(sweep[n]),oy+(y-oy)*sin(sweep[n]));

      sweepg[n]+=random(-0.051,0.050);
      
      if (sweepg[n]<-0.2) {
        sweepg[n]=-0.2;
      } else if (sweepg[n]>0.2) {
        sweepg[n]=0.2;
      }
      
      int sp = int(depth/2)+1;
      float w = sweepg[n]/sp;
      for (int i=0;i<sp;i++) {
        float a = 256*(0.1-i/(sp*10));
        stroke(red(sweepc[n]),green(sweepc[n]),blue(sweepc[n]),a);
        point(ox+(x-ox)*sin(sweep[n] + sin(i*w)),oy+(y-oy)*sin(sweep[n] + sin(i*w)));
        point(ox+(x-ox)*sin(sweep[n] - sin(i*w)),oy+(y-oy)*sin(sweep[n] - sin(i*w)));
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
  
  // pad with whites
  for (int n=0;n<8;n++) {
    goodcolor[numpal] = #FFFFFF;
    numpal++;
  }
  // pad with blacks
  for (int n=0;n<3;n++) {
    goodcolor[numpal] = #000000;
    numpal++;
  }
}


// Limb Sand Stroke, variation C
// j.tarbell   January, 2004
