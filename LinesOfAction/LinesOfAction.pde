int sizeOfBoard = 6;
int boardWidth;
int difficulty;//0 is easy, 1 is medium, 2 is hard
//game States: 0 for difficulty, 1 for choosing color, 2 for playing, 3 for finish 
int gameState = 0;
int turn=1; //Which color's turn? Start from black's turn
int winner=-1;
GUI game;
State currentState;
Player[] player = new Player[2];

void setup() {
  size(480, 640);
  boardWidth = 440;
  game = new GUI(width, height, boardWidth, sizeOfBoard);
  currentState = new State(sizeOfBoard);
}
void draw() {
  background(0);
  if (gameState==0) {
    game.printInfo();
    game.difficulty();
  } else if (gameState==1) {
    game.printInfo();
    game.chooseColor();
  } else if (gameState==2) {//play starts
    game.printInfo();
    game.printPlayer();
    game.drawEmptyBoard();
    game.drawCheckers(currentState);
    
    if (player[turn].selected()) {
      game.drawLegalMove(player[turn].getX(), player[turn].getY());
    }
    if (player[turn].move(currentState)) {
      winner = currentState.winner(turn);
      if (winner!=-1) {
        gameState++;
      }
      if (turn==0) {
        turn++;
      } else if (turn==1) {
        turn--;
      }
    }
  } else if (gameState==3) {
    game.printInfo();
    game.printPlayer();
    game.drawEmptyBoard();
    game.drawCheckers(currentState);
    game.showWinner(winner);
    game.replay();
  }
}

void mousePressed() {
  if (gameState==0) {
    if (game.difficulty[0].click(mouseX, mouseY)) {//easy
      difficulty = 0;
      println("Easy mode");
      gameState++;
    } else if (game.difficulty[1].click(mouseX, mouseY)) {//medium
      difficulty = 1;
      println("Normal mode");
      gameState++;
    } else if (game.difficulty[2].click(mouseX, mouseY)) {//hard
      difficulty = 2;
      println("Hard mode");
      gameState++;
    }
  } else if (gameState==1) {
    if (game.chooseColor[0].click(mouseX, mouseY)) {//black
      player[1] = new Player(sizeOfBoard,1, true, difficulty);
      player[0] = new Player(sizeOfBoard,0, false, difficulty);
      println("Black");
      gameState++;
    } else if (game.chooseColor[1].click(mouseX, mouseY)) {//white
      player[0] = new Player(sizeOfBoard,0, true, difficulty);
      player[1] = new Player(sizeOfBoard,1, false, difficulty);
      println("White");

      gameState++;
    } else if (game.chooseColor[2].click(mouseX, mouseY)) {//black
      player[0] = new Player(sizeOfBoard,0, false, difficulty);
      player[1] = new Player(sizeOfBoard,1, false, difficulty);
      println("AI vs AI");

      gameState++;
    }
    game.initPlayers();
  } else if (gameState==2) {
    game.selectBlock(mouseX, mouseY, player[turn], currentState);
  } else if (gameState==3){
    if (game.replay.click(mouseX, mouseY)) {//replay
      resetGame();
    }
  }
}

void resetGame(){
  gameState = 0;
  winner = -1;
  turn = 1;
  
  game = new GUI(width, height, boardWidth, sizeOfBoard);
  currentState = new State(sizeOfBoard);
}