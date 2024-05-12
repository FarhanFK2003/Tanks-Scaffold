PImage backgroundImage;
PImage treeImage;
JSONObject config;
int tileSize;
int[] foregroundColour;
String[] layoutLines; // Declare layoutLines as a global variable

ArrayList<Tank> tanks;

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
  layoutLines = loadStrings(layoutFileName); // Initialize layoutLines
  
  // Load the background image
  backgroundImage = loadImage(backgroundFileName);
  
  // Load the tree image
  treeImage = loadImage("tree2.png");
  
  // Set up the canvas
  size(864, 640);
  
  // Calculate tile size
  tileSize = width / 28;
  
  // Draw the background image
  image(backgroundImage, 0, 0, width, height);
  
  // Smooth the terrain
  smoothTerrain(layoutLines);
  
  // Initialize tanks ArrayList
  tanks = new ArrayList<Tank>();
  
  // Display the contents of the layout file
  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize;
      
      // Draw based on tile type
      switch(tile) {
        case 'X':
          // Draw terrain with foreground color
          fill(foregroundColour[0], foregroundColour[1], foregroundColour[2]); // Use foreground color specified in configuration
          rect(x, y, tileSize, height - y);
          break;
        case 'A':
          // Draw starting position for human players
          int[] blueColor = {0, 0, 255}; // Blue color
          tanks.add(new Tank(x + tileSize/2, y + tileSize/2, blueColor, 100));
          break;
        case 'B':
          // Draw starting position for human players
          int[] redColor = {255, 0, 0}; // Red color
          tanks.add(new Tank(x + tileSize/2, y + tileSize/2, redColor, 100));
          break;
        case 'C':
          // Draw starting position for human players
          int[] cyanColor = {0, 255, 255}; // Cyan color
          tanks.add(new Tank(x + tileSize/2, y + tileSize/2, cyanColor, 100));
          break;
        case 'D':
          // Draw starting position for human players
          int[] yellowColor = {255, 255, 0}; // Yellow color
          tanks.add(new Tank(x + tileSize/2, y + tileSize/2, yellowColor, 100));
          break;
        case 'E':
          // Draw starting position for human players
          int[] greenColor = {0, 255, 0}; // Green color
          tanks.add(new Tank(x + tileSize/2, y + tileSize/2, greenColor, 100));
          break;
        case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
          // Draw starting position for AI players
          fill(0, 255, 0); // Green color for AI players
          ellipse(x + tileSize/2, y + tileSize/2, tileSize/2, tileSize/2); // Draw a circle representing player
          break;
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
}


void draw() {
  // Clear the background
  background(0);

  // Render the background image
  image(backgroundImage, 0, 0, width, height);

  // Render the foreground terrain and trees
  for (int i = 0; i < layoutLines.length; i++) {
    String line = layoutLines[i];
    for (int j = 0; j < line.length(); j++) {
      char tile = line.charAt(j);
      float x = j * tileSize;
      float y = i * tileSize;

      // Draw based on tile type
      switch(tile) {
        case 'X':
          // Draw terrain with foreground color
          fill(foregroundColour[0], foregroundColour[1], foregroundColour[2]); // Use foreground color specified in configuration
          rect(x, y, tileSize, height - y);
          break;
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
  for (Tank tank : tanks) {
    tank.display();
  }
}


void smoothTerrain(String[] layoutLines) {
  // Apply moving average of 32 values twice to smooth the terrain
  for (int i = 0; i < layoutLines.length; i++) {
    for (int j = 0; j < layoutLines[i].length(); j++) {
      if (layoutLines[i].charAt(j) == 'X') {
        int smoothValue = computeSmoothValue(layoutLines, j, i);
        layoutLines[i] = layoutLines[i].substring(0, j) + 'X' + layoutLines[i].substring(j + 1); // Update the terrain value
      }
    }
  }
}

int computeSmoothValue(String[] lines, int x, int y) {
  // Compute the moving average of neighboring values
  int sum = 0;
  int count = 0;
  
  // Iterate over neighboring values in a 32x32 grid
  for (int i = -16; i <= 16; i++) {
    for (int j = -16; j <= 16; j++) {
      int newX = x + j;
      int newY = y + i;
      
      // Check if the neighboring tile is within bounds and is part of the terrain
      if (newX >= 0 && newX < lines[0].length() && newY >= 0 && newY < lines.length && lines[newY].charAt(newX) == 'X') {
        sum++;
        count++;
      }
    }
  }
  
  // Return the average value
  return count > 0 ? sum / count : 0;
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
  for (Tank tank : tanks) {
    tank.move(keyCode);
    
    
    
  }
}
