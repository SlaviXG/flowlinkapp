import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flowlinkapp/models/data_processor.dart';
import 'package:flowlinkapp/models/data_retriever.dart';
import 'package:flowlinkapp/services/google_auth_service.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> config;
  final GoogleAuthService googleAuthService;

  HomeScreen({required this.config, required this.googleAuthService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final DataRetriever _dataRetriever;
  late final DataProcessor _dataProcessor;
  String _output = '';
  String? _responseText;
  bool _isLoading = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    try {
      final dataRetrieverConfig = widget.config['data_retriever'];
      final dataProcessorConfig = widget.config['data_processor'];

      if (dataRetrieverConfig == null || dataProcessorConfig == null) {
        throw Exception('Configuration for DataRetriever or DataProcessor is missing');
      }

      _dataRetriever = DataRetriever(dataRetrieverConfig, _processContent);
      _dataProcessor = DataProcessor(dataProcessorConfig, widget.googleAuthService);
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  Future<void> _processContent() async {
    ClipboardData? prevClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    await DataRetriever.simulateCtrlC();
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboardData != null) {
      setState(() {
        _isLoading = true;
        _responseText = null;
      });

      try {
        final response = await _dataProcessor.extract(clipboardData.text.toString());
        setState(() {
          _responseText = response.toString();
          _isLoading = false;
        });
        if (prevClipboardData != null) {
          await Clipboard.setData(prevClipboardData);
        }
        await _dataProcessor.submit(response);
      } catch (e) {
        setState(() {
          _responseText = 'Error: $e';
          _isLoading = false;
        });
      }
    } else {
      print('Clipboard is empty or does not contain plain text.');
    }
  }

  Future<void> _forgetCredentials() async {
    try {
      await widget.googleAuthService.forgetCredentials();
      await _storage.delete(key: 'google_credentials');
      setState(() {
        _output += 'Successfully forgot credentials.\n';
      });
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _output += 'Failed to forget credentials: $e\n';
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
            ElevatedButton(
              onPressed: _forgetCredentials,
              child: Text('Forget Credentials'),
            ),
            SizedBox(height: 20),
            Text(
              'Output:\n$_output',
              style: TextStyle(fontSize: 14),
            ),
            _responseText != null
                ? Text(
                    _responseText!,
                    style: TextStyle(fontSize: 16),
                  )
                : Container(),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
