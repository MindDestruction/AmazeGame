import java.util.Arrays;
/*
  IDEEN:
   - Sich bewegende Wände
   - Taschenlampe
   - Hinweise
   - Ein Zug aussetzten
   - Sounds
*/

// Einstellungen
int currentPlayer = 0;
int maxPlayer = 2;
float tileSize = 25;
float tileRadius = 6;
float tileGap = 2;
float playerBreatheIntensity = 1.5;
float playerBreatheSpeed = 2.5;
float playerInitialSize = tileSize / 2f;
color[] playerColors = new color[]{color(106, 137, 204), color(183, 21, 64)};

Maze[] mazes = new Maze[2];

void setup() {
  size(1000, 500);
  frameRate(30);
  
  mazes[0] = new Maze(Samples.maze0, Samples.startX0, Samples.startY0, Samples.startX0, Samples.startY0, Samples.endX0, Samples.endY0, tileSize, playerInitialSize);
  mazes[1] = new Maze(Samples.maze0, Samples.startX0, Samples.startY0, Samples.startX0, Samples.startY0, Samples.endX0, Samples.endY0, tileSize, playerInitialSize);
}

void draw() {
  background(30, 39, 46);
  translate(width/2, height/2);
  noStroke();
  
  mazes[0].draw(-450, -150, tileRadius, tileGap, playerColors[0]);
  mazes[1].draw(100, -150, tileRadius, tileGap, playerColors[1]);
  
  // Das fügt dunkelheit ins spiel ein
  applyAreaFilter(mazes[currentPlayer].getPlayerPositionX(), mazes[currentPlayer].getPlayerPositionY(), 0.25, 1.8);
  breathePlayer();
}

// Wenn eine Taste gedrückt wurde
void keyPressed() {
  switch (key) {
    case 'w': mazes[currentPlayer].sprintPlayer('n'); break;
    case 's': mazes[currentPlayer].sprintPlayer('s'); break;
    case 'a': mazes[currentPlayer].sprintPlayer('w'); break;
    case 'd': mazes[currentPlayer].sprintPlayer('o'); break;
    case ' ': currentPlayer = (currentPlayer+1)%maxPlayer;
  }
}

void breathePlayer() {
  mazes[currentPlayer].playerSize = playerInitialSize + playerBreatheIntensity*sin(playerBreatheSpeed*frameCount/20f);
}

// Das fügt dunkelheit ins spiel ein
void applyAreaFilter(float fx, float fy, float radius, float strength) {
  loadPixels();
  for (int i = 0; i < width*height; i++) {
    int x = i % width;
    int y = i / width;
    float f = (radius-(dist(fx+width/2, fy+height/2, x, y)/height))*strength;
    pixels[i] = color(red(pixels[i])*f, green(pixels[i])*f, blue(pixels[i])*f);
  }
  updatePixels();
}
