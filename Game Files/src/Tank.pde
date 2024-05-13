
//class Tank {
//    float x, y; // Position of the tank
//    int maxHealth;
//    int currentHealth;
//    PImage tankImage; // Image for the tank

//    // Constructor to initialize the tank
//    Tank(float x, float y, int maxHealth, String imageName) {
//        this.x = x;
//        this.y = y;
//        this.maxHealth = maxHealth;
//        this.currentHealth = maxHealth;
//        this.tankImage = loadImage(imageName);
//    }

//    // Method to display the tank
//    void display() {
//        image(tankImage, x, y);
//        displayHealth();
//    }

//    // Method to take damage
//    void takeDamage(int damage) {
//        currentHealth -= damage;
//        if (currentHealth < 0) {
//            currentHealth = 0; // Ensure the health does not go negative
//        }
//    }

//    // Method to display health above the tank
//    void displayHealth() {
//        fill(255, 0, 0); // Red background for health lost
//        rect(x, y - 20, 40, 5);
//        fill(0, 255, 0); // Green foreground for current health
//        rect(x, y - 20, map(currentHealth, 0, maxHealth, 0, 40), 5);
//    }

//    // Method to check if the tank is still alive
//    boolean isAlive() {
//        return currentHealth > 0;
//    }
//}

// Tank class definition
class Tank {
  float x, y; // Position of the tank
  float turretAngle; // Angle of the turret
  int[] tankColor; // Color of the tank
  int lastUpdateTime; // Time of the last update
  int maxHealth;
  int currentHealth;
  int id;
  int fuel; // Fuel level of the tank
  int score; // Score of the tank
  
  Tank(float x, float y, int[] tankColor, int maxHealth, int _id) {
    this.id = _id;
    this.x = x;
    this.y = y;
    this.tankColor = tankColor;
    this.maxHealth = maxHealth;
    this.currentHealth = maxHealth;
    this.turretAngle = 3*PI/2;
    this.lastUpdateTime = millis();
    this.fuel = 250;
    this.score = 0; // Initialize score to 0
  }
  
  int getId(){
    return id;
  }
  // Increment score
  void incrementScore() {
    score++;
  }

  // Method to display the score
  void displayScore() {
    textSize(12);
    fill(255);
    text("Score: " + score, x, y - 20); // Adjust position as needed
  }

  // Method to control turret movement
  void controlTurret(float angleChange) {
    turretAngle += angleChange;
    // Limit turret rotation angle within a range (e.g., 0 to 180 degrees)
    turretAngle = constrain(turretAngle, PI, 2*PI);
  }

  // Method to control upper part movement
  void controlUpperPart(float deltaX) {
    x += deltaX;
  }

  // Method to control lower part movement
  void controlLowerPart(float deltaY) {
    y += deltaY;
  }
  // Method to display the current fuel level
  void displayFuel() {
    fill(255);
    textSize(12);
    text("Fuel: " + fuel, x - 30, y - 40); // Display fuel level near the tank
  }
  // Method to display the tank
  // Method to display the tank
  void display() {
      if (currentHealth > 0) { // Only display the tank if it is alive
          // Draw lower part of tank
          fill(tankColor[0], tankColor[1], tankColor[2]);
          rect(x+8, y+5 , 18, 20); // Upper part
          rect(x+2 , y+20, 30, 10); // Lower part
  
          // Draw turret
          pushMatrix();
          translate(x+17, y + 10); // Position turret above upper part
          rotate(turretAngle);  // Rotate turret
          fill(0); // Black color for turret
          rect(5, -3, 12, 6); // Turret barrel
          popMatrix();
  
          displayHealth();
          displayFuel(); // Display the current fuel level
          displayScore(); // Display the score
      }
  }


  // Method to take damage
  void takeDamage(int damage) {
    currentHealth -= damage;
    if (currentHealth < 0) {
      currentHealth = 0; // Ensure the health does not go negative
    }
  }

  // Method to display health above the tank
  void displayHealth() {
    fill(255, 0, 0); // Red background for health lost
    rect(x - 5, y + 30, 40, 5);
    fill(0, 255, 0); // Green foreground for current health
    rect(x - 5, y +30, map(currentHealth, 0, maxHealth, 0, 40), 5);
  }

  // Method to check if the tank is still alive
  boolean isAlive() {
    return currentHealth > 0;
  }

  void fire() {
    float turretEndX = x + 40 * cos(turretAngle); // Adjust for your turret's length
    float turretEndY = y + 40 * sin(turretAngle);
    float power = 10;  // Adjust power as necessary
    projectiles.add(new Projectile(turretEndX, turretEndY, turretAngle, power,id));
  }

  
void move(int keyCode) {
    float turretAngleChange = 3 * PI;
    float tankMoveSpeed = 60;
    float fuelConsumptionPerMove = 0.5; // Amount of fuel consumed per movement action
    float fuelConsumptionPerTurretMove = 0.2; // Amount of fuel consumed per turret movement

    float perFrameRate = 1/frameRate;

    turretAngleChange = turretAngleChange * perFrameRate;
    tankMoveSpeed = tankMoveSpeed * perFrameRate;

    if (fuel <= 0) {
        return; // Stop movement if there's no fuel left
    }

    if (keyCode == UP) {
        controlTurret(turretAngleChange); // Move turret up
    } else if (keyCode == DOWN) {
        controlTurret(-turretAngleChange); // Move turret down
    } else if (keyCode == LEFT) {
        x -= tankMoveSpeed; // Move tank left
        fuel -= fuelConsumptionPerMove;
    } else if (keyCode == RIGHT) {
        x += tankMoveSpeed; // Move tank right
        fuel -= fuelConsumptionPerMove;
    }

    // Optionally, clamp the fuel value to ensure it doesn't go below zero
    if (fuel < 0) {
        fuel = 0;
    }
}
}
