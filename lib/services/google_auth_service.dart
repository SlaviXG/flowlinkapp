import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/tasks/v1.dart';
import 'package:googleapis/calendar/v3.dart';
import 'dart:convert';


class GoogleAuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  late final ClientId _clientId;
  late final List <String> _scopes;

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

  Future<String> _getDefaultTaskListId(TasksApi tasksApi) async {
    var taskLists = await tasksApi.tasklists.list();
    if (taskLists.items != null && taskLists.items!.isNotEmpty) {
      return taskLists.items!.first.id!;
    } else {
      throw Exception('No task lists found');
    }
  }

  Future<Task> createTask(String title, String notes) async {
    var client = await getAuthenticatedClient();
    var tasksApi = TasksApi(client);

    var taskListId = await _getDefaultTaskListId(tasksApi);

    var task = Task()
      ..title = title
      ..notes = notes;

    return await tasksApi.tasks.insert(task, taskListId);
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
