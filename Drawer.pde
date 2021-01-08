public class Drawer {
  private GameLogic logic;

  public Drawer(GameLogic logic) {
    this.logic = logic;
  }

  public void draw() {
    // Draw board
    for (int j = 0; j < GameLogic.BOARD_HEIGHT; ++j) {
      for (int i = 0; i < GameLogic.BOARD_WIDTH; ++i) {
        boolean b = logic.getBlock(i, j);

        noStroke();

        if (b) {
          fill(32);
        }
        else {
          fill(128);
        }

        int s = 20;
        rect((s + 1) * i, (s + 1) * j, s, s);
      }
    }

    { // Draw active piece
      Tetronimo active = logic.getActivePiece();

      if (active != null) {
        Position o = logic.getActivePosition();

        for (Position p : active.getPositions()) {
          noStroke();
          fill(32);

          int s = 20;
          rect(
            (s + 1) * (o.x + p.x - 0.5),
            (s + 1) * (o.y + p.y - 0.5),
            s,
            s
          );
        }
      }
    }

    { // Draw swap piece
      stroke(21);
      fill(128);
      rect(width - 76, 10, 60, 60);

      Tetronimo swap = logic.getSwapPiece();

      if (swap != null) {
        noStroke();
        fill(21);

        Position o = new Position(width - 60, 25);
        boolean[][] mask = swap.getMask();

        for (int j = 0; j < mask.length; ++j) {
          for (int i = 0; i <  mask[0].length; ++i) {
            if (mask[i][j]) {
              rect(
                o.x + (10 + 1) * j,
                o.y + (10 + 1) * i,
                10,
                10
              );
            }
          }
        }

        for (Position p : swap.getPositions()) {
          fill(32);

          float s = 0.5;

          println("x:" + (s + 1) * (o.x + p.x - 0.5));
          println("y:" + (s + 1) * (o.y + p.y - 0.5));

          rect(
            (s + 1) * (o.x + p.x - 0.5),
            (s + 1) * (o.y + p.y - 0.5),
            s,
            s
          );
        }
      }
    }

    { // Draw score
      fill(21);

      textSize(18);
      textAlign(CENTER);
      text("LINES", width - 48, height - 45);

      textSize(15);
      text(logic.score, width - 48, height - 20);
    }

    { // Draw pause screen
      if (logic.getState() == GameState.PAUSED) {
        noStroke();
        fill(180, 180, 180, 180);
        rect(0, 40, width, 80);

        fill(21);
        textSize(24);
        textAlign(CENTER);
        text("PAUSED", width/2, 90);
      }
    }

    { // Draw game over
      if (logic.getState() == GameState.GAME_OVER) {
        noStroke();
        fill(232, 12, 32);
        rect(0, 40, width, 80);

        fill(240);
        textSize(24);
        textAlign(CENTER);
        text("GAME OVER", width/2, 90);
      }
    }
  }
}