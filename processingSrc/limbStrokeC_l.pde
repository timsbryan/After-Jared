// Limb Stroke, variation C
// j.tarbell   January, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 800;
int k = 5;
int num = 0;
int maxnum = k*k*2+1;
int time;

Star[] stars;

int maxpal = 256;
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
      stars[num] = new Star(x*g+g/2,y*g+3*g/6,0,-HALF_PI,2.22,somecolor());
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
  float time, timev, timevv;
  float x, y;
  float ox, oy;
  float radius;
  float theta;
  color myc;
  Star[] myStars = new Star[3];
 
  Star(float X, float Y, int Depth, float Theta, float Radius, color C) {
    // init
    ox = x = X;
    oy = y = Y;
    theta = Theta;
    radius = Radius;
    depth = Depth;
    
    limbs = 0;
    time = 0;
    timev = 0.002;
    timevv = random(0.000001,0.0001);
//   myc = C;
    myc = somecolor();
  } 
  
  void render() {
    theta += random(-HALF_PI,HALF_PI);
    radius *= random(1.0,1.2);
  
    // radial points
    x = ox + radius*cos(theta);
    y = oy + radius*sin(theta);
    
    if (depth<16) {
      int ln=1;
      if (random(100)<depth*1.2) ln++;
      for (int n=0;n<ln;n++) {
        myStars[n] = new Star(x,y,depth+1,theta,radius,myc);
        myStars[n].render();
        limbs++;
      }
    }
  }

  void swim() {
    time+=timev;
    
    timev+=timevv;
      
    theta += PI*sin(time*depth/12)/11;
    radius *= 0.99+0.01*cos(time/2);
    
    x = ox + radius*cos(theta);
    y = oy + radius*sin(theta);

    stroke(0,14);
    point(ox,oy);
    
    float nlim = (depth+1)*radius/7;
    stroke(red(myc),green(myc),blue(myc),13);
    for (int n=0;n<nlim;n++) {
      point(ox+(x-ox)*sin(HALF_PI*n/nlim),oy+(y-oy)*sin(HALF_PI*n/nlim));
    }
    
    for (int n=0;n<limbs;n++) {
        myStars[n].setOrigin(x,y);
        myStars[n].swim();
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


// Limb Stroke, variation C
// j.tarbell   January, 2004
