class Block {//Each square of the board
  int checker; //The content of this block, -1 for empty, 0 for white, 1 for bloack
  int x, y; //The postion of this checker
  boolean mark=false;//used for neighbor searching
  ArrayList<int[]> legalMoves; //The legal moves of the checker of this content.
  //newX, newY, utility
  Block(int x, int y, int checker) {
    this.checker = checker;
    this.x = x;
    this.y = y;
    legalMoves = new ArrayList<int[]>();
  }

  void setChecker(int checker) {
    this.checker = checker;
    legalMoves.clear();
  }

  int checker() {
    return checker;
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  void addLegalMove(int x, int y) {
    int[] move = {x, y};
    legalMoves.add(move);
  }

  int numOfLegalMoves() {
    return legalMoves.size();
  }

  int legalMoveX(int i) {
    return legalMoves.get(i)[0];
  }

  int legalMoveY(int i) {
    return legalMoves.get(i)[1];
  }

  boolean inLegalMoves(int x, int y) {
    for (int i=0; i<numOfLegalMoves(); i++) {
      if (legalMoveX(i)==x && legalMoveY(i)==y) {
        return true;
      }
    }
    return false;
  }

  void clearLegalMoves() {
    legalMoves.clear();
  }

  void mark() {
    mark=true;
  }

  boolean marked() {
    return mark;
  }

  void unmark() {
    mark=false;
  }
}