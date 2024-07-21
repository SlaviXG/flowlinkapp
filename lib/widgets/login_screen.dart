import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flowlinkapp/widgets/home_screen.dart';
import 'package:flowlinkapp/services/google_auth_service.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  final Map<String, dynamic> config;
  late GoogleAuthService googleAuthService;

  LoginScreen({required this.config, required this.googleAuthService});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authClient = await widget.googleAuthService.getAuthenticatedClient();
      await _storeCredentials(authClient.credentials);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(config: widget.config, googleAuthService: widget.googleAuthService),
        ),
      );
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  Future<void> _storeCredentials(AccessCredentials credentials) async {
    await _storage.write(
      key: 'google_credentials',
      value: json.encode(credentials.toJson()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login with Google'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https://via.placeholder.com/150', // Placeholder image URL
              height: 150,
            ),
            SizedBox(height: 20),
            _isAuthenticating
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login with Google'),
                  ),
          ],
        ),
      ),
    );
  }
}
