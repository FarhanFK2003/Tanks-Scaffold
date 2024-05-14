class Projectile {
    float x, y, vx, vy;
    int shooterId;  // ID of the tank that shot this projectile
    boolean active;

    // Constructor updated to include shooterId
    Projectile(float x, float y, float angle, float power, int shooterId) {
        this.x = x;
        this.y = y;
        this.vx = power * cos(angle);
        this.vy = power * sin(angle);
        this.active = true;
        this.shooterId = shooterId;  // Store the ID of the shooter
    }

    void update() {
        if (!active) return;
        vx += 0;  // No horizontal acceleration
        vy += 0.2;  // Gravity effect
        x += vx;
        y += vy;

        // Deactivate the projectile if it goes off screen
        if (x < 0 || x > width || y > height) {
            active = false;
        }
    }

    void display() {
        fill(255, 0, 0);  // Red color
        ellipse(x, y, 8, 8);  // Draw projectile
    }
}
