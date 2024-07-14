import 'abstract_handler.dart';

class NoteHandler extends Handler {
  @override
  void handle(Map<String, dynamic> response) {
    if(response.containsKey('note')) {
      
      //TODO:
      print("Sending event to Google Tasks!");
      
    } else {
      super.handle(response);
    }
  }
}