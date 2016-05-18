
class State {
  int sizeOfBoard;
  int numOfPiece;
  Block[][] board;//x axis is from left to right. y axis is from down to up.
  ArrayList<Block> whitePieces;
  ArrayList<Block> blackPieces;

  State(int sizeOfBoard) {
    this.sizeOfBoard = sizeOfBoard;
    this.numOfPiece = 2*(sizeOfBoard-2);
    whitePieces = new ArrayList<Block>();
    blackPieces = new ArrayList<Block>();
    board = new Block[sizeOfBoard][sizeOfBoard];

    //Initialize the board
    for (int i=0; i<sizeOfBoard; i++) {
      for (int j=0; j<sizeOfBoard; j++) {
        if (i>0 && i<sizeOfBoard-1 && (j==0 || j==sizeOfBoard-1)) {
          board[i][j] = new Block(i, j, 1);//Initialize black checker
          blackPieces.add(board[i][j]);
        } else if (j>0 && j<sizeOfBoard-1 && (i==0 || i==sizeOfBoard-1)) {
          board[i][j] = new Block(i, j, 0);//Initialize white checker
          whitePieces.add(board[i][j]);
        } else {
          board[i][j] = new Block(i, j, -1);//Initialize empty block
        }
      }
    }
    //Update the legal moves
    legalMove(0);
    legalMove(1);
  }

  State clone() {//return an exactly the same State and Blocks as this state.
    State newState = new State(sizeOfBoard);
    //Copy the board
    for (int i=0; i<sizeOfBoard; i++) {
      for (int j=0; j<sizeOfBoard; j++) {
        newState.board[i][j].setChecker(board[i][j].checker());
      }
    }
    //Copy whitePieces and blackPieces
    newState.whitePieces.clear();
    newState.blackPieces.clear();
    for (int i=0; i<whitePieces.size(); i++) {
      Block piece = whitePieces.get(i);
      newState.whitePieces.add(newState.board[piece.getX()][piece.getY()]);
    }
    for (int i=0; i<blackPieces.size(); i++) {
      Block piece = blackPieces.get(i);
      newState.blackPieces.add(newState.board[piece.getX()][piece.getY()]);
    }
    newState.legalMove(0);
    newState.legalMove(1);
    return newState;
  }

  ArrayList<Block> pieces(int Color) {
    ArrayList<Block> pieces = whitePieces;
    if (Color == 1) {
      pieces = blackPieces;
    }
    return pieces;
  }

  boolean move(int Color, int oldX, int oldY, int newX, int newY) {
    if (board[oldX][oldY].checker()==-1 || board[oldX][oldY].checker()!= Color) {
      //println("There is no such checker to move.");
      return false;
    } else if (Color==board[newX][newY].checker()) {
      //println("There is already a friendly checker at the destination.");
      return false;
    }
    if (board[oldX][oldY].inLegalMoves(newX, newY)) {
      Block oldPiece = board[oldX][oldY];
      Block newPiece = board[newX][newY];
      int checker = oldPiece.checker();
      if (checker==0) {
        whitePieces.remove(oldPiece);
        whitePieces.add(newPiece);
        if (board[newX][newY].checker()==1) {
          blackPieces.remove(newPiece);
        }
      } else if (checker==1) {
        blackPieces.remove(oldPiece);
        blackPieces.add(newPiece);  
        if (board[newX][newY].checker()==0) {
          whitePieces.remove(newPiece);
        }
      }
      oldPiece.setChecker(-1);
      newPiece.setChecker(checker);
      legalMove(0);
      legalMove(1);
      return true;
    } else {
      return false;
    }
  }


