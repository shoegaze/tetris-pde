InputManager input = new InputManager();
GameLogic logic = new GameLogic();
Drawer drawer = new Drawer(logic);

void setup() {
  size(300, 420);
}

void draw() {
  background(216);

  logic.step(input);
  logic.applyGravityIfReady();

  drawer.draw();
}

void keyPressed() {
  input.update(keyCode);
}
