class Maze {
  
  int[][] maze;
  int playerX, playerY, oldPlayerX, oldPlayerY, sizeX, sizeY, startX, startY, endX, endY;
  boolean animation = false;
  boolean animationStart = false;
  boolean positionActionTriggered = false;
  float oldplayerCoordX; 
  float oldplayerCoordY;
  float playerCoordX;
  float playerCoordY;
  float speedX = 0.1;
  float speedY = 0.1;
  float tileSize;
  float playerSize;
  
  // Erstelle das Labyrinth
  public Maze(int[][] maze, int playerX, int playerY, int startX, int startY, int endX, int endY, float tileSize, float playerInitialSize) {
    this.maze = maze;
    this.playerX = this.oldPlayerX = playerX;
    this.playerY = this.oldPlayerY = playerY;
    this.startX = startX;
    this.startY = startY;
    this.endX = endX;
    this.endY = endY;
    this.tileSize = tileSize;
    this.playerSize = playerInitialSize;
    this.sizeY = maze.length;
    this.sizeX = maze[0].length;
  }
  
  // Bewege Spieler in eine Richtung bis es nicht mehr geht
  void sprintPlayer(char dir) {
    boolean start = true;
    int tempoldPlayerX = playerX;
    int tempoldPlayerY = playerY;
    
    // Bewege den Spieler solange bis er anhalten muss (wegen Wand, Kreuzung, Ende, etc.)
    while (movePlayer(dir, start)) {
      start = false;
      positionActionTriggered = true;
    }
    
    // Wenn der Spieler sich nicht bewegt hat, sollen die Koordinaten den letzten Zuges nicht geändert werden
    if (tempoldPlayerY != playerY || tempoldPlayerX != playerX) {
      this.oldPlayerX = tempoldPlayerX;
      this.oldPlayerY = tempoldPlayerY;
      animation = animationStart = true;
    }
  }
  
  // Bewege Spieler ein Feld
  // Gibt true zurück wenn der Spieler sich bewegen konnte (wegen Wände und Grenzen)
  boolean movePlayer(char dir, boolean start) {
    
    // Wenn der Spieler an einer Kreuzung ist. Einmal halten bitte!
    if (isCrossing(playerX, playerY, dir) && !start) return false;
    
    // Wenn vor dem Spieler eine Wand ist. Einmal halten bitte!
    if (isWallUpfront(dir)) return false;
    
    // Bewege Spieler in die angegebene Richtung (Nord, West, Ost, Süd)
    switch (dir) {
      case 'n': playerY--; break;
      case 'w': playerX--; break;
      case 'o': playerX++; break;
      case 's': playerY++; break;
    }
    return true;
  }
  
  // Überprüft ob vor dem Spieler eine Wand ist
  boolean isWallUpfront(char dir) {
    switch (dir) {
      case 'n': return !(playerY-1 >= 0 && maze[playerY-1][playerX] == 0);
      case 'w': return !(playerX-1 >= 0 && maze[playerY][playerX-1] == 0);
      case 'o': return !(playerX+1 < sizeX && maze[playerY][playerX+1] == 0);
      case 's': return !(playerY+1 < sizeY && maze[playerY+1][playerX] == 0);
    }
    return true;
  }
  
  // Überprüft ob an der Stelle (x, y) eine Kreuzung ist
  boolean isCrossing(int x, int y, char cameFrom) {
    switch (cameFrom) {
      case 'n': case 's': return (withinMaze(x+1, y) && maze[y][x+1] == 0) || (withinMaze(x-1, y) && maze[y][x-1] == 0);
      case 'w': case 'o': return (withinMaze(x, y+1) && maze[y+1][x] == 0) || (withinMaze(x, y-1) && maze[y-1][x] == 0);
    }
    return false;
  }
  
  // Überprüft ob die Koordinaten im Labyrinth sind
  boolean withinMaze(int x, int y) {
    return x>=0 && x<sizeX && y>=0 && y<sizeY;
  }
  
  // Zeichnet den Spieler
  void drawPlayer(int X, int Y, color playerColor) {
    
    // Wenn animiert wird, sollen die Koordinaten nicht immer zurückgesetzt werden
    if (animationStart || !animation) {
      animationStart = false;
      playerCoordX = (playerX+1)*tileSize + X + 2*playerX - tileSize/2;
      playerCoordY = (playerY+1)*tileSize + Y + 2*playerY - tileSize/2;
      oldplayerCoordX = (oldPlayerX+1)*tileSize + X + 2*oldPlayerX - tileSize/2;
      oldplayerCoordY = (oldPlayerY+1)*tileSize + Y + 2*oldPlayerY - tileSize/2;
    }
    
    // Ändere Koordinaten um ein kleines Stückchen (Animation)
    if (animation) {
      oldplayerCoordX -= (oldplayerCoordX - playerCoordX)*speedX;
      oldplayerCoordY -= (oldplayerCoordY - playerCoordY)*speedY;
    }
    
    // Zeichne den Spieler
    fill(playerColor);
    circle(getPlayerPositionX(), getPlayerPositionY(), playerSize);
    
    // Wenn Spieler den Zug beendet hat (Beende die Animation)
    if (Math.abs(oldplayerCoordX-playerCoordX)<0.3 && Math.abs(oldplayerCoordY-playerCoordY)<0.3) {
      animation = false;
    }
  }
  
  // Zeichne das Labyrinth & den Spieler
  void draw(int X, int Y, float tileRadius, float tileGap, color playerColor) {
    fill(200);
    for (int x=0; x<sizeX; x++) {
      for (int y=0; y<sizeY; y++) {
        if (maze[y][x] == 0) continue;
        float coordX = x*tileSize + X + tileGap*x;
        float coordY = y*tileSize + Y + tileGap*y;
        rect(coordX, coordY, tileSize, tileSize, tileRadius);
      }
    }
    
    // Zeichne den Spieler
    drawPlayer(X, Y, playerColor);
  }
  
  float getPlayerPositionX() {
    return animation? oldplayerCoordX:playerCoordX;
  }
  
  float getPlayerPositionY() {
    return animation? oldplayerCoordY:playerCoordY;
  }
}