  //Calculate the legal moves of each play
  void legalMove(int Color) {
    ArrayList<Block> pieces = pieces(Color);
    for (int piece=0; piece<pieces.size(); piece++) {
      int x = pieces.get(piece).getX();
      int y = pieces.get(piece).getY();

      //Clear the legal moves
      pieces.get(piece).clearLegalMoves();

      //Horizontal
      int step=0; //The step of move equals the number of checkers on this line
      for (int row=0; row<sizeOfBoard; row++) {
        if (board[row][y].checker()!=-1) {
          step++;
        }
      }

      boolean canMove = false;
      //search rightward
      if (x+step<sizeOfBoard && board[x+step][y].checker()!=Color) {
        canMove = true;
        for (int row=x; row<x+step; row++) {
          if (board[row][y].checker()!=-1 && board[row][y].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x+step, y);
        }
      }

      //search leftward
      if (x-step>=0 && board[x-step][y].checker()!=Color) {
        canMove = true;
        for (int row=x; row>x-step; row--) {
          if (board[row][y].checker()!=-1 && board[row][y].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x-step, y);
        }
      }

      //Virtical
      step=0; //The step of move equals the number of checkers on this line
      for (int column=0; column<sizeOfBoard; column++) {
        if (board[x][column].checker()!=-1) {
          step++;
        }
      }

      canMove = false;
      //search upward
      if (y+step<sizeOfBoard && board[x][y+step].checker()!=Color) {
        canMove = true;
        for (int column=y; column<y+step; column++) {
          if (board[x][column].checker()!=-1 && board[x][column].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x, y+step);
        }
      }

      //search downward
      if (y-step>=0 && board[x][y-step].checker()!=Color) {
        canMove = true;
        for (int column=y; column>y-step; column--) {
          if (board[x][column].checker()!=-1 && board[x][column].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x, y-step);
        }
      }

      //Diagonal move
      //down left to upper right
      step=-1; //The step of move equals the number of checkers on this line
      //There will be a double count of step
      for (int i=0; x+i<sizeOfBoard && y+i<sizeOfBoard; i++) {//upper rightward
        if (board[x+i][y+i].checker()!=-1) {
          step++;
        }
      }
      for (int i=0; x-i>=0 && y-i>=0; i++) {//down leftward
        if (board[x-i][y-i].checker()!=-1) {
          step++;
        }
      }

      canMove = false;
      //search upper rightward
      if (x+step<sizeOfBoard && y+step<sizeOfBoard && board[x+step][y+step].checker()!=Color) {
        canMove = true;
        for (int i=0; i<step; i++) {
          if (board[x+i][y+i].checker()!=-1 && board[x+i][y+i].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x+step, y+step);
        }
      }

      //search down leftward
      if (x-step>=0 && y-step>=0 && board[x-step][y-step].checker()!=Color) {
        canMove = true;
        for (int i=0; i<step; i++) {
          if (board[x-i][y-i].checker()!=-1 && board[x-i][y-i].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x-step, y-step);
        }
      }

      //upper left to down right
      step=-1; //The step of move equals the number of checkers on this line
      //There will be a double count
      for (int i=0; x+i<sizeOfBoard && y-i>=0; i++) {//down rightward
        if (board[x+i][y-i].checker()!=-1) {
          step++;
        }
      }
      for (int i=0; x-i>=0 && y+i<sizeOfBoard; i++) {//upper leftward
        if (board[x-i][y+i].checker()!=-1) {
          step++;
        }
      }

      canMove = false;
      //search down rightward
      if (x+step<sizeOfBoard && y-step>=0 && board[x+step][y-step].checker()!=Color) {
        canMove = true;
        for (int i=0; i<step; i++) {
          if (board[x+i][y-i].checker()!=-1 && board[x+i][y-i].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x+step, y-step);
        }
      }

      //search upper leftward
      if (x-step>=0 && y+step<sizeOfBoard && board[x-step][y+step].checker()!=Color) {
        canMove = true;
        for (int i=0; i<step; i++) {
          if (board[x-i][y+i].checker()!=-1 && board[x-i][y+i].checker()!=Color) {
            canMove = false;
            break;
          }
        }
        if (canMove) {
          board[x][y].addLegalMove(x-step, y+step);
        }
      }
    }
  }

