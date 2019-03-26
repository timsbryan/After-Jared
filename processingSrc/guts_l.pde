// Guts  (crossing knot)
// J. Tarbell          
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

// dimensions
int dim = 600;
int num = 11;
int time = 0;

// object array
CPath[] cpaths;

// palette variables
int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];


// MAIN METHODS ------------------------------------

// initialization
void setup() {
  size(600,600,P3D);
//  size(dim,dim,P3D);
  takecolor("nude.gif");
  background(255);
  framerate(30);

  // make some discs
  cpaths = new CPath[num];
  
  begin();
}

// main
void draw() {
  // grow paths
  for (int c=0;c<num;c++) {  
    if (cpaths[c].moveme) {
      cpaths[c].grow();
    }
  }
}

void mousePressed () {
  begin();
  background(255);
}

void begin() {  
  // arrange knots
  for (int i=0;i<num;i++) {
    cpaths[i] = new CPath(i);
  }
}



// OBJECTS ------------------------------------------

class CPath {
  // index identifier
  int id;
  // position
  float x,y;
  // angle
  float a, av;
  float v;
  float tdv, tdvm;
  int time;
  // petals
  int pt;
  // girth
  float grth, gv;
  // sand painters
  int numsands = 3;
  boolean fadeOut, moveme;
  color myc = somecolor();
  SandPainter[] sandsCenter = new SandPainter[numsands];
  SandPainter[] sandsLeft = new SandPainter[numsands];
  SandPainter[] sandsRight = new SandPainter[numsands];
  SandPainter sandGut;

