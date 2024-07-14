import 'package:flowlinkapp/services/google_auth_service.dart';
import 'abstract_handler.dart';

class TaskHandler extends Handler {
  late GoogleAuthService _googleAuthService;

  TaskHandler (GoogleAuthService googleAuthService) {
    _googleAuthService = googleAuthService;
  }

  @override
  void handle(Map<String, dynamic> response) {
    if(response.containsKey('note')) {
      print("Sending the event to Google Tasks!");
      _googleAuthService.createTask(response['note'], response['content']);
    } else {
      super.handle(response);
    }
  }
}