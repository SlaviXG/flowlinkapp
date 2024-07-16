import 'package:flowlinkapp/services/google_auth_service.dart';
import 'package:flowlinkapp/utils/datetime.dart';
import 'abstract_handler.dart';

class EventHandler extends Handler {
  late GoogleAuthService _googleAuthService;

  EventHandler(GoogleAuthService googleAuthService) {
    _googleAuthService = googleAuthService;
  }

  @override
  void handle(Map<String, dynamic> response) {
    if(response.containsKey('event')) {
      response = response['event'];
      String? location;
      if (response['location'] != null) {
        location = response['location'];
      }
      
      List<String>? attendees = List<String>.from(response['attendees']);

      String timeZone = getDeviceTimeZone();
      if (response['timeZone'] != null) {
        timeZone = response['timeZone'];
      }

      _googleAuthService.createCalendarEvent(
        summary: response['summary'],
        description: response['description'],
        start: DateTime.parse(response['start']),
        end: DateTime.parse(response['end']),
        location: location,
        attendees: attendees,
        timeZone: timeZone,
      );
    } else {
      super.handle(response);
    }
  }
}