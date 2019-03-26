// Offspring 
// a robot colony
// j.tarbell   January, 2004

// Albuquerque, New Mexico
// complexification.net

// Processing 0085 Beta syntax update
// j.tarbell   April, 2005

int dim = 300;
int dimx = 2;
int num = 0;
int maxnum = 10000;
int maxlocation = 2000;
int maxchildren = 5;
int globaldate = 100;
int maxdate = 2012;

Bit[] bit = new Bit[maxnum];
boolean drawing = true;

int numpal = 0;
int maxpal = 512;
color[] goodcolor = new color[maxpal];


void createBit(int Mother, int Father, int Gen) {
  if (num<maxnum) {
    bit[num] = new Bit(num);
    bit[num].awaken(Mother,Father,Gen);  
    num++;
  }
}


void setup() {
  // set up drawing area
  size(300,600,P3D);
  takecolor("sunset.gif");
  background(255);

  // begin with an initial population of 42
  for (int n=0;n<22;n++) {
    createBit(-1,-1,0);
  }      
  
}

void draw() {
  if (drawing) {
    for (int n=0;n<num;n++) {
      if (bit[n].alive) {
        bit[n].draw();
      }
    }
 
    globaldate++;
    if (globaldate>=maxdate*1.25) {
      drawing=false;
    }
  }
}



// CLASSES -------------------------------------------------------------

class Bit {

  int id;
  int gen;
  int bdate;
  float location;
  float aroundium;
  
  // physical characteristics
  int child = 50+int(random(50));
  int adult = child+200+int(random(150));
  int oldage = adult+50+int(random(50));
  int maxage = oldage+100+int(random(40));
  
  boolean female;
  color myc;
  
  //  
  int mate = -1;
  int dmate = -1;
  int father;
  int mother;
  int children = int(random(num*maxchildren)/maxnum);
  boolean alive;
  Bit (int ID) {
    id = ID;
  }
  
  void awaken(int Mother, int Father, int Gen) {
    alive = true;
    if ((Mother<0) || (Father<0)) {
      mother = id;
      father = id;
      // position arbitrarily
      location = int(random(maxlocation));
      // age arbitrarily
      bdate = int(random(globaldate));
    } else {
      // realize mother and father
      mother = Mother;
      father = Father;
      // position self near mother // + (random offset)
      location = bit[mother].location; // +int(random(-maxlocation/10,maxlocation/10));
      // set date of birth
      bdate = globaldate;
    }
    
    gen = Gen;
    myc = goodcolor[gen];
   
    // choose random gender
    if (random(10000)<=5000) {
      female = true;
    } else {
      female = false;
    }
  
  }

  void renderPoint(int x, int y, int a) {
   
     stroke(red(myc),green(myc),blue(myc),22);
     if (female) {
       point(x-1,y);
       point(x+1,y);
     } else {
       point(x,y-1);
       point(x,y+1);
     }
     
     if (mate>0) {
       int mx = (x+bit[mate].getX())/2;
       stroke(0,30);
       point(mx,y);
     }
  }

  void renderPlus(int x, int y, int a) {
   
     stroke(red(myc),green(myc),blue(myc),22);
     if (female) {
       point(x-2,y);
       point(x+2,y);
     } else {
       point(x,y+2);
       point(x,y-2);
     }
     
     if (mate>0) {
       stroke(0,36);
       point(x,y);
     } else {
       stroke(255,36);
       point(x,y);
     }
  }
          
                              
  void renderMotherLine() {
    float t = random(PI);
    float st = sin(t);
    float x = bit[mother].getX() + st*(getX()-bit[mother].getX());
    float y = bit[mother].getY() + st*(getY()-bit[mother].getY());
    stroke(32,22);
    point(x,y);
  }
          
