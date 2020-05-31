class Loot {
  int lootX;
  int lootY;
  int lootType;
  float t = 0;
  
  public Loot(int lootX, int lootY, int lootType) {
    this.lootX = lootX;
    this.lootY = lootY;
    this.lootType = lootType;
  }
  
  void draw(float offX, float offY) {
    float coorX = getAbsoluteCoordinatesFromMazeX(lootX, offX);
    float coorY = getAbsoluteCoordinatesFromMazeY(lootY, offY);
    
    colorMode(HSB);
    fill(getColor());
    circle(coorX, coorY, getSize());
    colorMode(RGB);
    
    t+=0.03;
  }
  
  float getSize() {
    switch (lootType) {
      case 2: return 9;
    }
    return 0;
  }
  
  color getColor () {
    switch (lootType) {
      case 2: return color((cos(t)+1)*255/2, 255, 255);
    }
    return color(0);
  }
}
