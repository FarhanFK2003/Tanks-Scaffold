import processing.core.PApplet;
import processing.core.PImage;
import processing.data.JSONArray;
import processing.data.JSONObject;

import java.io.File;
import java.net.Inet4Address;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;


public class App extends PApplet {
    PImage backgroundImage;
    PImage treeImage;
    JSONObject config;
    int tileSize;
    int[] foregroundColour;
    int players;
    String[] layoutLines;

    List<Integer> deadplayers ;

    // Our lines
    float[] linesX = new float[924];
    float[] linesY = new float[924];


    Tank[] tanks;
    int turn;
    int wind;
    ArrayList<Projectile> projectiles = new ArrayList<Projectile>();

    public void settings() {
        size(864, 640);
    }

    public void setup() {
        initializeWind();
        turn = 0;

        deadplayers = new ArrayList<>();

                config = loadJSONObject("config.json");
        JSONArray levels = config.getJSONArray("levels");
        JSONObject firstLevel = levels.getJSONObject(0);

        players = 0;
        String layoutFileName = firstLevel.getString("layout");
        String backgroundFileName =  firstLevel.getString("background");
        foregroundColour = parseColour(firstLevel.getString("foreground-colour"));

        layoutLines = loadStrings(layoutFileName);

        backgroundImage = loadImage(backgroundFileName);
        treeImage = loadImage("tree2.png");

        image(backgroundImage, 0, 0, width, height);

        countPlayers();

        tanks = new Tank[players];

        tileSize = 32;

        float[] xCoordinates = new float[28];
        float[] yCoordinates = new float[28];


        int xIndex = 0;
        int yIndex = 0;




        for (int i = 0; i < layoutLines.length; i++) {
            String line = layoutLines[i];
            for (int j = 0; j < line.length(); j++) {
                char tile = line.charAt(j);
                float x = j * tileSize;
                float y = i * tileSize;

                switch (tile) {
                    case 'A':
                        int[] blueColor = {0, 0, 255};
                        tanks[0] = new Tank(x, y, blueColor, 100, 0,projectiles);
                        break;
                    case 'B':
                        int[] redColor = {255, 0, 0};
                        tanks[1] = new Tank(x, y, redColor, 100, 1,projectiles);
                        break;
                    case 'C':
                        int[] cyanColor = {0, 255, 255};
                        tanks[2] = new Tank(x, y, cyanColor, 100, 2,projectiles);
                        break;
                    case 'D':
                        int[] yellowColor = {255, 255, 0};
                        tanks[3] = new Tank(x, y, yellowColor, 100, 3,projectiles);
                        break;
                    case 'E':
                        int[] greenColor = {0, 255, 0};
                        tanks[4] = new Tank(x, y, greenColor, 100, 4,projectiles);
                        break;
                    case 'X':
                        xCoordinates[xIndex++] = x;
                        yCoordinates[yIndex++] = y;
                        break;
                    case 'T':
                        float treeSize = tileSize * (float)1.1;
                        image(treeImage, x, y, treeSize, treeSize);
                        break;
                }
            }

        }



        for (int i = 0; i < xIndex - 1; i++) {
            for (int j = 0; j < xIndex - i - 1; j++) {
                if (xCoordinates[j] > xCoordinates[j + 1]) {
                    float tempX = xCoordinates[j];
                    xCoordinates[j] = xCoordinates[j + 1];
                    xCoordinates[j + 1] = tempX;

                    float tempY = yCoordinates[j];
                    yCoordinates[j] = yCoordinates[j + 1];
                    yCoordinates[j + 1] = tempY;
                }
            }
        }

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

            float t = (float)0.0;

            float midX = (x1+x4)/2;

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

                linesX[i*32+count] = k;
                linesY[i*32+count] = l;
            }

        }
    }

    public void draw() {
        background(0);
        image(backgroundImage, 0, 0, width, height);

        showTerrain();

        for (int i = 0; i < players; i++) {
            tanks[i].display(this);
        }
        for (int i = projectiles.size() - 1; i >= 0; i--) {
            Projectile p = projectiles.get(i);
            p.update(wind);
            p.display(this);
            if (!p.active) {
                projectiles.remove(i);
            }
        }
        checkCollisions();
        displayHealthBar();
        displayWind();
    }

    void displayHealthBar() {
        int barWidth = 100; // Width of the health bar
        int barHeight = 20; // Height of the health bar, increased for better visibility
        int margin = 10; // Margin from the top of the window
        int barXPosition = width - (margin + barWidth + 200); // Position on the top right
        int barYPosition = margin; // Always at the same position, just under the top margin

        textSize(12); // Set the text size
        fill(255); // White color for text

        // Draw the label "Health:"
        text("Health:", barXPosition - 55, barYPosition + 15); // Adjust position as needed

        if (!deadplayers.contains(tanks[turn].id)) {
            int health = tanks[turn].currentHealth;

            fill(255, 255, 255); // Background color of the health bar (white)
            rect(barXPosition, barYPosition, barWidth, barHeight);

            fill(0, 0, 255); // Health color (blue)
            rect(barXPosition, barYPosition, (health / 100.0f) * barWidth, barHeight); // Adjust width according to health percentage

            // Draw the numerical health value
            text(health, barXPosition + barWidth + 5, barYPosition + 15);
        }
    }

    void initializeWind() {
        wind = (int) random(-35, 36); // Initialize wind with a random value between -35 and 35
    }

    void updateWind() {
        wind += (int) random(-5, 6); // Change wind by a random value between -5 and 5
        wind = constrain(wind, -35, 35); // Keep wind within the -35 to 35 range
    }

    void displayWind() {
        textSize(12);
        fill(255);
        text("Wind: " + wind, width - 100, 30); // Display wind value
        int iconWidth = 50;  // Set the desired width of the icons
        int iconHeight = 30; // Set the desired height of the icons
        if (wind > 0) {
            image(loadImage("wind-right.png"), width - 150, 20,iconWidth,iconHeight); // Display right wind icon
        } else if (wind < 0) {
            image(loadImage("wind-left.png"), width - 150, 20,iconWidth,iconHeight); // Display left wind icon
        }
    }



    void showTerrain(){

        for (int i =0 ; i< linesX.length;i++){
            stroke(foregroundColour[0], foregroundColour[1], foregroundColour[2]);
            line(linesX[i], linesY[i], linesX[i], height);
        }
    }

    void countPlayers() {
        for (int i = 0; i < layoutLines.length; i++) {
            String line = layoutLines[i];
            for (int j = 0; j < line.length(); j++) {
                char tile = line.charAt(j);
                switch (tile) {
                    case 'A': case 'B': case 'C': case 'D': case 'E':
                    case 'F': case 'G': case 'H': case 'I':
                        players++;
                        break;
                }
            }
        }
    }

    void checkCollisions() {
        for (Projectile p : projectiles) {
            if (!p.active) {
                projectiles.remove(p);
                continue;
            }
            for (Tank t : tanks) {
                if(!deadplayers.contains(t.id)){
                    if (p.active && checkPointSquareCollision(p.x, p.y, t.x, t.y,32) ) { // Assuming radius of impact
                        t.takeDamage(20);  // Damage the tank
                        if(p.shooterId != t.id)
                            tanks[p.shooterId].incrementScore();
                        p.active = false;  // Deactivate the projectile
                        break;
                    }
                    if(t.currentHealth <= 0){
                        deadplayers.add(t.id);
                    }

                }

            }

        }


    }

    boolean checkPointSquareCollision(float pX, float pY, float tX, float tY, float width){
        if(pX >= tX && pX <= (tX+width) && pY >= tY && pY <= (tY+width))
            return true;
        else
            return false;
    }


    int[] parseColour(String colourString) {
        String[] rgb = colourString.split(",");
        int[] colour = new int[3];
        for (int i = 0; i < 3; i++) {
            colour[i] = Integer.parseInt(rgb[i].trim());
        }
        return colour;
    }

    public void keyPressed() {
        if (keyCode == 32) {
            tanks[turn].fire(this);
            turn = (turn + 1) % players;
            updateWind();
            for (int i = 0 ; i < players; i++){
                if(deadplayers.contains(i)){
                    turn = (turn + 1) % players;

                }
                else
                    break;
            }
            println(deadplayers);
        }
        tanks[turn].move(keyCode,this);
    }

    public static void main(String[] args) {
        PApplet.main("App");
    }
}



