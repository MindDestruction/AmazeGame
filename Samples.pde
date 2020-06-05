
// Wand = 1
// Gang = 0
static class Samples {
  
  static int startXA0 = 11;
  static int startYA0 = 9;
  static int startXB0 = 11;
  static int startYB0 = 5;
  static int endX0 = 1;
  static int endY0 = 0;
  static int[][] maze0 = new int[][]{
    {1,0,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,1,0,1,0,1,0,0,0,0,0,1},
    {1,0,1,0,0,0,1,0,1,1,1,0,1},
    {1,0,0,0,1,1,1,0,0,0,0,0,1},
    {1,0,1,0,0,0,0,0,1,1,1,0,1},
    {1,0,1,0,1,1,1,0,1,0,0,0,1},
    {1,0,1,0,1,0,0,0,1,1,1,0,1},
    {1,0,1,0,1,1,1,0,1,0,1,0,1},
    {1,0,0,0,0,0,0,0,0,0,1,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,0,1}
  };
  static color[][] tileColors = new color[maze0.length][maze0[0].length];
}
