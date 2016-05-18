
class Player {
  int sizeOfBoard;
  boolean human; //if this player is human, then true
  int Color;//0 for white, 1 for black.
  int opponent;
  int cutoffDepth = 1000;// The maximum depth allowed
  long startTime;
  long threshold=10000;
  ArrayList<Integer> humanMove = new ArrayList<Integer>();
  ArrayList<int[]> AImoves = new ArrayList<int[]>();
  int[][] evaluationTable;//int[number of partition][number of total piece left]

  //Required stats
  ArrayList<Integer> maxDepth = new ArrayList<Integer>();
  int nodeExpanded = 0;
  int evaluationMax = 0;
  int evaluationMin = 0;
  int pruningMax = 0;
  int pruningMin = 0;

  Player(int sizeOfBoard, int Color, boolean human, int difficulty) {
    this.sizeOfBoard = sizeOfBoard;
    this.Color = Color;
    this.human = human;

    if (difficulty==0) {
      cutoffDepth = 1;
    } else if (difficulty==1) {
      cutoffDepth  = 10;
    } else if (difficulty==2) {
      cutoffDepth  = 1000;
    }

    if (Color==0) {
      opponent = 1;
    } else {
      opponent = 0;
    }
    
    if(!human){
      initEvaluation();
    }
  }
  
  void initEvaluation(){
    int size = (sizeOfBoard-2)*2-1;
    int totalRank = size*(size+1)/2 + 1;
    int rank = 1;
    evaluationTable = new int[size][size];
    for(int i=0; i<size; i++){
      for(int j=0; j<size; j++){
        if(i<=j){
          evaluationTable[i][j] = 100 - 200 * rank / totalRank;
          rank++;
        }
        else{
          evaluationTable[i][j] = 0;
        }
      }
    }
  }

  void addPosition(State state, int x, int y) {//for human
    if (human) {
      if (humanMove.size()==0 && state.board[x][y].checker()==Color) {
        humanMove.add(x);
        humanMove.add(y);
      } else if (humanMove.size()==2) {
        humanMove.add(x);
        humanMove.add(y);
      }
    }
  }

  boolean selected() {
    if (humanMove.size()==2) {
      return true;
    }
    return false;
  }
  
  boolean isHuman(){
    return human;
  }

  int getX() {
    return humanMove.get(0);
  }

  int getY() {
    return humanMove.get(1);
  }

  boolean move(State state) {
    if (human) {
      if (humanMove.size()==4) {
        if (state.move(Color, humanMove.get(0), humanMove.get(1), humanMove.get(2), humanMove.get(3))) {
          humanMove.clear();
          return true;
        } else {
          humanMove.clear();
        }
      }
    } else {//AI moves
      int moveIndex = alphaBetaSearch(state);
      startTime = millis();
      if (state.move(Color, AImoves.get(moveIndex)[0], AImoves.get(moveIndex)[1], 
        AImoves.get(moveIndex)[2], AImoves.get(moveIndex)[3])) {

        long finishTime = millis();
        if (finishTime - startTime < 500) {//Originally AI moves too fast
          delay(int(500-(finishTime - startTime)));
        }

        AImoves.clear();
        printStats();
        return true;
      }
    }
    return false;
  }

  int alphaBetaSearch(State state) {
    //In order to return an acition, mapping the utility value with each action is needed.
    //Thus this function "simulates" the first depth of maxValue() function.
    int alpha = -100;
    int beta = 100;
    int depth = 0; //The depth must be 0 when this function is called.
    int v=-10000;

    ArrayList<Block> pieces = state.pieces(Color);
    nodeExpanded++;
    for (int i=0; i<pieces.size(); i++) {
      Block piece = pieces.get(i);
      int oldX = piece.getX();
      int oldY = piece.getY();
      for (int j=0; j<piece.numOfLegalMoves(); j++) {
        State newState = state.clone();//clone a new state
        int newX = piece.legalMoveX(j);
        int newY = piece.legalMoveY(j);
        int[] move = new int[5];
        move[0] = oldX;
        move[1] = oldY;
        move[2] = newX;
        move[3] = newY;
        newState.move(Color, oldX, oldY, newX, newY);
        move[4] = minValue(newState, alpha, beta, depth+1);
        v = max(v, move[4]);
        alpha = max(alpha, v);
        AImoves.add(move);
      }
    }
    v=-10000;
    int maxIndex = 0;
    for (int i=0; i<AImoves.size(); i++) {
      if (AImoves.get(i)[4]>v) {
        v = AImoves.get(i)[4];
        maxIndex = i;
      }
    }

    return maxIndex;
  }