  ArrayList<Block> neighbors(Block piece) {
    ArrayList<Block> neighbors = new ArrayList<Block>();
    int x = piece.getX();
    int y = piece.getY();
    int Color = piece.checker();
    if (Color!=-1) {
      for (int i=-1; i<2; i++) {
        for (int j=-1; j<2; j++) {
          if (x+i>=0 && x+i<sizeOfBoard && y+j>=0 && y+j< sizeOfBoard && (x!=0 || y!=0)) {
            if (board[x+i][y+j].checker()==Color) {
              neighbors.add(board[x+i][y+j]);
            }
          }
        }
      }
    }
    return neighbors;
  }
  //Terminal test and return the winner
  int winner(int Color) {//Color denotes who made the last move
    if (Color==0) {
      if (wins(1)) {
        return 1;
      } else if (wins(0)) {
        return 0;
      }
    } else if (Color==1) {
      if (wins(0)) {
        return 0;
      } else if (wins(1)) {
        return 1;
      }
    }
    return -1;
  }

  int countPartition(int Color) {//0 is white, 1 is black
    ArrayList<Block> pieces = pieces(Color);
    int count = 0;
    for (int i=0; i<pieces.size(); i++) {
      if (!pieces.get(i).marked()) {
        pieces.get(i).mark();
        markNeighbor(pieces.get(i));
        count++;
      }
    }
    for (int i=0; i<pieces.size(); i++) {
      pieces.get(i).unmark();
    }
    //println("Count is ", count);
    return count;
  }

  boolean wins(int Color) { //0 is white, 1 is black
    if (Color==-1) {
      return false;
    }
    ArrayList<Block> pieces = pieces(Color);

    //if only one checker left then finish
    if (pieces.size()==1) {
      return true;
    } 

    Block piece = pieces.get(0);
    piece.mark();
    markNeighbor(piece);//Recursively mark all neibors of the selected piece

    //Check if there is any piece not marked yet
    boolean win = true;
    for (int i=0; i<pieces.size(); i++) {
      if (!pieces.get(i).marked()) {
        win = false;
        break;
      }
    }

    for (int i=0; i<pieces.size(); i++) {
      pieces.get(i).unmark();
    }

    return win;
  }

  void markNeighbor(Block piece) {
    ArrayList<Block> neighbors = neighbors(piece);
    for (int i=0; i<neighbors.size(); i++) {
      if (!neighbors.get(i).marked()) {
        neighbors.get(i).mark();
        markNeighbor(neighbors.get(i));
      }
    }
  }



  void printBoard() {
    for (int i=0; i<sizeOfBoard; i++) {
      for (int j=0; j<sizeOfBoard; j++) {
        if (board[i][j].checker()==-1) {
          print("* ");
        } else if (board[i][j].checker()==0) {
          print("W ");
        } else if (board[i][j].checker()==1) {
          print("B ");
        }
      }
      print("\n");
    }
  }

  void printLegalMove() {
    String[][] BOARD = new String[sizeOfBoard][sizeOfBoard];
    ArrayList<Block> pieces = whitePieces;
    for (int i=0; i<pieces.size(); i++) {
      int x = pieces.get(i).getX();
      int y = pieces.get(i).getY();
      for (int a=0; a<sizeOfBoard; a++) {
        for (int b=0; b<sizeOfBoard; b++) {
          BOARD[a][b] = "- ";
        }
      }

      BOARD[x][y] = "O ";
      println(x, y);
      Block piece = board[x][y];
      for (int j=0; j<piece.numOfLegalMoves(); j++) {
        println("Move", piece.legalMoveX(j), piece.legalMoveY(j));
        BOARD[piece.legalMoveX(j)][piece.legalMoveY(j)] = "X ";
      }
      for (int a=0; a<sizeOfBoard; a++) {
        for (int b=0; b<sizeOfBoard; b++) {
          print(BOARD[a][b]);
        }
        print("\n");
      }
      print("\n");
    }
  }
}