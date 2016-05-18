class Button{
  int x, y, WIDTH, HEIGHT;
  String text;
  color textColor, buttonColor;
  Button(int x, int y, int WIDTH, int HEIGHT, color buttonColor, String text, color textColor){
    this.x = x;
    this.y = y;
    this.WIDTH = WIDTH;
    this.HEIGHT = HEIGHT;
    this.buttonColor = buttonColor;
    this.text = text;
    this.textColor =textColor;
  }
  
  void drawButton(){
    rectMode(CENTER);
    fill(buttonColor);
    noStroke();
    rect(x,y,WIDTH, HEIGHT);
    textAlign(CENTER,CENTER);
    textSize(HEIGHT/2);
    fill(textColor);
    text(text, x, y);
  }
  
  boolean click(int X, int Y){
    return(X>(x-WIDTH/2) && X<(x+WIDTH/2) && Y>(y-HEIGHT/2) && Y<(y+HEIGHT/2));
  }
}