  int maxValue(State state, int alpha, int beta, int depth) {
    nodeExpanded++;
    int v; //oldX,oldY,newX,newY,utility
    //Terminal-Test and returning utility
    int winner = state.winner(opponent);

    if (winner == Color) {
      v = 100;
      maxDepth.add(depth);
      return v;
    } else if (winner == opponent) {
      v = -100;
      maxDepth.add(depth);
      return v;
    }
    if (cutoffTest(depth)) {
      maxDepth.add(depth);
      evaluationMax++;
      return evaluation(state);
    }
    v = -10000;// -INFINITY  
    ArrayList<Block> pieces = state.pieces(Color);
    for (int i=0; i<pieces.size(); i++) {
      Block piece = pieces.get(i);
      int oldX = piece.getX();
      int oldY = piece.getY();
      for (int j=0; j<piece.numOfLegalMoves(); j++) {
        State newState = state.clone();//clone a new state
        int newX = piece.legalMoveX(j);
        int newY = piece.legalMoveY(j);
        newState.move(Color, oldX, oldY, newX, newY);
        int minV = minValue(newState, alpha, beta, depth+1);
        if (minV>v) {
          v = minV;
        }
        if (v>=beta) {
          pruningMax++;
          return v;
        }
        alpha = max(alpha, v);
      }
    }
    return v;
  }

  int minValue(State state, int alpha, int beta, int depth) {
    nodeExpanded++;
    int v;
    //Terminal-Test and returning utility
    int winner = state.winner(Color);
    if (winner == Color) {
      v=100;
      maxDepth.add(depth);
      return v;
    } else if (winner == opponent) {
      v = -100;
      maxDepth.add(depth);
      return v;
    }
    if (cutoffTest(depth)) {
      maxDepth.add(depth);
      evaluationMin++;
      return evaluation(state);
    }
    v = 10000;// -INFINITY  
    ArrayList<Block> pieces = state.pieces(opponent);
    for (int i=0; i<pieces.size(); i++) {
      Block piece = pieces.get(i);
      int oldX = piece.getX();
      int oldY = piece.getY();
      for (int j=0; j<piece.numOfLegalMoves(); j++) {
        State newState = state.clone();//clone a new state
        int newX = piece.legalMoveX(j);
        int newY = piece.legalMoveY(j);
        newState.move(opponent, oldX, oldY, newX, newY);
        int maxV = maxValue(newState, alpha, beta, depth+1);
        if (maxV<v) {
          v = maxV;
        }
        if (v<=alpha) {
          pruningMin++;
          return v;
        }
        beta = min(alpha, v);
      }
    }
    return v;
  }

  boolean cutoffTest(int depth) {
    long currentTime = millis();

    if (currentTime - startTime >= threshold) {
      return true;
    } else if (depth >= cutoffDepth) {
      return true;
    }
    return false;
  }

  int evaluation(State state) {
    int partition = state.countPartition(Color);
    int v = evaluationTable[partition-2][state.pieces(Color).size()-2];
    return v;
  }

  void printStats() {
    int depth = 0;
    for (int i=0; i<maxDepth.size(); i++) {
      if (maxDepth.get(i)>depth) {
        depth = maxDepth.get(i);
      }
    }
    println("The maximum depth of game tree reached is ", depth, ".");
    println("Total number of nodes generated in the tree is ", nodeExpanded, ".");
    println("The number of times the evaluation function was called within the MAX-VALUE function is ", evaluationMax, ".");   
    println("The number of times the evaluation function was called within the MIN-VALUE function is ", evaluationMin, ".");
    println("The number of times pruning occurred within the MAX-VALUE function is ", pruningMax, ".");
    println("The number of times pruning occurred within the MIN-VALUE function is ", pruningMin, ".");
    println();
    maxDepth.clear();
    nodeExpanded = 0;
    evaluationMax = 0;
    evaluationMin = 0;
    pruningMax = 0;
    pruningMin = 0;
  }
}