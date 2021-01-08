public class GameLogic {
  public static final int BOARD_WIDTH = 10;
  public static final int BOARD_HEIGHT = 20;

  private GameState state;
  private boolean[][] board = new boolean[BOARD_HEIGHT][BOARD_WIDTH];
  private Tetronimo activePiece;
  private Position activePosition;
  private Tetronimo swapPiece;
  private int score;

  private int lastGravity;
  private int gravityInterval;
  private float gravityMultiplier;

  public GameLogic() {
    this.lastGravity = millis();
    this.gravityInterval = 200;
    this.gravityMultiplier = 1.0f;

    restart();
  }

  public Tetronimo getActivePiece() {
    return activePiece;
  }

  public Tetronimo getSwapPiece() {
    return swapPiece;
  }

  public Position getActivePosition() {
    return activePosition;
  }

  public boolean getBlock(int i, int j) {
    return board[j][i];
  }

  public int getScore() {
    return score;
  }

  public GameState getState() {
    return state;
  }

  public void step(InputManager input) {
    processMessages(input);

    if (isGameOver()) {
      state = GameState.GAME_OVER;
    }
  }

  public void applyGravityIfReady() {
    if (state == GameState.IN_GAME) {
      int now = millis();

      if (now - lastGravity >= gravityInterval / gravityMultiplier) {
        activePosition.y++;

        if (isActiveColliding()) {
          activePosition.y--;

          deactivatePiece();
          tryLineClear();
          spawnNext();
        }

        gravityMultiplier = 1.0f;
        lastGravity = now;
      }
    }
  }


  private void restart() {
    state = GameState.IN_GAME;
    score = 0;
    swapPiece = null;

    for (int j = 0; j < BOARD_HEIGHT; ++j) {
      for (int i = 0; i < BOARD_WIDTH; ++i) {
        board[j][i] = false;
      }
    }

    spawnNext();
  }

  private void deactivatePiece() {
    for (Position p : activePiece.getPositions()) {
      Position q = new Position(activePosition.x + p.x, activePosition.y + p.y);

      // Make sure overflows are not errors
      if (q.y >= 0) {
        board[(int)q.y][(int)q.x] = true;
      }
    }

    activePiece = null;
    activePosition = null;
  }

  private void tryLineClear() {
    for (int j = BOARD_HEIGHT-1; j >= 0; --j) {
      boolean willClear = true;

      for (int i = 0; i < BOARD_WIDTH; ++i) {
        if (!getBlock(i, j)) {
          willClear = false;
          break;
        }
      }

      if (willClear) {
        for (int i = 0; i < BOARD_WIDTH; ++i) {
          board[j][i] = false;
        }

        score += 1;
      }
    }
  }

  private Tetronimo getRandomTetronimo() {
    int n = (int)random(7);

    if (n == 0) {
      return new ITetronimo();
    }
    else if (n == 1) {
      return new JTetronimo();
    }
    else if (n == 2) {
      return new LTetronimo();
    }
    else if (n == 3) {
      return new OTetronimo();
    }
    else if (n == 4) {
      return new STetronimo();
    }
    else if (n == 5) {
      return new ZTetronimo();
    }
    else {
      return new TTetronimo();
    }
  }

  private void spawnNext() {
    activePiece = getRandomTetronimo();
    activePosition = new Position(
      BOARD_WIDTH / 2,
      0
    );
  }

  private void trySwapPiece() {
    if (state == GameState.IN_GAME && activePiece != null) {
      if (swapPiece == null) {
        swapPiece = activePiece;
        spawnNext();
      }
      else {
        Tetronimo tmp = swapPiece;
        swapPiece = activePiece;
        activePiece = tmp;

        activePosition = new Position(
          BOARD_WIDTH / 2,
          0
        );
      }
    }
  }

  private void hardDrop() {
    if (state == GameState.IN_GAME && activePiece != null) {
      while (!isActiveColliding()) {
        activePosition.y++;
      }

      activePosition.y--;
      deactivatePiece();
      tryLineClear();
      spawnNext();
    }
  }

  private boolean isActiveColliding() {
    for (Position p : activePiece.getPositions()) {
      Position q = new Position(activePosition.x + p.x, activePosition.y + p.y);
      if (q.x < 0 || q.x > BOARD_WIDTH) {
        return true;
      }

      if (q.y < 0 || q.y > BOARD_HEIGHT) {
        return true;
      }

      // TODO: check board blocks
      if (getBlock((int)q.x, (int)q.y)) {
        return true;
      }
    }

    return false;
  }

  private boolean isGameOver() {
    int w2 = BOARD_WIDTH/2;
    return board[0][w2] && board[0][w2+1];
  }

  private void processMessages(InputManager input) {
    Message msg = input.popMessageOrNull();
    while (msg != null) {
      processMessage(msg);

      msg = input.popMessageOrNull();
    }
  }

  private void processMessage(Message msg) {
    if (msg == Message.TOGGLE_PAUSE) {
      if (state == GameState.IN_GAME) {
        state = GameState.PAUSED;
      }
      else if (state == GameState.PAUSED) {
        state = GameState.IN_GAME;
      }
    }

    if (msg == Message.RESTART) {
      restart();
    }

    if (state == GameState.IN_GAME && activePiece != null) {
      switch (msg) {
        case MOVE_LEFT:
          activePosition.x--;

          if (isActiveColliding()) {
            activePosition.x++;
          }
          break;

        case MOVE_RIGHT:
          activePosition.x++;

          if (isActiveColliding()) {
            activePosition.x--;
          }
          break;

        case FAST_DROP:
          gravityMultiplier = 3.0f;
          break;

        case HARD_DROP:
          hardDrop();
          break;

        case ROTATE_CCW:
          activePiece.rotateCCW();

          if (isActiveColliding()) {
            activePiece.rotateCW();
          }
          break;

        case SWAP:
          trySwapPiece();
          break;

        default:
          break;
      }
    }
  }
}