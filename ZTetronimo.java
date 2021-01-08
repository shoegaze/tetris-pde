public class ZTetronimo extends Tetronimo {
  public ZTetronimo() {
    super(new Position(1.5f, 1.5f));
  }

  public boolean[][] getMask() {
    return new boolean[][] {
      {false, false, true},
      {false, true,  true},
      {false, true,  false}
    };
  }
}