import 'package:flowlinkapp/models/data_processor.dart';
import 'package:flowlinkapp/models/data_retriever.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> config;

  HomeScreen({required this.config});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DataRetriever _dataRetriever;
  late final DataProcessor _dataProcessor;
  String _output = '';
  final TextEditingController _controller = TextEditingController();
  String? _responseText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dataRetriever = DataRetriever(widget.config['data_retriever'], _processContent);
    _dataProcessor = DataProcessor(widget.config['data_processor']);
  }

  Future<void> _processContent() async {
    setState(() {
      _isLoading = true;
      _responseText = null;
    });

    try {
      final response = await _dataProcessor.extract(_controller.text);
      setState(() {
        _responseText = response.toString();
        _isLoading = false;
      });
      await _dataProcessor.submit(response);
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
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
              onPressed: _loginWithGoogle,
              child: Text('Login with Google'),
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
