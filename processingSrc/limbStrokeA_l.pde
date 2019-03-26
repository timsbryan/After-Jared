// Limb Stroke, variation A
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 800;
int num = 0;
int k=3;
int maxnum = k*k+1;
int den = 44;
int time;

int vp1x, vp1y;
int vp2x, vp2y;

Star[] stars;

int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


void setup() {
  size(800,800,P3D);
  takecolor("forest.gif");
  background(255);
  framerate(30);

  stars = new Star[maxnum];
  int g=int(dim/k);
  for (int y=0;y<k;y++) {
    for (int x=0;x<k;x++) {
      stars[num] = new Star(x*g+g/2,y*g+3*g/6,0,-HALF_PI,24,somecolor());
      stars[num].render();
      num++;
    }
  }
}

void draw() {
  //background(0);
  for (int n=0;n<num;n++) {
    stars[n].swim();
  }
}

class Star {
  // feet
  int depth;
  int limbs;
  float time;
  float x, y;
  float ox, oy;
  float radius;
  float theta;
  color myc;
  Star[] myStars = new Star[4];
 
  Star(float X, float Y, int Depth, float Theta, float Radius, color C) {
    // init
    ox = x = X;
    oy = y = Y;
    theta = Theta;
    radius = Radius;
    depth = Depth;
    
    limbs = 0;
    time = 0;
//   myc = C;
    myc = somecolor();
  } 

  void swim() {
    time+=0.1;
      
    theta += PI*sin(time)/22;
    radius *= 0.99+0.01*cos(time);
    
    x = ox + radius*cos(theta);
    y = oy + radius*sin(theta);
    
   float a = 0.20-depth/32.0;
    stroke(red(myc),green(myc),blue(myc),256*a);
    for (int n=0;n<radius/2;n++) {
      point(ox+(x-ox)*sin(HALF_PI*n*2/radius),oy+(y-oy)*sin(HALF_PI*n*2/radius));
    }
    stroke(0,32);
    point(ox,oy);
    for (int n=0;n<limbs;n++) {
        myStars[n].setOrigin(x,y);
        myStars[n].swim();
    }
  }
  
  void render() {
    float tt = HALF_PI*(1-depth/9.0);
    theta += random(-tt,tt);
    radius *= random(0.92,1.0);
  
    // radial points
    x = ox + radius*cos(theta);
    y = oy + radius*sin(theta);
    
    if (depth<8) {
      for (int n=0;n<random(4);n++) {
        limbs = 0;
        myStars[n] = new Star(x,y,depth+1,theta,radius,myc);
        myStars[n].render();
        limbs++;
      }
    }
  }  
  void setOrigin(float X, float Y) {
    ox = X;
    oy = Y;
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


// Limb Stroke, variation A
// j.tarbell   January, 2004
