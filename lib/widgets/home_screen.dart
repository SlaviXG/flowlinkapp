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
import 'package:flowlinkapp/utils/datetime.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final DataRetriever _dataRetriever;
  late final DataProcessor _dataProcessor;
  String _output = '';
  String? _responseText;
  bool _isLoading = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final GlobalKey<AnimatedLogoState> _animatedLogoKey = GlobalKey<AnimatedLogoState>();
  double _timeSaved = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTimeSaved();
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

  Future<void> _loadTimeSaved() async {
    String? savedTime = await _storage.read(key: 'time_saved');
    if (savedTime != null) {
      setState(() {
        _timeSaved = double.parse(savedTime);
      });
    }
  }

  Future<void> _saveTimeSaved() async {
    await _storage.write(key: 'time_saved', value: _timeSaved.toString());
  }

  Future<void> _processContent() async {
    ClipboardData? prevClipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    await Future.delayed(const Duration(milliseconds: 300));
    await DataRetriever.simulateCtrlC();
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboardData != null) {
      setState(() {
        _animatedLogoKey.currentState?.accelerate(true);
        _responseText = null;
      });

      try {
        final response = await _dataProcessor.extract(clipboardData.text.toString());
        _responseText = response.toString();
        if (prevClipboardData != null) {
          await Clipboard.setData(prevClipboardData);
        }
        await _dataProcessor.submit(response);
        setState(() {
          _isLoading = false;
          _timeSaved += calculateHoursSaved(response);
          _saveTimeSaved();
        });
        _animatedLogoKey.currentState?.accelerate(false);
      } catch (e) {
        setState(() {
          _responseText = 'Error: $e';
          _isLoading = false;
          print(_responseText);
        });
        _animatedLogoKey.currentState?.accelerate(false);
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
      await _storage.delete(key: 'time_saved');
      setState(() {
        _timeSaved = 0.0;
        _output += 'Successfully forgot credentials.\n';
      });
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      setState(() {
        _output += 'Failed to forget credentials: $e\n';
      });
    } 
    print(_output);
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
          title: const Text('FlowLink'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: AnimatedLogo(key: _animatedLogoKey),
              ),
              const SizedBox(height: 40),
              TimeSavedDisplay(hours: _timeSaved),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _logout,
                child: const Text('Log out'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
