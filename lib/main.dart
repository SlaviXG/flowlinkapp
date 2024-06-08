import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output = '';
  Socket? _socket;
  Process? _pythonProcess;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlowLink'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startServerAndConnect,
              child: Text('Connect to Server'),
            ),
            SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: Text('Output: $_output'))),
          ],
        ),
      ),
    );
  }
}
