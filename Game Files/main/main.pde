//JSONObject config;

//void setup() {
//  // Load the JSON configuration file
//  config = loadJSONObject("config.json");
  
//  // Access the "levels" array
//  JSONArray levels = config.getJSONArray("levels");
  
//  // Load only the first level
//  JSONObject firstLevel = levels.getJSONObject(0);
  
//  // Extract information for the first level
//  String layoutFileName = firstLevel.getString("layout");
//  String background = firstLevel.getString("background");
//  String foregroundColour = firstLevel.getString("foreground-colour");
//  String trees = firstLevel.getString("trees", ""); // Optional, use an empty string if not present
  
//  // Load the content of the layout file
//  String[] layoutLines = loadStrings(layoutFileName);
  
//  // Display the information for the first level
//  println("Layout: " + layoutFileName);
//  println("Background: " + background);
//  println("Foreground Colour: " + foregroundColour);
//  println("Trees: " + trees);
  
//  // Display the contents of the layout file
//  for (String line : layoutLines) {
//    println(line);
//  }
//}
