import java.util.ArrayList;

public abstract class Tetronimo {
  private Position pivot;
  private ArrayList<Position> positions;

  public abstract boolean[][] getMask();

  public Tetronimo(Position pivot) {
    this.pivot = pivot;
    this.positions = new ArrayList<Position>();
    boolean[][] mask = getMask();

    for (int i = 0; i < mask.length; ++i) {
      for (int j = 0; j < mask[0].length; ++j) {
        if (mask[i][j]) {
          positions.add(new Position(i + 0.5f, j + 0.5f));
        }
      }
    }
  }

  public Position getPivot() {
    return pivot;
  }

  public ArrayList<Position> getPositions() {
    return positions;
  }

  public void rotateCCW() {
    for (int i = 0; i < positions.size(); ++i) {
      final Position o = pivot;
      final Position p = positions.get(i);
      final Position q = new Position(p.x - o.x, p.y - o.y);

      positions.set(i, new Position(-q.y + o.x, q.x + o.y));
    }
  }

  public void rotateCW() {
    for (int i = 0; i < positions.size(); ++i) {
      final Position o = pivot;
      final Position p = positions.get(i);
      final Position q = new Position(p.x - o.x, p.y - o.y);

      positions.set(i, new Position(q.y + o.x, -q.x + o.y));
    }
  }
}