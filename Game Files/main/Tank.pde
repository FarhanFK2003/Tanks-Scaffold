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

  // Constructor to initialize the tank
  Tank(float x, float y, int[] tankColor) {
    this.x = x;
    this.y = y;
    this.tankColor = tankColor;
    this.turretAngle = PI/2;
  }

  // Method to control turret movement
  void controlTurret(float angleChange) {
    turretAngle += angleChange;
    // Limit turret rotation angle within a range (e.g., 0 to 180 degrees)
    turretAngle = constrain(turretAngle, 0, PI/2);
  }

  // Method to control upper part movement
  void controlUpperPart(float deltaX) {
    x += deltaX;
  }

  // Method to control lower part movement
  void controlLowerPart(float deltaY) {
    y += deltaY;
  }

  // Method to display the tank
  void display() {
    // Draw lower part of tank
    fill(tankColor[0], tankColor[1], tankColor[2]);
    rect(x - 30, y, 60, 40); // Lower part

    // Draw upper part of tank
    rect(x - 20, y - 40, 40, 40); // Upper part
    
    // Draw turret
    pushMatrix();
    translate(x, y - 40); // Position turret above upper part
    rotate(turretAngle); // Rotate turret
    fill(255); // White color for turret
    rect(-5, -15, 10, 15); // Turret body
    rect(-20, -5, 40, 10); // Turret barrel
    popMatrix();
  }
}
