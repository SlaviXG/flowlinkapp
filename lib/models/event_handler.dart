import 'abstract_handler.dart';

class EventHandler extends Handler {
  @override
  void handle(Map<String, dynamic> response) {
    if(response.containsKey('event')) {

      // TODO:
      print("Processing event!");
      
    } else {
      super.handle(response);
    }
  }
}