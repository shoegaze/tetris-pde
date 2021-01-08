public class ITetronimo extends Tetronimo {
  public ITetronimo() {
    super(new Position(2.0f, 2.0f));
  }

  public boolean[][] getMask() {
    return new boolean[][] {
      {false, false, true, false},
      {false, false, true, false},
      {false, false, true, false},
      {false, false, true, false}
    };
  }
}