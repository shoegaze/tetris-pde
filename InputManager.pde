import java.util.Stack;
import java.util.Iterator;

public class InputManager {
  private Stack<Message> messages;

  public InputManager() {
    this.messages = new Stack<Message>();
  }

  public void update(int keyCode) {
    switch (keyCode) {
      case 'P':
        addMessage(Message.TOGGLE_PAUSE);
        break;

      case 'R':
        addMessage(Message.RESTART);
        break;

      case LEFT:
        addMessage(Message.MOVE_LEFT);
        break;

      case RIGHT:
        addMessage(Message.MOVE_RIGHT);
        break;

      case DOWN:
        addMessage(Message.FAST_DROP);
        break;

      case 'Z':
        addMessage(Message.ROTATE_CCW);
        break;

      case 'X':
        addMessage(Message.HARD_DROP);
        break;

      case 'C':
        addMessage(Message.SWAP);
        break;

      default:
        break;
    }

    // println("Message Stack:");
    // for (Message msg : messages) {
    //   println("> " + msg);
    // }
  }

  private void addMessage(Message msg) {
    messages.push(msg);
  }

  public Message popMessageOrNull() {
    return (!messages.empty())?
      messages.pop() : null;
  }
}