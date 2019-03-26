// Node Garden
// j.tarbell     August, 2004
// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 1000;
int numSpines;
int maxSpines = 500;
int numNodes;
int maxNodes = 10000;

PImage nodeIcoDark;
PImage nodeIcoSpec;
PImage nodeIcoBase;

// collection of nodes
GNode[] gnodes;

// collection of spines
Spine[] spines;

// color parameters
int maxpal = 512;
int numpal = 0;
color[] goodcolor = new color[maxpal];

int render = 0;


void setup() {
  size(1000,1000,P3D);
//  size(dim,dim,P3D);
  takecolor("longshort.gif");
  background(255);
  ellipseMode(CENTER);
  
  // load node icon   
  nodeIcoDark = loadImage("nodeXlgDark.gif");
  nodeIcoSpec = loadImage("nodeXlgSpecular.gif");
  nodeIcoBase = loadImage("nodeXlgBase.gif");
  
  // create all nodes
  gnodes = new GNode[maxNodes];
  
  // create all spines
  spines = new Spine[maxSpines];
  
  // go baby
  begin();  

}

void draw() {
  // six step rendering cycle
  if (render>0) {
    if (render==1) {
      // randomly connect all nodes
      for (int n=0;n<numNodes*5;n++) {
        int i = (int)random(numNodes);
        gnodes[i].findNearConnection();
      }
    } else if (render==2) {
      // remove obscured nodes
      for (int n=0;n<numNodes;n++) {
        gnodes[n].calcHidden();
      }
    } else if (render==3) {
      // draw all gnodes
      for (int n=0;n<numNodes;n++) {
        gnodes[n].drawNodeDark();
      }
    } else if (render==4) {
      // draw all connections
      for (int n=0;n<numNodes;n++) {
        gnodes[n].drawConnections();
      }
    } else if (render==5) {
      // decorate gnodes
      for (int n=0;n<numNodes;n++) {
        gnodes[n].drawNodeBase();
      }
    } else if (render==6) {
      for (int n=0;n<numNodes;n++) {
        gnodes[n].drawNodeSpecular();
      }
    }
    render++;
    if (render>6) {
      render = 0;
    }
  }
}

void mousePressed() {
  background(255);
  begin();
}


void makeNode(float X, float Y, float M) {
    if (numNodes<maxNodes) {
      gnodes[numNodes] = new GNode(numNodes);
      gnodes[numNodes].setPosition(X,Y);
      gnodes[numNodes].setMass(M);
      numNodes++;
    }
}

void makeSpine(float X, float Y, float T, float MTime) {
  if (numSpines<maxSpines) {
    spines[numSpines] = new Spine(numSpines);
    spines[numSpines].setPosition(X,Y);
    spines[numSpines].setTheta(T);
    spines[numSpines].traceInto(MTime);
    numSpines++;
  }
}

void begin() {
  // reset object counters
  numSpines = 0;
  numNodes = 0;

/*
  // arrange spines in line
  for (int i=0;i<maxSpines;i++) {
    float x = dim/4 + i*dim/(maxSpines-1);
    float y = dim/2;
    float mt = 420; 
    makeSpine(x,y,-HALF_PI,mt);
    makeSpine(x,y,HALF_PI,mt);
  }
  */
  // arrange spines in circle
  for (int i=0;i<maxSpines;i++) {
    float a = TWO_PI*i/(maxSpines-1);
    float x = dim/2 + 0.15*dim*cos(a);
    float y = dim/2 + 0.15*dim*sin(a);
    float mt = random(11,140); 
    makeSpine(x,y,a,mt);
    
    // make a second spine in opposite direction
//    makeSpine(x,y,a+PI,mt);
  }
  
  // begin step one of rendering process  
  render = 1;
}


// OBJECTS ----------------------------------------------------------------

class Spine {
  int id;
  
  float x,y;
  float xx,yy;
  
  float step;
  
  float theta;
  float thetav;
  float thetamax;
  float time;
  
  int depth = 1;
  float[] t = new float[depth];
  float[] amp = new float[depth];

  Spine(int Id) {
    id = Id;
    init();
  }
  
  void init() {
    step = random(2.0,7.3);
    thetamax = 0.1;
    theta = random(TWO_PI);
    for (int n=0;n<depth;n++) {
      amp[n] = random(0.01,0.3);
      t[n] = random(0.01,0.2);
    }
  }
  
  void setPosition(float X, float Y) {
    x = X;
    y = Y;
  }
  
  void setTheta(float T) {
    theta = T;
  }
  
  void traceInto(float MT) {
    // skip into the future
    for (time=random(MT);time<MT*2;time+=random(0.1,2.0)) {
      grow();
    }
  }