  void draw() {
    int age = globaldate-bdate;
    
    // chance of sudden death
    if ((age==int(maxage/2)) && (random(maxnum*2)<num)) {
      alive=false;
    }    
    // movus aroundium behavior    
    if (age>=maxage) {
      // time to skywalk
      alive = false;
    } else if (age>oldage) {
      // senior - come to rest
      aroundium*=0.92;
      // draw line to mother
      renderMotherLine();
    } else if (age>adult) {
      // adult - move randomly
      if (mate>0) {
        if (female) {
          location = bit[mate].location;
          aroundium = 0;
        } else {
          aroundium +=random(-4.0,4.0);
        }
      } else {
        aroundium +=random(-4.0,4.0);
      }
    } else if (age>child) {
      // child - seek mate, move randomly
      if ((mate<0) && (dmate<0)) {
        // not yet mated or seeking mate
        int d = int(floor(random(num)));
        if ((!isSelf(d)) && (!isSibling(d)) && (isOppositeSex(d)) && (!isMated(d)) && (isCloseAge(d,100))) {
          // wow, this fish might be a fit
          dmate = d;
        }
      } 

      // dating      
      if (dmate>=0) {
      
        if (!female) {
          // move towards dating mate
          aroundium += (bit[dmate].location - location)/2000;
        } else {
          // move randomly
          aroundium += random(-2.0,2.0)/2;
        }
        
        // ready to mate?
        if (isCloseTo(dmate,30)) {
          if (isMated(dmate)) {
            // missed opportunity
            dmate = -1;
          } else {
            // mate!
            mate = dmate;
            bit[mate].mate = id;
            bit[mate].dmate = -1;
            int udate = int(bit[mate].bdate+bdate)/2;
            bit[mate].bdate = udate;
            bdate = udate;
            dmate = -1;
          }            
        } else {
           // check if dating mate has mated (with another bit)
           if (bit[dmate].mate>=0) {
             // give up on already mated bits
             dmate = -1;
           }
        }       
      }  
      
      // mating
      if (mate>=0) {
        // has mate, follow
        aroundium += (bit[mate].location - location)/500;
        // move closer in age (visually)
        //bdate = int((bit[mate].bdate+bdate)/2);
        
        // chance of child
        if ((female) && (children<maxchildren) && (random(10000)>9500) && (gen<numpal)) {
          // make a cute little Bit
          createBit(id,mate,gen+1);
          children++;
        }
      }
      
    } else {
      // child, move randomly with restrictions
      aroundium+=random(-2.0,2.0);
    }
    
    // movus aroundium
    location+=aroundium;
    aroundium *= 0.95;
    // bound check location
    if (location<0) {
      location = maxlocation;
    } else if (location>maxlocation) {
      location = 0;
    }
    
    int dx = getX();
    int dy = getY();
    renderPlus(dx,dy,age);
  }
                
  int getX() {
    // position from left to right as a function of location
    return int(1 * location*dim/maxlocation);
  }
  int getY() {
    // position from bottom up as a function of birthdate
    return 4 + dim*dimx - int(1 * bdate*(dim*dimx-8)/(maxdate));
  }
  
  boolean isSibling(int Sid) {          
    if (bit[Sid].mother == mother) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean isSelf(int Sid) {
    if (Sid == id) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean isMated(int Sid) {
    if (bit[Sid].mate>=0) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean isOppositeSex(int Sid) {
    if (female) {
      if (bit[Sid].female) {
        return false;
      } else {
        return true;
      }
    } else {
      if (bit[Sid].female) {
        return true;
      } else {
        return false;
      }
    }    
  }
  
  boolean isCloseTo(int Sid, int D) {
    float dx = bit[Sid].location - location;
    float d = sqrt(dx*dx);
    if (d<D) {
      return true;
    } else {
      return false;
    }
  }
  
  boolean isCloseAge(int Sid, int D) {
    if (abs(bit[Sid].bdate - bdate)<=D) {
      return true;
    } else {
      return false;
    }
  }
}

// COLOR METHODS ---------------------------------------------------

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

void drawPal() {
  noStroke();
  float div = dim*dimx/numpal;
  for (int n=0;n<numpal;n++) {
    fill(goodcolor[n]);
    rect(div*n,0,div+1,10);
  }
}    

void drawYear() {
  stroke(64);
  int x = 4 + int(1 * globaldate*(dim*dimx-8)/(maxdate));
  line(x,0,x,dim);
}


// Offspring 
// a robot colony
// j.tarbell   January, 2004
