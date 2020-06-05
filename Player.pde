class Player {
  
  int playerX, playerY, oldPlayerX, oldPlayerY, startX, startY;
  float size, initialSize, oldpCoordX, oldpCoordY, pCoordX, pCoordY;
  float breatheIntensity, breatheSpeed;
  public Player(int startX, int startY, float size, float breatheIntensity, float breatheSpeed) {
    
    this.startX = this.playerX = this.oldPlayerX = startX;
    this.startY = this.playerY = this.oldPlayerY = startY;
    this.size = this.initialSize = size;
    this.breatheIntensity = breatheIntensity;
    this.breatheSpeed = breatheSpeed;
    
    
  }
  
  
}
