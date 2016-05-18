class GUI {//Everything related to drawing is implemented here
  int WIDTH, HEIGHT, sizeOfBoard, boardWidth, boardX, boardY, blockSize;
  Button[] difficulty, chooseColor;
  Button replay;
  String blackPlayerName = "";
  String whitePlayerName = "";
  GUI(int WIDTH, int HEIGHT, int boardWidth, int sizeOfBoard) {
    this.WIDTH = WIDTH;
    this.HEIGHT = HEIGHT;
    this.boardWidth =boardWidth;
    this.sizeOfBoard = sizeOfBoard;
    boardX = (WIDTH - boardWidth)/2;
    boardY = (HEIGHT - boardWidth)/2;
    blockSize = boardWidth / sizeOfBoard;

    difficulty = new Button[3];
    chooseColor = new Button[3];

    color buttonColor = (150);
    color textColor = (0);
    Button easy = new Button(WIDTH/2, HEIGHT*2/5, WIDTH/3, HEIGHT/12, 
      buttonColor, "EASY", textColor);
    Button medium = new Button(WIDTH/2, HEIGHT*3/5, WIDTH/3, HEIGHT/12, 
      buttonColor, "NORMAL", textColor);
    Button hard = new Button(WIDTH/2, HEIGHT*4/5, WIDTH/3, HEIGHT/12, 
      buttonColor, "HARD", textColor);

    difficulty[0] = easy;
    difficulty[1] = medium;
    difficulty[2] = hard;

    Button black = new Button(WIDTH/2, HEIGHT*2/5, WIDTH/3, HEIGHT/12, 
      buttonColor, "BLACK", textColor);
    Button white = new Button(WIDTH/2, HEIGHT*3/5, WIDTH/3, HEIGHT/12, 
      buttonColor, "WHITE", textColor);
    Button auto = new Button(WIDTH/2, HEIGHT*4/5, WIDTH/3, HEIGHT/12, 
      buttonColor, "AI vs AI", textColor);

    chooseColor[0] = black;
    chooseColor[1] = white;
    chooseColor[2] = auto;
    
    replay = new Button(WIDTH*4/5, HEIGHT*9/10, WIDTH/4, HEIGHT/12, 
      buttonColor, "REPLAY", textColor);
  } 

  void drawEmptyBoard() {
    pushMatrix();
    translate(boardX, boardY);
    rectMode(CORNER);
    int x=0;
    int y=0;
    noStroke();
    for (int i=0; i<(sizeOfBoard * sizeOfBoard); i++) {
      x = blockSize * (i%sizeOfBoard);
      y = blockSize * (i/sizeOfBoard);
      if (i/sizeOfBoard %2==0) {
        if (i%sizeOfBoard%2==0) {
          fill(200);
        } else {
          fill(150);
        }
      } else {
        if (i%sizeOfBoard%2==0) {
          fill(150);
        } else {
          fill(200);
        }
      }
      rect(x, y, blockSize, blockSize);
    }
    popMatrix();
  }

  void drawCheckers(State state) {
    //  State state = currentState;
    pushMatrix();
    translate(boardX + blockSize/2, boardY + blockSize/2);
    rectMode(CENTER);
    int x=0;
    int y=0;

    for (int i=0; i<sizeOfBoard; i++) {
      for (int j=0; j<sizeOfBoard; j++) {
        x = blockSize * i;
        y = blockSize * j;
        if (state.board[i][j].checker()!=-1) {
          if (state.board[i][j].checker()==0) {//white
            fill(255);
          } else if (state.board[i][j].checker()==1) {//black
            fill(0);
          }
          stroke(1);
          ellipse(x, y, blockSize*0.8, blockSize*0.8);
        }
      }
    }
    popMatrix();
  }

  void drawLegalMove(int X, int Y) {
    pushMatrix();
    translate(boardX + blockSize/2, boardY + blockSize/2);
    rectMode(CENTER);
    int x=0;
    int y=0;
    Block checker = currentState.board[X][Y];
    for (int i=0; i<checker.numOfLegalMoves(); i++) {
      x = blockSize * checker.legalMoveX(i);
      y = blockSize * checker.legalMoveY(i);
      noStroke();
      fill(0, 150, 255);
      ellipse(x, y, blockSize*0.2, blockSize*0.2);
    }
    popMatrix();
  }

  void selectBlock(int X, int Y, Player player, State state) {
    int x=X-boardX;
    int y=Y-boardY;
    if (x>=0 && y>=0 && x<=boardWidth && y<=boardWidth) {
      int i = x/blockSize;
      int j = y/blockSize;
      player.addPosition(state, i, j);
    }
  }

  void difficulty() {
    textAlign(CENTER, CENTER);
    textSize(HEIGHT/24);
    fill(255);
    String askDifficulty = "Please select the difficulty.";
    text(askDifficulty, WIDTH/2, HEIGHT/5);
    for (int i=0; i<difficulty.length; i++) {
      difficulty[i].drawButton();
    }
  }

  void chooseColor() {
    textAlign(CENTER, CENTER);
    textSize(HEIGHT/24);
    fill(255);
    String askColor1 = "Please select your color.";
    text(askColor1, WIDTH/2, HEIGHT/5);
    String askColor2 = "Black player moves first.";
    text(askColor2, WIDTH/2, HEIGHT/5 + HEIGHT/20);
    for (int i=0; i<chooseColor.length; i++) {
      chooseColor[i].drawButton();
    }
  }

  void showWinner(int winner) {
    String message="";
    if (winner==0) {
      message = "White player wins!";
    } else if (winner==1) {
      message = "Black player wins!";
    }
    textAlign(CENTER, CENTER);
    textSize(HEIGHT/24);
    fill(255);
    text(message, WIDTH*2/5, HEIGHT*9/10);
  }

  void initPlayers() {
    if (player[0].isHuman()) {
      whitePlayerName = "You";
    } else {
      whitePlayerName = "AI";
    }
    if (player[1].isHuman()) {
      blackPlayerName = "You";
    } else {
      blackPlayerName = "AI";
    }
  }

  void printInfo(){
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(HEIGHT/16);
    text("Lines of Action", WIDTH/2, HEIGHT/20);
    textSize(HEIGHT/50);
    text("Copyright © Xiangci Li 2016", WIDTH*4/5, HEIGHT*24/25);
  }

  void printPlayer() {
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(HEIGHT/36);
    text("Black: "+blackPlayerName, WIDTH*3/11, HEIGHT/8);
    text("White: "+whitePlayerName, WIDTH*8/11, HEIGHT/8);
  }
  
  void replay(){
    replay.drawButton();
  }
}