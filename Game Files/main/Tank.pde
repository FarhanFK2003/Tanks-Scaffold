class Tank {
    float x, y; // Position of the tank
    int maxHealth;
    int currentHealth;
    PImage tankImage; // Image for the tank

    // Constructor to initialize the tank
    Tank(float x, float y, int maxHealth, String imageName) {
        this.x = x;
        this.y = y;
        this.maxHealth = maxHealth;
        this.currentHealth = maxHealth;
        this.tankImage = loadImage(imageName);
    }

    // Method to display the tank
    void display() {
        image(tankImage, x, y);
        displayHealth();
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
        rect(x, y - 20, 40, 5);
        fill(0, 255, 0); // Green foreground for current health
        rect(x, y - 20, map(currentHealth, 0, maxHealth, 0, 40), 5);
    }

    // Method to check if the tank is still alive
    boolean isAlive() {
        return currentHealth > 0;
    }
}
