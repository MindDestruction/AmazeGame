

class Maze {
  
  int[][] maze;
  int playerX, playerY, oldPlayerX, oldPlayerY, sizeX, sizeY, endX, endY;
  boolean positionActionTriggered = false;
  float oldplayerCoordX; 
  float oldplayerCoordY;
  float playerCoordX;
  float playerCoordY;
  float tileSize;
  Loot[] loot = {
    new Loot(11, 1, 2),
    new Loot(1, 8, 2)
  };
  
  // Erstelle das Labyrinth
  public Maze(int[][] maze, int endX, int endY, float tileSize) {
    this.maze = maze;
    this.endX = endX;
    this.endY = endY;
    this.tileSize = tileSize;
    this.sizeY = maze.length;
    this.sizeX = maze[0].length;
  }
  
  // Bewege Spieler in eine Richtung bis es nicht mehr geht
  void sprintPlayer(char dir) {
    boolean start = true;
    int tempoldPlayerX = players[currentPlayer].playerX;
    int tempoldPlayerY = players[currentPlayer].playerY;
    
    // Bewege den Spieler solange bis er anhalten muss (wegen Wand, Kreuzung, Ende, etc.)
    while (movePlayer(dir, start)) {
      start = false;
      positionActionTriggered = true;
    }
    
    // Wenn der Spieler sich nicht bewegt hat, sollen die Koordinaten den letzten Zuges nicht geändert werden
    if (tempoldPlayerY != players[currentPlayer].playerY || tempoldPlayerX != players[currentPlayer].playerX) {
      players[currentPlayer].oldPlayerX = tempoldPlayerX;
      players[currentPlayer].oldPlayerY = tempoldPlayerY;
      players[currentPlayer].animation = players[currentPlayer].animationStart = true;
      swoosh.play();
    }
  }
  
  // Bewege Spieler ein Feld
  // Gibt true zurück wenn der Spieler sich bewegen konnte (wegen Wände und Grenzen)
  boolean movePlayer(char dir, boolean start) {
    
    // Wenn der Spieler an einer Kreuzung ist. Einmal halten bitte!
    if (isCrossing(players[currentPlayer].playerX, players[currentPlayer].playerY, dir) && !start) return false;
    
    // Wenn vor dem Spieler eine Wand ist. Einmal halten bitte!
    if (isWallUpfront(dir)) return false;
    
    // Bewege Spieler in die angegebene Richtung (Nord, West, Ost, Süd)
    switch (dir) {
      case 'n': players[currentPlayer].playerY--; break;
      case 'w': players[currentPlayer].playerX--; break;
      case 'o': players[currentPlayer].playerX++; break;
      case 's': players[currentPlayer].playerY++; break;
    }
    return true;
  }
  
  // Überprüft ob vor dem Spieler eine Wand ist
  boolean isWallUpfront(char dir) {
    switch (dir) {
      case 'n': return !(players[currentPlayer].playerY-1 >= 0 && maze[players[currentPlayer].playerY-1][players[currentPlayer].playerX] == 0);
      case 'w': return !(players[currentPlayer].playerX-1 >= 0 && maze[players[currentPlayer].playerY][players[currentPlayer].playerX-1] == 0);
      case 'o': return !(players[currentPlayer].playerX+1 < sizeX && maze[players[currentPlayer].playerY][players[currentPlayer].playerX+1] == 0);
      case 's': return !(players[currentPlayer].playerY+1 < sizeY && maze[players[currentPlayer].playerY+1][players[currentPlayer].playerX] == 0);
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
  void drawPlayer(Player player, int X, int Y, color playerColor) {
    
    // Wenn animiert wird, sollen die Koordinaten nicht immer zurückgesetzt werden
    if (player.animationStart || !player.animation) {
      player.animationStart = false;
      player.pCoordX = (player.playerX+1)*tileSize + X + 2*player.playerX - tileSize/2;
      player.pCoordY = (player.playerY+1)*tileSize + Y + 2*player.playerY - tileSize/2;
      player.oldpCoordX = (player.oldPlayerX+1)*tileSize + X + 2*player.oldPlayerX - tileSize/2;
      player.oldpCoordY = (player.oldPlayerY+1)*tileSize + Y + 2*player.oldPlayerY - tileSize/2;
    }
    
    // Ändere Koordinaten um ein kleines Stückchen (Animation)
    if (player.animation) {
      player.oldpCoordX -= (player.oldpCoordX - player.pCoordX)*playerSpeed;
      player.oldpCoordY -= (player.oldpCoordY - player.pCoordY)*playerSpeed;
    } else {
      if (player.playerX == endX && player.playerY == endY) {
        playerWon = currentPlayer;
      }
    }
    
    // Zeichne den Spieler
    fill(playerColor);
    circle(getPlayerPositionX(player), getPlayerPositionY(player), player.size);
    
    // Wenn Spieler den Zug beendet hat (Beende die Animation)
    if (Math.abs(player.oldpCoordX-player.pCoordX)<0.3 && Math.abs(player.oldpCoordY-player.pCoordY)<0.3) {
      player.animation = false;
    }
  }
  
  void drawTreasure(int X, int Y) {
    for (Loot l : loot) {
      l.draw(X, Y);
    }
  }
  
  // Zeichne das Labyrinth & den Spieler
  void draw(int X, int Y, float tileRadius, float tileGap) {
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
    drawTreasure(X, Y);
    drawPlayer(players[(currentPlayer+1)%2], X, Y, playerColors[(currentPlayer+1)%2]);
    drawPlayer(players[currentPlayer], X, Y, playerColors[currentPlayer]);
  }
  
  float getPlayerPositionX(Player player) {
    return player.animation? player.oldpCoordX : player.pCoordX;
  }
  
  float getPlayerPositionY(Player player) {
    return player.animation? player.oldpCoordY : player.pCoordY;
  }
}

float getAbsoluteCoordinatesFromMazeX(int x, float offX) {
  return (x+1)*tileSize + offX + 2*x - tileSize/2;
}
  
float getAbsoluteCoordinatesFromMazeY(int y, float offY) {
  return (y+1)*tileSize + offY + 2*y - tileSize/2;
}
