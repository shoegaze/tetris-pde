public class STetronimo extends Tetronimo {
  public STetronimo() {
    super(new Position(1.5f, 1.5f));
  }

  public boolean[][] getMask() {
    return new boolean[][] {
      {false, true,  false},
      {false, true,  true},
      {false, false, true}
    };
  }
}