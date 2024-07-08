import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'package:flowlinkapp/services/gemini_service.dart';


class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> config;

  HomeScreen({required this.config});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Map<String, dynamic> config;
  String _output = '';
  Socket? _socket;
  Process? _pythonProcess;
  final TextEditingController _controller = TextEditingController();
  String? _responseText;
  bool _isLoading = false;
  late GeminiService _geminiService;
  
  @override
  void initState() {
    super.initState();
    _initializeGeminiApiService(const String.fromEnvironment('GEMINI_KEY'), widget.config['system_prompt']);
  }

  void _initializeGeminiApiService(String apiKey, String systemPrompt) {
    try {
      _geminiService = GeminiService(apiKey, systemPrompt);
    } catch (e) {
      setState(() {
        _responseText = 'Failed to initialize API service: $e';
      });
    }
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

  void _generateContent() async {
    if (_geminiService == null) {
      setState(() {
        _responseText = 'API service not initialized';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final responseText = await _geminiService.generateContent(_controller.text);
      setState(() {
        _responseText = responseText;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
        _isLoading = false;
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
              onPressed: _isLoading ? null : _generateContent,
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
