import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/tasks/v1.dart';
import 'package:googleapis/calendar/v3.dart';
import 'dart:convert';


class GoogleAuthService {
  final _storage = FlutterSecureStorage();
  final _clientId = ClientId('CLIENT_ID', 'CLIENT_SECRET');
  final _scopes = [
    'https://www.googleapis.com/auth/tasks',
    'https://www.googleapis.com/auth/calendar'
  ];

  Future<AuthClient> getAuthenticatedClient() async {
    var credentials = await _getStoredCredentials();
    if (credentials != null) {
      return autoRefreshingClient(_clientId, credentials, http.Client());
    } else {
      return await _authenticate();
    }
  }

  Future<AuthClient> _authenticate() async {
    var client = await clientViaUserConsent(_clientId, _scopes, _prompt);
    await _storeCredentials(client.credentials);
    return client;
  }

  void _prompt(String url) {
    print('Please go to the following URL and grant access:');
    print('  => $url');
    print('');
  }

  Future<AccessCredentials?> _getStoredCredentials() async {
    var jsonCredentials = await _storage.read(key: 'google_credentials');
    if (jsonCredentials != null) {
      return AccessCredentials.fromJson(json.decode(jsonCredentials));
    }
    return null;
  }

  Future<void> _storeCredentials(AccessCredentials credentials) async {
    await _storage.write(
      key: 'google_credentials',
      value: json.encode(credentials.toJson()),
    );
  }

  Future<Task> createTask(String title, String notes) async {
    var client = await getAuthenticatedClient();
    var tasksApi = TasksApi(client);
    var task = Task()
      ..title = title
      ..notes = notes;

    return await tasksApi.tasks.insert(task, 'default');
  }

  Future<Event> createCalendarEvent(String summary, String description, DateTime start, DateTime end) async {
    var client = await getAuthenticatedClient();
    var calendarApi = CalendarApi(client);

    var event = Event()
      ..summary = summary
      ..description = description
      ..start = (EventDateTime()
        ..dateTime = start
        ..timeZone = 'America/Los_Angeles')
      ..end = (EventDateTime()
        ..dateTime = end
        ..timeZone = 'America/Los_Angeles');

    return await calendarApi.events.insert(event, 'primary');
  }
}
