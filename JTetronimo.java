public class JTetronimo extends Tetronimo {
  public JTetronimo() {
    super(new Position(1.5f, 1.5f));
  }

  public boolean[][] getMask() {
    return new boolean[][] {
      {false, true, false},
      {false, true, false},
      {true,  true, false}
    };
  }
}