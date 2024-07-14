import 'package:flowlinkapp/models/data_processor.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;


class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> config;

  HomeScreen({required this.config});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DataProcessor _dataProcessor;
  String _output = '';
  Socket? _socket;
  Process? _pythonProcess;
  final TextEditingController _controller = TextEditingController();
  String? _responseText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataProcessor = DataProcessor(widget.config['data_processor']);
  }

  @override
  void dispose() {
    _socket?.close();
    _pythonProcess?.kill();
    super.dispose();
  }

  void _startServerAndConnect() async {
    // Use path package to construct the absolute path to the executable
    String scriptPath = path.join(Directory.current.path, 'dist', 'hotkey_listener.exe');

    // Check if the executable exists
    File exeFile = File(scriptPath);
    if (!exeFile.existsSync()) {
      setState(() {
        _output = 'Executable not found at $scriptPath';
      });
      return;
    }

    // Start the Python server process
    try {
      _pythonProcess = await Process.start(scriptPath, [], runInShell: true);
      _pythonProcess?.stdout.transform(utf8.decoder).listen((data) {
        setState(() {
          _output += 'Python Output: $data\n';
        });
      });
      _pythonProcess?.stderr.transform(utf8.decoder).listen((data) {
        setState(() {
          _output += 'Python Error: $data\n';
        });
      });
      setState(() {
        _output += 'Python process started successfully.\n';
      });
    } catch (e) {
      setState(() {
        _output += 'Failed to start Python process: $e\n';
      });
      return;
    }

    // Connect to the server
    _connectToServer();
  }

  void _connectToServer() async {
    try {
      _socket = await Socket.connect('localhost', 65432);
      _socket!.listen((List<int> event) {
        setState(() {
          _output += utf8.decode(event);
        });
      });
      setState(() {
        _output += 'Connected to the server.\n';
      });
    } catch (e) {
      setState(() {
        _output += 'Failed to connect: $e\n';
      });
    }
  }

  void _processContent() async {
    if (_dataProcessor == null) {
      setState(() {
        _responseText = 'API service not initialized';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dataProcessor.extract(_controller.text);
      setState(() {
        _responseText = response.toString();
        _isLoading = false;
      });
      _dataProcessor.submit(response);
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _loginWithGoogle() async {
    try {
      await _dataProcessor.getGoogleAuthService().getAuthenticatedClient();
      setState(() {
        _output += 'Successfully authenticated with Google.\n';
      });
    } catch (e) {
      setState(() {
        _output += 'Failed to authenticate with Google: $e\n';
      });
    }
  }

  void _createTask() async {
    try {
      var task = await _dataProcessor.getGoogleAuthService().createTask('Sample Task', 'This is a sample task');
      setState(() {
        _output += 'Created Task: ${task.title}\n';
      });
    } catch (e) {
      setState(() {
        _output += 'Failed to create task: $e\n';
      });
    }
  }

  void _createCalendarEvent() async {
    try {
      var event = await _dataProcessor.getGoogleAuthService().createCalendarEvent(
        'Sample Event',
        'This is a sample event',
        DateTime.now(),
        DateTime.now().add(Duration(hours: 1)),
      );
      setState(() {
        _output += 'Created Event: ${event.summary}\n';
      });
    } catch (e) {
      setState(() {
        _output += 'Failed to create event: $e\n';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlowLink'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Type your prompt'),
              minLines: 1,
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _processContent,
              child: _isLoading ? CircularProgressIndicator() : Text('Send'),
            ),
            SizedBox(height: 20),
            _responseText != null
                ? Text(
                    _responseText!,
                    style: TextStyle(fontSize: 16),
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startServerAndConnect,
              child: Text('Connect to Server'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithGoogle,
              child: Text('Login with Google'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTask,
              child: Text('Create Task'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createCalendarEvent,
              child: Text('Create Calendar Event'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Output:\n$_output',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
