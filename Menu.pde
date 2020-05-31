class Menu {
  
  void drawMenu() {
    fill(0, 102, 153, 245);
    
    textSize(50);
    text("A", -250, -50); 
    
    textSize(100);
    text("MAZE", -200, -50);
    
    textSize(50);
    text("ING", 100, -50); 
    
    textSize(100);
    text("GAME", -30, 50);
  }
  
  void drawWon(String player, color playerColor) {
    fill(playerColor);
    textSize(100);
    text(player, -200, -50); 
    text("WON", -100, 50); 
  }
}
