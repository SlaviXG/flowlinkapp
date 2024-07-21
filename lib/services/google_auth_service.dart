import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/tasks/v1.dart';
import 'package:googleapis/calendar/v3.dart';
import 'dart:convert';

class GoogleAuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late final ClientId _clientId;
  late final List<String> _scopes;

  GoogleAuthService(String clientId, String clientSecret, List<dynamic> scopes) {
    _clientId = ClientId(clientId, clientSecret);
    _scopes = scopes.map((e) => e.toString()).toList();
  }

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

  void _prompt(String url) async {
    print('Please go to the following URL and grant access:');
    print('  => $url');
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
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

  Future<void> forgetCredentials() async {
    await _storage.delete(key: 'google_credentials');
  }

  Future<String> _getDefaultTaskListId(TasksApi tasksApi) async {
    var taskLists = await tasksApi.tasklists.list();
    if (taskLists.items != null && taskLists.items!.isNotEmpty) {
      return taskLists.items!.first.id!;
    } else {
      throw Exception('No task lists found');
    }
  }

  Future<Task> createTask(String title, {String? notes, String? dueDate}) async {
    var client = await getAuthenticatedClient();
    var tasksApi = TasksApi(client);
    var taskListId = await _getDefaultTaskListId(tasksApi);

    var task = Task()
      ..title = title;

    if (notes != null) {
      task.notes = notes;
    }
    
    if (dueDate != null) {
      task.due = dueDate;
    }

    return await tasksApi.tasks.insert(task, taskListId);
  }

  Future<Event> createCalendarEvent({
    required String summary, 
    required String description, 
    required DateTime start, 
    required DateTime end, 
    String? location, 
    List<String>? attendees, 
    String timeZone = 'America/Los_Angeles'}) async {

    var client = await getAuthenticatedClient();
    var calendarApi = CalendarApi(client);

    var event = Event()
      ..summary = summary
      ..description = description
      ..start = (EventDateTime()
        ..dateTime = start
        ..timeZone = timeZone)
      ..end = (EventDateTime()
        ..dateTime = end
        ..timeZone = timeZone);

    if (location != null) {
      event.location = location;
    }

    if (attendees != null && attendees.isNotEmpty) {
      event.attendees = attendees.map((email) => EventAttendee(email: email)).toList();
    }

    return await calendarApi.events.insert(event, 'primary');
  }
}
