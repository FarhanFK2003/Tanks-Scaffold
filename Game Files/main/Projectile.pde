class Projectile {
    float x, y, vx, vy;
    boolean active;

    Projectile(float x, float y, float angle, float power) {
        this.x = x;
        this.y = y;
        this.vx = power * cos(angle);
        this.vy = power * sin(angle);
        this.active = true;
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
