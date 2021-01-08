public class OTetronimo extends Tetronimo {
  public OTetronimo() {
    super(new Position(1.0f, 1.0f));
  }

  public boolean[][] getMask() {
    return new boolean[][] {
      {true, true},
      {true, true}
    };
  }
}