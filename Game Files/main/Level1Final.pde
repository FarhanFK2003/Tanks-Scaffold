PImage backgroundImage;
PImage treeImage;
JSONObject config;
int tileSize;
int[] foregroundColour;

void setup() {
  // Load the JSON configuration file
  config = loadJSONObject("config.json");
  
  // Access the "levels" array
  JSONArray levels = config.getJSONArray("levels");
  
  // Load only the first level
  JSONObject firstLevel = levels.getJSONObject(0);
  
  // Extract information for the first level
  String layoutFileName = firstLevel.getString("layout");
  String backgroundFileName = firstLevel.getString("background");
  foregroundColour = parseColour(firstLevel.getString("foreground-colour"));
  
  // Load the content of the layout file
  String[] layoutLines = loadStrings(layoutFileName);
  
  //println(layoutLines);
  
  // Smooth the terrain
  
  // Load the background image
  backgroundImage = loadImage(backgroundFileName);
  
  // Load the tree image
  treeImage = loadImage("tree2.png");
  
  // Set up the canvas
  size(864, 640);
  
  // Calculate tile size
  tileSize = 32;
  
  // Draw the background image
  image(backgroundImage, 0, 0, width, height);
  
  // Smooth the terrain
  //smoothTerrain(layoutLines);
  
  // Getting The Terrain locations
  
  println(layoutLines[0].length());
  
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
  
  
  
  // Display the contents of the layout file
  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize;
      
      // Draw based on tile type
      switch(tile) {
        case 'A': case 'B': case 'C': case 'D': case 'E':
          // Draw starting position for human players
          fill(255, 0, 0); // Red color for human players
          ellipse(x + tileSize/2, y + tileSize/2, tileSize/2, tileSize/2); // Draw a circle representing player
          break;
        case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
          // Draw starting position for AI players
          fill(0, 255, 0); // Green color for AI players
          ellipse(x + tileSize/2, y + tileSize/2, tileSize/2, tileSize/2); // Draw a circle representing player
          break;
        case 'T':
          // Draw trees
          //fill(0, 255, 0); // Green color for trees
          //rect(x, y, tileSize, tileSize); // Draw a rectangle representing tree
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
}

//void smoothTerrain(String[] terrain, int windowSize) {
//  String[] smoothedTerrain = new String[terrain.length];
//  for (int i = 0; i < terrain.length; i++) {
//    String line = terrain[i];
//    StringBuilder smoothedLine = new StringBuilder();
//    for (int j = 0; j < line.length(); j++) {
//      if (line.charAt(j) == 'X') {
//        // Apply moving average filter
//        int sum = 0;
//        int count = 0;
//        for (int k = j - windowSize/2; k <= j + windowSize/2; k++) {
//          if (k >= 0 && k < line.length() && terrain[i].charAt(k) == 'X') {
//            sum++;
//            count++;
//          }
//        }
//        smoothedLine.append(count >= windowSize/2 ? 'X' : ' '); // If enough 'X' characters in the window, keep 'X'
//      } else {
//        smoothedLine.append(' '); // Ignore non-'X' characters
//      }
//    }
//    smoothedTerrain[i] = smoothedLine.toString();
//  }
//  // Update the original terrain data with the smoothed terrain
//  for (int i = 0; i < terrain.length; i++) {
//    terrain[i] = smoothedTerrain[i];
//  }
//}

//void displayTerrain(String[] terrain) {
//  background(255);
//  float tileSize = width / terrain[0].length();
//  for (int i = 0; i < terrain.length; i++) {
//    String line = terrain[i];
//    for (int j = 0; j < line.length(); j++) {
//      if (line.charAt(j) == 'X') {
//        fill(0);
//        rect(j * tileSize, i * tileSize, tileSize, tileSize);
//      }
//    }
//  }
//}

//void smoothTerrain(String[] layoutLines) {
//  // Create a temporary array to store smoothed terrain
//  String[] smoothedTerrain = new String[layoutLines.length];

//  // Apply moving average of 32 values twice to smooth the terrain
//  for (int i = 0; i < layoutLines.length; i++) {
//    StringBuilder smoothedLine = new StringBuilder();
//    for (int j = 0; j < layoutLines[i].length(); j++) {
//      if (layoutLines[i].charAt(j) == 'X') {
//        int smoothValue = computeSmoothValue(layoutLines, j, i);
//        if (smoothValue > 0) {
//          smoothedLine.append('X');
//        } else {
//          smoothedLine.append(' ');
//        }
//      } else {
//        smoothedLine.append(' ');
//      }
//    }
//    smoothedTerrain[i] = smoothedLine.toString();
//  }

//  // Copy the smoothed terrain back to the original layout
//  for (int i = 0; i < layoutLines.length; i++) {
//    layoutLines[i] = smoothedTerrain[i];
//  }
//}

//int computeSmoothValue(String[] lines, int x, int y) {
//  // Compute the moving average of neighboring values
//  int sum = 0;
//  int count = 0;

//  // Iterate over neighboring values in a 32x32 grid
//  for (int i = -16; i <= 16; i++) {
//    for (int j = -16; j <= 16; j++) {
//      int newX = x + j;
//      int newY = y + i;

//      // Check if the neighboring tile is within bounds and is part of the terrain
//      if (newX >= 0 && newX < lines[0].length() && newY >= 0 && newY < lines.length && lines[newY].charAt(newX) == 'X') {
//        sum++;
//      }
//    }
//  }

//  // Return 1 if the sum is greater than a threshold, otherwise return 0
//  return sum > 10 ? 1 : 0;
//}


int[] parseColour(String colourString) {
  // Parse the colour string to extract RGB values
  String[] rgb = split(colourString, ',');
  int[] colour = new int[3];
  for (int i = 0; i < 3; i++) {
    colour[i] = int(trim(rgb[i]));
  }
  return colour;
}
