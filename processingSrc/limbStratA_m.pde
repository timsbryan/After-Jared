// Limb Strat (variation A)
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 500;
int num = 0;
int maxnum = 100;
int maxdepth = 42;

int time;

Limb[] limbs;

int maxpal = 256;
int numpal = 0;
color[] goodcolor = new color[maxpal];

void setup() {
  size(500,500,P3D);
//  size(dim,dim,P3D);
  takecolor("longcolor.gif");
  background(255);
  framerate(30);

  limbs = new Limb[maxnum];

  limbs[0] = new Limb(dim/2,dim/2,0,0,5.0,61.0);
  limbs[0].render();
  limbs[1] = new Limb(dim/2,dim/2,0,PI,5.0,61.0);
  limbs[1].render();
}

void draw() {
  //  background(255);
  limbs[0].grow();
  limbs[0].render();
  limbs[1].grow();
  limbs[1].render();
}


class Limb {
  // feet
  int depth;
  int myAge;

  float x, y;
  float ox, oy;

  float radius;
  float core;
  float theta;
  float otheta;
  float thetav;

  float reduct;

  color myc;

  int numlimbs;
  Limb[] myLimbs = new Limb[10];

  Limb(float X, float Y, int Depth, float Theta, float Radius, float Core) {
    // init
    ox = x = X;
    oy = y = Y;

    depth = Depth;
    if (depth>0) theta = random(-PI/5,PI/5);
    otheta = Theta;
    reduct = 0.99;

    radius = Radius;
    core = Core;

    myc = somecolor();

    if (depth>=maxdepth) {
      numlimbs = 0;
    } else {
      numlimbs = 1;
      if (random(100)>101+(depth-maxdepth)/10) numlimbs+=int(random(2));
      // add limbs
      addLimbs();
    }

  }

  void addLimbs() {
    // set next radial point
    x = ox + radius*cos(theta+otheta);
    y = oy + radius*sin(theta+otheta);

    for (int n=0;n<numlimbs;n++) {
      float t = otheta + theta;
      //      float r = radius * reduct;
      float r = radius * 0.998;
      float c = core*reduct;
      myLimbs[n] = new Limb(x,y,depth+1,t,r,c);
    }
  }

  void grow() {
    myAge+=0.1+depth/(maxdepth*10);
    radius*=1.0091;
    theta+=random(-myAge,myAge);

    // set next radial point
    x = ox + radius*cos(theta+otheta);
    y = oy + radius*sin(theta+otheta);

    for (int n=0;n<numlimbs;n++) {
      myLimbs[n].setOrigin(x,y,theta+otheta);
      myLimbs[n].grow();
    }

  }

  void render() {
    // draw
    drawOutline();
    drawQuad();

    // draw child limbs
    for (int n=0;n<numlimbs;n++) {
      myLimbs[n].render();
    }

  }

  void drawQuad() {
    // find core corners
    stroke(myc);
    int stripes = int(1+radius*0.22);
    for (int n=0;n<stripes;n++) {
      // calc stripe midpoint
      float bx = ox+(x-ox)*n/stripes;
      float by = oy+(y-oy)*n/stripes;
      // calc stripe length
      float cr = (core - core*(1-reduct)*n/stripes)/2;
      float atheta = random(-PI/22,PI/22);
      // draw biasline
      biasline(bx+cr*cos(theta+otheta-HALF_PI+atheta),by+cr*sin(theta+otheta-HALF_PI+atheta),bx+cr*cos(theta+otheta+HALF_PI+atheta),by+cr*sin(theta+otheta+HALF_PI+atheta),myc,0.1);
    }

  }

  void drawOutline() {
    // find core corners
    stroke(32);
    float bx = core*0.5*sin(theta+otheta);
    float by = core*0.5*cos(theta+otheta);
    // draw bottom
    //    line(ox+bx,oy-by,ox-bx,oy+by);
    // draw top
    //    line(x+bx*reduct,y-by*reduct,x-bx*reduct,y+by*reduct);
    // draw sides
    //    line(ox+bx,oy-by,x+bx*reduct,y-by*reduct);
    //    line(ox-bx,oy+by,x-bx*reduct,y+by*reduct);

    // draw bottom
    //    biasline(ox+bx,oy-by,ox-bx,oy+by,#000000,0.05);
    // draw top
    //    biasline(x+bx*reduct,y-by*reduct,x-bx*reduct,y+by*reduct,#000000);
    // draw sides
    biasline(ox+bx,oy-by,x+bx*reduct,y-by*reduct,#000000,0.05);
    //    biasline(ox-bx,oy+by,x-bx*reduct,y+by*reduct,#000000);

  }

  void setOrigin(float X, float Y, float Theta) {
    ox = X;
    oy = Y;
    otheta = Theta;
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

void biasline(float x1, float y1, float x2, float y2, color myc, float a) {
  // calc distance
  float d = sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1))/3;
  stroke(red(myc),green(myc),blue(myc),256*a);
  for (int w=0;w<d;w++) {
    float t = (cos(random(PI))+1)/2;
    point(x1+t*(x2-x1), y1+t*(y2-y1));
  }
}

// Limb Strat, variation A
// j.tarbell   January, 2004
