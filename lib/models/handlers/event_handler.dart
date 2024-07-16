import 'package:flowlinkapp/services/google_auth_service.dart';
import 'abstract_handler.dart';

class EventHandler extends Handler {
  late GoogleAuthService _googleAuthService;

  EventHandler(GoogleAuthService googleAuthService) {
    _googleAuthService = googleAuthService;
  }

  @override
  void handle(Map<String, dynamic> response) {
    if(response.containsKey('event')) {
      //TODO
    } else {
      super.handle(response);
    }
  }
}