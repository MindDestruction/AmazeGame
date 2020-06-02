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
   - Taschenlampe
   -  mehrere Hinweise
   - Ein Zug aussetzten
   - Sounds
*/

// Einstellungen
int currentPlayer = 0;
int maxPlayer = 2;
float tileSize = 35;
float tileRadius = 6;
float tileGap = 2;
float playerBreatheIntensity = 1.5;
float playerBreatheSpeed = 2.5;
float playerSpeed = 0.18;
float playerInitialSize = tileSize / 2f;
float currentBackgroundVolume = 0;
float volumeFadeSpeed = 0.001;
float maxVolume = 0.8;
boolean showingMenu = true;
color[] playerColors = { color(0, 102, 153), color(183, 21, 64) };
String[] playerNames = {"Bjørn", "Alfhild"};
int playerWon = -1;
HashMap<String, Integer> treasure = new HashMap<String, Integer>() {{
    put("hint", 2);
    put("movingWall", 3);
    put("blindness", 4);
    put("randomPerk", 5); // ...
}};

Menu menu = new Menu();
PFont zorque;
Maze[] mazes = new Maze[2];
SoundFile swoosh, currentBackgroundMusic, menutoggle;
SoundFile[] backgroundMusic = new SoundFile[3];

void setup() {
  size(1280, 720);
  //fullScreen();
  frameRate(30);
  
  zorque = createFont("assets/zorque.ttf", 32);
  textFont(zorque);
  
  swoosh = new SoundFile(this, "assets/swoosh.wav");
  menutoggle = new SoundFile(this, "assets/menutoggle.wav");
  backgroundMusic[0] = new SoundFile(this, "assets/music1.wav");
  backgroundMusic[1] = new SoundFile(this, "assets/music2.wav");
  backgroundMusic[2] = new SoundFile(this, "assets/music3.wav");
  
  initGame();
  showingMenu = true;
}

void initGame() {
  mazes[0] = new Maze(Samples.maze0, Samples.startX0, Samples.startY0, Samples.startX0, Samples.startY0, Samples.endX0, Samples.endY0, tileSize, playerInitialSize);
  mazes[1] = new Maze(Samples.maze0, Samples.startX0, Samples.startY0, Samples.startX0, Samples.startY0, Samples.endX0, Samples.endY0, tileSize, playerInitialSize);
  playerWon = -1;
}

void draw() {
  background(30, 39, 46);
  translate(width/2, height/2);
  noStroke();
  
  mazes[0].draw(-550, -180, tileRadius, tileGap, playerColors[0]);
  mazes[1].draw(80, -180, tileRadius, tileGap, playerColors[1]);
  
  // Das fügt dunkelheit ins spiel ein
  applyAreaFilter(mazes[currentPlayer].getPlayerPositionX(), mazes[currentPlayer].getPlayerPositionY(), 0.25, showingMenu? 0 : 1.8);
  breathePlayer();
  if (showingMenu) menu.drawMenu();
  if (playerWon >= 0) menu.drawWon(playerNames[currentPlayer], playerColors[currentPlayer]);
  
  manageBackgroundMusic();
  
  //if (frameCount % 30 == 0) println(frameRate, " FPS");
}

// Wenn eine Taste gedrückt wurde
void keyPressed() {
  if (mazes[currentPlayer].animation) return;
  switch (key) {
    case 'w': mazes[currentPlayer].sprintPlayer('n'); break;
    case 's': mazes[currentPlayer].sprintPlayer('s'); break;
    case 'a': mazes[currentPlayer].sprintPlayer('w'); break;
    case 'd': mazes[currentPlayer].sprintPlayer('o'); break;
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

// Das ist die Musik Logik
void manageBackgroundMusic() {  
  if (currentBackgroundVolume<=maxVolume)
    currentBackgroundVolume += volumeFadeSpeed;
  
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
