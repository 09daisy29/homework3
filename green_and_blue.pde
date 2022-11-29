import com.hamoid.*;


import java.util.*;
VideoExport videoExport;
int i, maxIters;

PriorityQueue<Rectangle> rects = new PriorityQueue();
ArrayList<Rectangle> toColour = new ArrayList();
ArrayList<Rectangle> originalToColour = new ArrayList();

void setup(){
    
  size(750, 800); 

  background(255);
  strokeWeight(8);
  rects.add(new Rectangle(0, 0, 750, 800));
  i = 0;
  maxIters = 20;
   
 videoExport = new VideoExport(this, "green_and_blue.mp4");
     videoExport.startMovie();
}

class Rectangle implements Comparable<Rectangle>{
  float x, y, width, height, area;
  
   Rectangle(float x, float y, float w, float h){
     this.x = x;
     this.y = y;
     width = w;
     height = h;   
     area = height * width;
    
    
     
     fill(255);
     rect(x, y, width, height);   
   }
   
   void redraw(){
     rect(x, y, width, height);   
   }
   
   int compareTo(Rectangle other){
    int result;
   if(this.area < other.area ){  
       result = 1;                 
     }else if(this.area > other.area){
      result = -1;
     }else{
       result = 0;
     }
     return result;
   }
   
   void split(){
     float min = 42;    
     float dy = 20;  
     
     if(width>min || height>min){  
     
    toColour.remove(this);
       int direction = int(random(2));  
       if(direction==0 && width>min){   
        float xOffset = random(dy, width-dy);  //split with vertical line
        Rectangle rect1 = new Rectangle(x, y, xOffset, height);
        rects.add(rect1);
        toColour.add(rect1);
         Rectangle rect2 = new Rectangle(x+xOffset, y, width-xOffset, height);
        rects.add(rect2);
         toColour.add(rect2);
       }else{
         float yOffset = random(dy, height-dy);  //split with horizontal line
        Rectangle rect1 = new Rectangle(x, y, width, yOffset);
        rects.add(rect1);
        toColour.add(rect1);
         Rectangle rect2 = new Rectangle(x, y+yOffset, width, height-yOffset);
         rects.add(rect2);
        toColour.add(rect2);
       }
     }
   }
}
void draw(){
  int rand1 = int(random(7));
  int rand2 = int(random(8));
  int[][] colours = new int[4][2];
      colours[0][0] = #c9e4ca;   
      colours[0][1] = 7 + rand1;
      colours[1][0] = #259336;  
      colours[1][1] =15 - colours[0][1];
      colours[2][0] =#70D4F7;  
      colours[2][1] = 7;
      colours[3][0] = #90F2B2;  
      colours[3][1] = rand2;  

  int numColours = 0;
  ArrayList<Integer> allColours = new ArrayList<Integer>();
  for(int i = 0; i < colours.length; i++){
    numColours += colours[i][1];
    for(int j = 0; j < colours[i][1]; j++){
      allColours.add(colours[i][0]);
    }
  }
  
  if(i<maxIters){
    i++;
    rects.poll().split();
    delay(180);
    if(i == maxIters-1){
     originalToColour.addAll(toColour);
   }
  }else if(i < maxIters + numColours){
   fill(allColours.get(i-maxIters));
   int rectNum = int(random(toColour.size()));
   Rectangle chosen = toColour.get(rectNum);
   chosen.redraw();
   delay(150);
   i++;   
  }
    videoExport.saveFrame();
}
void keyPressed(){
  if(key == ' ' ){
    background(255);
    i = 0;
    rects.clear();  
    rects.add(new Rectangle(0, 0, 750, 800));
    toColour.clear();
    originalToColour.clear();
  }
      if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}