  CPath(int Id) {
    // construct
    id=Id;

    // create sand painters
    sandGut = new SandPainter(3);
    sandGut.setColor(#000000);
    for (int s=0;s<numsands;s++) {
      sandsCenter[s] = new SandPainter(0);
      sandsLeft[s] = new SandPainter(1);
      sandsRight[s] = new SandPainter(1);
      sandsLeft[s].setColor(#000000);
      sandsRight[s].setColor(#000000);
      sandsCenter[s].setColor(somecolor());
    }
    reset();        
  }
  
  void reset() {
    float d = random(dim/2);
    float t = random(TWO_PI);
    x = d*cos(t);
    y = d*sin(t);
    int ci = int(numpal*2.0*d/dim);
    for (int s=0;s<numsands;s++) {
      sandsCenter[s].setColor(goodcolor[ci]);
    }
    v=0.5;
    a=random(TWO_PI);
    grth=0.1;
    gv=1.2;
    pt = (int)pow(3,1+id%3);
//    pt = 2;
    time=0;
    tdv=random(0.1,0.5);
    tdvm=random(1.0,100.0);
    fadeOut = false;
    moveme = true;
  }
  
  void draw() {
    // draw each petal
    for (int p=0;p<pt;p++) {
      // calculate actual angle
      float t = atan2(y,x);
      float at = t+p*(TWO_PI/pt);
      float ad = a+p*(TWO_PI/pt);
      // calculate distance
      float d = sqrt(x*x+y*y);
      // calculate actual xy
      float ax = dim/2 + d*cos(at);
      float ay = dim/2 + d*sin(at);
      // calculate girth markers
      float cx = 0.5*grth*cos(ad-HALF_PI);
      float cy = 0.5*grth*sin(ad-HALF_PI);
      
      // draw points
      // paint background white
      for (int s=0;s<grth*2;s++) {
        float dd=random(-0.9,0.9);
        stroke(255);
        point(ax+dd*cx,ay+dd*cy);
      }
      for (int s=0;s<numsands;s++) {
        sandsCenter[s].render(ax+cx*0.6,ay+cy*0.6,ax-cx*0.6,ay-cy*0.6);
        sandsLeft[s].render(ax+cx*0.6,ay+cy*0.6,ax+cx,ay+cy);
        sandsRight[s].render(ax-cx*0.6,ay-cy*0.6,ax-cx,ay-cy);
      }
      // paint crease enhancement
      sandGut.render(ax+cx,ay+cy,ax-cx,ay-cy);
    }
  }

  void grow() {
    time+=random(4.0);
    x+=v*cos(a);
    y+=v*sin(a);
    
    // rotational meander
    av=0.1*sin(time*tdv)+0.1*sin(time*tdv/tdvm);
    while (abs(av)>HALF_PI/grth) {
      av*=0.73;
    }
    a+=av;
    
    // randomly increase and descrease in girth (thickness)      
    if (fadeOut) {
      gv-=0.062;
      grth+=gv;
      if (grth<0.1) {
        moveme = false;
      }
    } else {
      grth+=gv;
      gv+=random(-0.15,0.12);
      if (grth<6) {
        grth=6;
        gv*=0.9;
      } else if (grth>26) {
        grth=26;
        gv*=0.8;
      }
    }
    draw();
  }
  void terminate() {
    // do what?
    fadeOut = true;
  }

}


class SandPainter {
  color c;
  float g;
  int MODE;

  SandPainter(int M) {
    MODE = M;
    c = somecolor();
    g = random(0f,HALF_PI);
  }
  void render(float x, float y, float ox, float oy) {
    // modulate gain
    if (MODE==3) {
      g+=random(-0.9,0.5);
    } else {
      g+=random(-0.050,0.050);
    }
    if (g<0.0) g=0.0;
    if (g>HALF_PI) g=HALF_PI;
    
    if ((MODE==3) || (MODE==2)) {
      renderOne(x,y,ox,oy);
    } else if (MODE==1) {
      renderInside(x,y,ox,oy);
    } else if (MODE==0) {
      renderOutside(x,y,ox,oy);
    }
    
    
  }
  
  void renderOne(float x, float y, float ox, float oy) {
    // calculate grains by distance
    //int grains = int(sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)));
    int grains = 42;

    // lay down grains of sand (transparent pixels)
    float w = g/(grains-1);
    for (int i=0;i<grains;i++) {
      float a = 0.15-i/(grains*10.0+10);
      // paint one side
      float tex = sin(i*w); //HALF_PI*(cos(i*w*PI)+1);
      float lex = sin(tex); //(cos(tex*PI)+1)*0.5;
      
      stroke(red(c),green(c),blue(c),256*a);
      point(ox+(x-ox)*lex,oy+(y-oy)*lex);
    }
  }
  
  void renderInside(float x, float y, float ox, float oy) {
    // calculate grains by distance
    //int grains = int(sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)));
    int grains = 11;

    // lay down grains of sand (transparent pixels)
    float w = g/(grains-1);
    for (int i=0;i<grains;i++) {
      float a = 0.15-i/(grains*10.0+10);
      // paint one side
      float tex = sin(i*w); //HALF_PI*(cos(i*w*PI)+1);
      float lex = 0.5*sin(tex); //(cos(tex*PI)+1)*0.5;
      
      stroke(red(c),green(c),blue(c),256*a);
      point(ox+(x-ox)*(0.5+lex),oy+(y-oy)*(0.5+lex));
      point(ox+(x-ox)*(0.5-lex),oy+(y-oy)*(0.5-lex));
    }
  }

  void renderOutside(float x, float y, float ox, float oy) {
    // calculate grains by distance
    //int grains = int(sqrt((ox-x)*(ox-x)+(oy-y)*(oy-y)));
    int grains = 11;

    // lay down grains of sand (transparent pixels)
    float w = g/(grains-1);
    for (int i=0;i<grains;i++) {
      float a = 0.15-i/(grains*10.0+10);
      // paint one side
      float tex = sin(i*w); //HALF_PI*(cos(i*w*PI)+1);
      float lex = 0.5*sin(tex); //(cos(tex*PI)+1)*0.5;
      
      stroke(red(c),green(c),blue(c),256*a);
      point(ox+(x-ox)*lex,oy+(y-oy)*lex);
      point(x+(ox-x)*lex,y+(oy-y)*lex);
    }
  }
 
  void setColor(color C) {
    c = C;
  }
}


// COLOR METHODS ----------------------------------
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
        }
      }
    }
  }

}

// J. Tarbell          
// Albuquerque, New Mexico
// complexification.net