  void grow() {
    // save last position
    xx = x;
    yy = y;
    
    // calculate new position
    x+=step*cos(theta);
    y+=step*sin(theta);
    
    // rotational meander
    float thetav = 0.0;
    for (int n=0;n<depth;n++) {
      thetav+=amp[n]*sin(time*t[n]);
      amp[n]*=0.9998;
      t[n]*=0.998;
    }
    
    step*=1.005;
//    step*=0.995;
//    step+=0.01;
    theta+=thetav;
    
    // render    
    draw();
    
    // place node?
    if (random(1000)<61) {
      float m = random(3.21,5+500/(1+time));
      makeNode(x,y,m);
    }
  }  
  
  void draw() {
    stroke(85,26);
    line(x,y,xx,yy);
  }
}



// -----------------------

class GNode {
  int id;
  float x, y;
  float mass;

  // connections
  int numcons;
  int maxcons = 11;
  int[] cons;
  
  boolean hidden;
  
  color myc;
      
  GNode(int Id) {
    // set identification number
    id = Id;
    // create connection list
    cons = new int[maxcons];
    // initialize one time
    initSelf();
  }

  void initSelf() { 
    // initialize connections
    initConnections();
    // pick color
    myc = somecolor();
    hidden = false;
  }
  
  void initConnections() {
    // set number of connections to zero
    numcons=0;
  }
  
  void calcHidden() {
    // determine if hidden by larger gnode
    for (int n=0;n<numNodes;n++) {
      if (n!=id) {
        if (gnodes[n].mass>mass) {
          float d = dist(x,y,gnodes[n].x,gnodes[n].y);
          if (d<abs(mass*0.321-gnodes[n].mass*0.321)) {
              hidden = true;
          }
        }
      }
    }
  }
  
  void setPosition(float X, float Y) {
    // position self
    x=X;
    y=Y;
  }
  
  void setMass(float Sz) {
    // set size
    mass=Sz;
  }
   
  void findRandomConnection() {
    // check for available connection element
    if ((numcons<maxcons) && (numcons<mass)) {
      // pick other gnode at large
      int cid = int(random(numNodes));
      if (cid!=id) {
        cons[numcons]=cid;
        numcons++;
//        println(id+" connected to "+cid);
      } else {
        // random connection failed
      }
    } else {
      // no connection elements available
    }
  }
  
  void findNearConnection() {
    // find closest node
    if ((numcons<maxcons) && (numcons<mass)) {
      // sample 5% of nodes for near connection
      float dd = dim;
      int dcid = -1;
      for (int k=0;k<(numNodes/20);k++) {
        int cid = int(random(numNodes-1));
        float d = sqrt((x-gnodes[cid].x)*(x-gnodes[cid].x)+(y-gnodes[cid].y)*(y-gnodes[cid].y));
        if ((d<dd) && (d<mass*6)) {
          // closer gnode has been found
          dcid = cid;
          dd = d;
        }
      }
    
      if (dcid>=0) {
        // close node has been found, connect to it
        connectTo(dcid);
      }
    }
  }

  void connectTo(int Id) {
    if (numcons<maxcons) {
      boolean duplicate = false;
      for (int n=0;n<numcons;n++) {
        if (cons[n]==Id) {
          duplicate = true;
        }
      }
      if (!duplicate) {
        cons[numcons]=Id;
        numcons++;  
      }
    }
  }
                         
  void drawNodeDark() {
    // stamp node icon down
    if (!hidden) {
      float half_mass = mass/2;
      blend(nodeIcoDark,0,0,nodeIcoDark.width,nodeIcoDark.height,int(x-half_mass),int(y-half_mass),int(mass),int(mass),DARKEST);  
    }
  }

  void drawNodeSpecular() {
    // stamp node specular
    if (!hidden) {
      float half_mass = mass/2;
      blend(nodeIcoSpec,0,0,nodeIcoSpec.width,nodeIcoSpec.height,int(x-half_mass),int(y-half_mass),int(mass),int(mass),LIGHTEST);  
    }
  }

  void drawNodeBase() {
    // stamp node base
    if (!hidden) {
      float half_mass = mass/2;
      blend(nodeIcoBase,0,0,nodeIcoBase.width,nodeIcoBase.height,int(x-half_mass),int(y-half_mass),int(mass),int(mass),DARKEST);  
    }
  }
      
                  
  void drawConnections() {
    for (int n=0;n<numcons;n++) {
      // calculate connection distance
      float d = 4*dist(x,y,gnodes[cons[n]].x,gnodes[cons[n]].y);
      for (int i=0;i<d;i++) {
        // draw several points between connected gnodes  
        float a = i/d;
        // fuzz
        float fx = random(-0.42,0.42);
        float fy = random(-0.42,0.42);
        float cx = fx + x+(gnodes[cons[n]].x-x)*a;
        float cy = fy + y+(gnodes[cons[n]].y-y)*a;
        
        stroke(red(myc),green(myc),blue(myc),256*(0.05+(1-sin(a*PI))*0.16));
        point(cx,cy);
      }
    }   
  }  
}



// COLOR METHODS ----------------------------------------------------------------

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
