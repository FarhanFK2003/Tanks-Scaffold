import java.util.ArrayList;

import processing.core.PApplet;

public class Tank {
    float x, y; // Position of the tank
    float turretAngle; // Angle of the turret
    int[] tankColor; // Color of the tank
    int maxHealth;
    int currentHealth;
    int id;
    int fuel; // Fuel level of the tank
    int score; // Score of the tank
    ArrayList<Projectile> projectiles;

    Tank(float x, float y, int[] tankColor, int maxHealth, int _id,ArrayList<Projectile> projectiles) {
        this.id = _id;
        this.x = x;
        this.y = y;
        this.tankColor = tankColor;
        this.maxHealth = maxHealth;
        this.currentHealth = maxHealth;
        this.turretAngle = 3 * PApplet.PI / 2;
        this.fuel = 250;
        this.score = 0; // Initialize score to 0
        this.projectiles = projectiles;
    }

    int getId() {
        return id;
    }

    void incrementScore() {
        score++;
    }

    void controlTurret(float angleChange) {
        turretAngle += angleChange;

        turretAngle = PApplet.constrain(turretAngle, PApplet.PI, 2 * PApplet.PI);
    }

    void displayFuel(PApplet parent) {
        parent.fill(255);
        parent.textSize(12);
        parent.text("Fuel: " + fuel, x - 30, y - 40);
    }
    // Method to display the score
    void displayScore(PApplet parent) {
        parent.textSize(12);
        parent.fill(255);
        parent.text("Score: " + score, x, y - 20); // Adjust position as needed
    }

    // Method to display the tank
    public void display(PApplet parent) {
        if (currentHealth > 0) { // Only display the tank if it is alive
            // Draw lower part of tank
            parent.fill(tankColor[0], tankColor[1], tankColor[2]);
            parent.rect(x + 8, y + 5, 18, 20); // Upper part
            parent.rect(x + 2, y + 20, 30, 10); // Lower part

            // Draw turret
            parent.pushMatrix();
            parent.translate(x + 17, y + 10); // Position turret above upper part
            parent.rotate(turretAngle); // Rotate turret
            parent.fill(0); // Black color for turret
            parent.rect(5, -3, 12, 6); // Turret barrel
            parent.popMatrix();

            displayHealth(parent);
            displayFuel(parent); // Display the current fuel level
            displayScore(parent);

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
    void displayHealth(PApplet parent) {
        parent.fill(255, 0, 0); // Red background for health lost
        parent.rect(x - 5, y + 30, 40, 5);
        parent.fill(0, 255, 0); // Green foreground for current health
        parent.rect(x - 5, y + 30, PApplet.map(currentHealth, 0, maxHealth, 0, 40), 5);
    }

    // Method to check if the tank is still alive
    boolean isAlive() {
        return currentHealth > 0;
    }

    void fire(PApplet parent) {
        float turretEndX = x + 40 * PApplet.cos(turretAngle); // Adjust for your turret's length
        float turretEndY = y + 40 * PApplet.sin(turretAngle);
        float power = 10; // Adjust power as necessary
        projectiles.add(new Projectile(turretEndX, turretEndY, turretAngle, power, id,parent.width,parent.height));
    }

    void move(int keyCode, PApplet parent) {
        float turretAngleChange = 3 * PApplet.PI;
        float tankMoveSpeed = 60;
        float fuelConsumptionPerMove = 0.5f; // Amount of fuel consumed per movement action

        float perFrameRate = 1 / parent.frameRate;

        turretAngleChange = turretAngleChange * perFrameRate;
        tankMoveSpeed = tankMoveSpeed * perFrameRate;

        if (fuel <= 0) {
            return; // Stop movement if there's no fuel left
        }

        // Store the current position for boundary checking
        float prevX = x;
        float nextX = x - 32;

        if (keyCode == PApplet.UP) {
            controlTurret(-turretAngleChange);
        } else if (keyCode == PApplet.DOWN) {
            controlTurret(turretAngleChange);
        } else if (keyCode == PApplet.LEFT) {
            x -= tankMoveSpeed; // Move tank left
            fuel -= fuelConsumptionPerMove;
        } else if (keyCode == PApplet.RIGHT) {
            x += tankMoveSpeed; // Move tank right
            fuel -= fuelConsumptionPerMove;
        }

        // Check if tank is within screen bounds
        if (x < 0 || x > parent.width || x > parent.width - 32) {
            // Reset tank position to previous position
            x = prevX;
            x = nextX;
        }

        if (fuel < 0) {
            fuel = 0;
        }
    }
}
