import java.util.Arrays;
import processing.sound.*;
/*
  STEUERUNG:
    w: Oben / Norden
    d: Rechts / Osten
    s: Unten / Süden
    a: Links / Westen
    m: Menü öffnen/schließen
    Leertaste: Spieler wechsel
  IDEEN:
   - Sich bewegende Wände
   - Taschenlampen (zeitlich)
   - Hinweise
   - Ein Zug aussetzten
   - Sounds
   - Weniger Sicht
   - Punkte (Item Kosten + Cooldown)
   - Icons
   - Musik leiser
   - Lichkegel durch Blickrichtung ersetzen
   - Tipps kosten
   - Züge Counter
   - Zug Timer
   - Game Timer
  Strategie:
   - Items
    - zu einander
    - unabhängig
   - Pfeile zueinander
*/

// Einstellungen
int currentPlayer = 0;
int maxPlayer = 2;

float tileSize = 35;
float tileRadius = 0;
float tileGap = 0;

float playerBreatheIntensity = 1.5;
float playerBreatheSpeed = 2.5;
float playerSpeed = 0.18;
float playerInitialSize = tileSize / 2f;
float currentBackgroundVolume = 0;
float volumeFadeSpeed = 0.001;
final float maxVolume = 0.4;

boolean showingMenu = true;
color[] playerColors = { color(0, 102, 153), color(183, 21, 64) };
String[] playerNames = {"Bjørn", "Alfhild"};
int playerWon = -1;
HashMap<String, Integer> treasure = new HashMap<String, Integer>() {{
    //  typeName,     typeId
    put("hint",       2);
    put("movingWall", 3);
    put("blindness",  4);
    put("randomPerk", 5); // ...
}};
Loot[] loot = {
  //        x, y, typeId
  new Loot(11, 1, 2), 
  new Loot(1,  8, 2)
};

Menu menu = new Menu();
PFont zorque;
Maze maze;
SoundFile swoosh, currentBackgroundMusic, menutoggle;
SoundFile[] backgroundMusic = new SoundFile[3];
Player[] players = new Player[2];

void setup() {
  size(1000, 1000);
  //fullScreen();
  //frameRate(30);
  
  zorque = createFont("assets/zorque.ttf", 32);
  textFont(zorque);
  
  swoosh = new SoundFile(this, "assets/swoosh.wav");
  menutoggle = new SoundFile(this, "assets/menutoggle.wav");
  backgroundMusic[0] = new SoundFile(this, "assets/music1.wav");
  backgroundMusic[1] = new SoundFile(this, "assets/music2.wav");
  backgroundMusic[2] = new SoundFile(this, "assets/music3.wav");
  
  swoosh.amp(maxVolume);
  menutoggle.amp(maxVolume);
  
  initGame();
}

void initGame() {
  players[0] = new Player(Samples.startXA0, Samples.startYA0, playerInitialSize, playerBreatheIntensity, playerBreatheSpeed);
  players[1] = new Player(Samples.startXB0, Samples.startYB0, playerInitialSize, playerBreatheIntensity, playerBreatheSpeed);
  maze = new Maze(Samples.maze0, Samples.endX0, Samples.endY0, tileSize);
  playerWon = -1;
  showingMenu = true;
}

void draw() {
  translate(width/2-maze.getPlayerPositionX(players[currentPlayer]), height/2-maze.getPlayerPositionY(players[currentPlayer]));
  noStroke();
  
  applyAreaFilter(0, 0, 0.25, showingMenu? 0 : 1.8);
  background(30, 39, 46);
  maze.draw(-width/2+100, (int)(-height/2f+(maze.sizeY*tileSize+maze.sizeY*tileGap)/2f), tileRadius, tileGap);
  
  // Das fügt dunkelheit ins spiel ein
  applyAreaFilter(maze.getPlayerPositionX(players[currentPlayer]), maze.getPlayerPositionY(players[currentPlayer]), 0.25, showingMenu? 0 : 1.8);
  breathePlayer();
  //applyAreaFilter(0, 0, 0.25, showingMenu? 0 : 1.8);
  //breathePlayer();
  if (showingMenu) menu.drawMenu();
  if (playerWon >= 0) menu.drawWon(playerNames[currentPlayer], playerColors[currentPlayer]);
  
  manageBackgroundMusic();
  
  if (frameCount % 30 == 0) println(frameRate, " FPS");
}

// Wenn eine Taste gedrückt wurde
void keyPressed() {
  switch (key) {
    case 'w': maze.sprintPlayer('n'); break;
    case 's': maze.sprintPlayer('s'); break;
    case 'a': maze.sprintPlayer('w'); break;
    case 'd': maze.sprintPlayer('o'); break;
    case 'm': 
      showingMenu = !showingMenu;
      menutoggle.play();
    break;
    case 'n': initGame(); break;
    case ' ': currentPlayer = (currentPlayer+1)%maxPlayer;
  }
}

// Macht den Spieler etwas kleiner und wieder etwas größer
void breathePlayer() {
  players[currentPlayer].size = players[currentPlayer].initialSize + players[currentPlayer].breatheIntensity*sin(players[currentPlayer].breatheSpeed*frameCount/20f);
}

// Das fügt dunkelheit ins spiel ein
void applyAreaFilter(float fx, float fy, float radius, float strength) {
  
  for (int x=0; x<maze.sizeX; x++) {
    for (int y=0; y<maze.sizeY; y++) {
      float dist = radius-dist(x, y, players[currentPlayer].playerX, players[currentPlayer].playerY)/Math.max(maze.sizeX, maze.sizeY);
      Samples.tileColors[y][x] = color(200, 200, 200, dist*255f*strength);
    }
  }
  
  /*loadPixels();
  for (int i = 0; i < width*height; i++) {
    int x = i % width;
    int y = i / width;
    float f = (radius-(dist(fx+width/2, fy+height/2, x, y)/height))*strength;
    pixels[i] = color(red(pixels[i])*f, green(pixels[i])*f, blue(pixels[i])*f);
  }
  updatePixels();*/
}

// Das ist die Musik Logik
void manageBackgroundMusic() {  
  if (currentBackgroundVolume<=maxVolume*0.3)
    currentBackgroundVolume += volumeFadeSpeed;
  if (currentBackgroundVolume > maxVolume*0.3) currentBackgroundVolume = maxVolume*0.3;
  
  if (frameCount % 100 == 0 && !isPlaying(backgroundMusic) || currentBackgroundMusic == null) {
    currentBackgroundMusic = backgroundMusic[int(random(backgroundMusic.length))];
    currentBackgroundMusic.amp(currentBackgroundVolume = 0);
    currentBackgroundMusic.play();
  }
  
  currentBackgroundMusic.amp(currentBackgroundVolume);
}

boolean isPlaying(SoundFile... files) {
  for (SoundFile file : files)
    if (file.isPlaying()) return true;
  return false;
}
