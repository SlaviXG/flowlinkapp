
abstract class Handler {
  Handler? _next;

  void setNext(Handler handler) {
    _next = handler;
  }

  void handle(Map<String, dynamic> response) {
    if(_next != null) {
      _next!.handle(response);
    }
  }
}