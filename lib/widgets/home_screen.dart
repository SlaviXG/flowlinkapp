import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flowlinkapp/models/data_processor.dart';
import 'package:flowlinkapp/models/data_retriever.dart';
import 'package:flowlinkapp/app_state.dart';
import 'package:flowlinkapp/widgets/animated_logo.dart';
import 'package:flowlinkapp/widgets/time_saved_display.dart';
import 'package:flowlinkapp/widgets/theme_data.dart';

class HomeScreen extends StatefulWidget {
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
  double _timeSaved = 0.0;

  @override
  void initState() {
    super.initState();
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      final dataRetrieverConfig = appState.config['data_retriever'];
      final dataProcessorConfig = appState.config['data_processor'];

      if (dataRetrieverConfig == null || dataProcessorConfig == null) {
        throw Exception('Configuration for DataRetriever or DataProcessor is missing');
      }

      _dataRetriever = DataRetriever(dataRetrieverConfig, _processContent);
      _dataProcessor = DataProcessor(dataProcessorConfig, appState.googleAuthService);
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  Future<void> _processContent() async {
    ClipboardData? prevClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    await Future.delayed(const Duration(milliseconds: 300));
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
          _timeSaved += 0.5; // Update time saved (for example purposes)
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

  Future<void> _logout() async {
    try {
      _dataRetriever.unregisterHotKeys();
      _dataRetriever.unregisterMouseXButton();
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.googleAuthService.forgetCredentials();
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundBodyColorStart,
            backgroundBodyColorEnd,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('FlowLink'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Center(
                child: AnimatedLogo(),
              ),
              SizedBox(height: 50),
              TimeSavedDisplay(hours: _timeSaved),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _logout,
                child: Text('Log out'),
              ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
