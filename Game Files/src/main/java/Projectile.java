import processing.core.PApplet;

public class Projectile {
    float x, y, vx, vy;
    int shooterId; // ID of the tank that shot this projectile
    boolean active;
    float screenWidth,screenHeight;

    // Constructor updated to include shooterId
    Projectile(float x, float y, float angle, float power, int shooterId,float screenWidth,float screenHeight) {
        this.x = x;
        this.y = y;
        this.vx = power * PApplet.cos(angle);
        this.vy = power * PApplet.sin(angle);
        this.active = true;
        this.shooterId = shooterId; // Store the ID of the shooter
        this.screenWidth = screenWidth;
        this.screenHeight = screenHeight;
    }

    void update(int wind, PApplet parent) {
        if (!active)
            return;

        // Calculate wind effect as a horizontal acceleration
        float windEffect = wind * 0.03f; // Assuming 'wind' is accessible here; if not, pass it as a parameter

        vx += 1/parent.frameRate *windEffect; // Apply wind effect to horizontal velocity
        vy += 1/parent.frameRate* 3.6f; // Continue applying gravity

        x += vx;
        y += vy;

        // Deactivate the projectile if it goes off screen
        if (x < 0 || x > screenWidth || y > screenHeight) {
            active = false;
        }
    }

    void display(PApplet parent) {
        parent.fill(255, 0, 0); // Red color
        parent.ellipse(x, y, 8, 8); // Draw projectile
    }
}
