PImage backgroundImage;
PImage treeImage;
JSONObject config;
int tileSize;
int[] foregroundColour;
int players;
String[] layoutLines; // Declare layoutLines as a global variable

Tank[] tanks;

int turn ;

void setup() {
  turn = 0;
  // Load the JSON configuration file
  config = loadJSONObject("config.json");
  
  // Access the "levels" array
  JSONArray levels = config.getJSONArray("levels");
  
  // Load only the first level
  JSONObject firstLevel = levels.getJSONObject(0);
  
  //Hardcoding players with 5
  players = 0;
  
  // Extract information for the first level
  String layoutFileName = firstLevel.getString("layout");
  String backgroundFileName = firstLevel.getString("background");
  foregroundColour = parseColour(firstLevel.getString("foreground-colour"));
  
  
  // Load the content of the layout file
  layoutLines = loadStrings(layoutFileName); // Initialize layoutLines
  
  // Load the background image
  backgroundImage = loadImage(backgroundFileName);
  
  // Load the tree image
  treeImage = loadImage("tree2.png");
  
  // Set up the canvas
  size(864, 640);
  
  
  // Draw the background image
  image(backgroundImage, 0, 0, width, height);
  
  countPlayers();
  
  tanks = new Tank[players];
  
  
  float tileSize = 32;
  
  // Display the contents of the layout file
  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize;
      
      // Draw based on tile type
      switch(tile) {
        case 'A':
          int[] blueColor = {0, 0, 255};
          tanks[0]= new Tank(x, y, blueColor, 100,0);
          break;
        case 'B':
          int[] redColor = {255, 0, 0}; 

          tanks[1]= new Tank(x, y, redColor, 100,1);
          break;
        case 'C':
          int[] cyanColor = {0, 255, 255};
          tanks[2] = new Tank(x, y, cyanColor, 100,2);
          break;
        case 'D':
          int[] yellowColor = {255, 255, 0};
          tanks[3] = new Tank(x, y, yellowColor, 100,3);
          break;
        case 'E':
          int[] greenColor = {0, 255, 0}; 
          tanks[4] = new Tank(x , y , greenColor, 100,4);
          break;

        case 'T':
          // Draw trees
          float treeSize = tileSize * 1.1;
          image(treeImage, x, y, treeSize, treeSize);
          break;
        case ' ': // Ignore spaces
          break;
        default:
          // Ignore any other characters
          break;
      }
    }
  }
  
  
}




void draw() {
  
  // Clear the background
  background(0);

  // Render the background image
  image(backgroundImage, 0, 0, width, height);
  showTerrain();

  // Render the foreground terrain and trees
  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize;

      // Draw based on tile type
      switch(tile) {
        case 'T':
          // Draw trees
          float treeSize = tileSize * 1.1;
          // Draw tree image with calculated size
          image(treeImage, x, y, treeSize, treeSize);
          break;
        case ' ': // Ignore spaces
          break;
        default:
          // Ignore any other characters
          break;
      }
    }
  }

  // Display tanks and their health bars
  for (int i=0; i<players ;i++) {
    tanks[i].display();
  
  }
  
}



void showTerrain(){

  // Calculate tile size
  tileSize = 32;
  
  
  float[] xCoordinates = new float[28];
  float[] yCoordinates = new float[28];
  int xIndex = 0; // Index for xCoordinates array
  int yIndex = 0; // Index for yCoordinates array




  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize ;
      
      // Draw based on tile type
      switch(tile) {
        case 'X':
          // Store the x and y coordinates of 'X' tiles
          xCoordinates[xIndex++] = x;
          yCoordinates[yIndex++] = y;
          break;
      }
    }
  }  
  
  // Bubble Sort algorithm to sort xCoordinates array and rearrange yCoordinates array accordingly
  for (int i = 0; i < xIndex - 1; i++) {
      for (int j = 0; j < xIndex - i - 1; j++) {
          if (xCoordinates[j] > xCoordinates[j + 1]) {
              // Swap xCoordinates
              float tempX = xCoordinates[j];
              xCoordinates[j] = xCoordinates[j + 1];
              xCoordinates[j + 1] = tempX;
  
              // Swap corresponding yCoordinates
              float tempY = yCoordinates[j];
              yCoordinates[j] = yCoordinates[j + 1];
              yCoordinates[j + 1] = tempY;
          }
      }
  }
  
  float curveThresh = 4;
  
  
  for (int i = 0; i < xCoordinates.length; i++) {

    float x1,y1,x2,y2,x3,y3,x4,y4;  
      if( i == 0){
         x1 = xCoordinates[i];
         y1 = yCoordinates[i]-16;
         x4= xCoordinates[i]+16;
         y4 = yCoordinates[i];
        
      }
      else{
        x1 = xCoordinates[i-1]+16;
        y1 = yCoordinates[i-1];
        
        x4= xCoordinates[i]+16;
        y4 = yCoordinates[i];
        
      }
       
      float t = 0.0;
    
      float midX = (x1+x4)/2;
      float midY = (y1+y4)/2;
      
      x2 =x3 = midX;
      y2 = y1;
      y3 = y4;
      
    
      float k,l;
      k = x1;
      for(int count = 0;  count <= 32; count++){
        
        float tt = 1-t;
        
        k++;
        l = pow(tt,3)*y1+3*t*pow(tt,2)*y2+3*pow(t,2)*tt*y3+t*t*t*y4;
        
         t+=0.03125;
        
       
        stroke(foregroundColour[0], foregroundColour[1], foregroundColour[2]);
        line(k, l, k, height);
      }
      
  }  

}

void countPlayers(){
  // Display the contents of the layout file
  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize;
      
      // Draw based on tile type
      switch(tile) {
        case 'A':case'B':case'C':case'D':case'E':case'F':case'G':case'H':case'I':
          players++;
          break;
    }


    }
  }




}


int[] parseColour(String colourString) {
  // Parse the colour string to extract RGB values
  String[] rgb = split(colourString, ',');
  int[] colour = new int[3];
  for (int i = 0; i < 3; i++) {
    colour[i] = int(trim(rgb[i]));
  }
  return colour;
}


void keyPressed() {
  // Pass the key code to the controlTank method of each Tank object
  if(keyCode == 32)
  {
    //Implement Shooting Here
    turn = (turn+1)%players;
  }
  tanks[turn].move(keyCode);
  
}
