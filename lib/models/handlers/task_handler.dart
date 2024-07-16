import 'package:flowlinkapp/services/google_auth_service.dart';
import 'abstract_handler.dart';

class TaskHandler extends Handler {
  late GoogleAuthService _googleAuthService;

  TaskHandler (GoogleAuthService googleAuthService) {
    _googleAuthService = googleAuthService;
  }

  @override
  void handle(Map<String, dynamic> response) {
    if(response.containsKey('task')) {
      response = response['task'];
      _googleAuthService.createTask(
        response['title'],
        notes: ((response['notes']!=null) ? (response['notes']) : (null)),
        dueDate: ((response['due_date']!=null) ? (response['due_date']) : (null)));
    } else {
      super.handle(response);
    }
  }
}