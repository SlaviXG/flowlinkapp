import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flowlinkapp/app_state.dart';
import 'package:flowlinkapp/widgets/animated_logo.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
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
      final appState = Provider.of<AppState>(context, listen: false);
      final authClient = await appState.googleAuthService.getAuthenticatedClient();
      await _storeCredentials(authClient.credentials);

      Navigator.pushReplacementNamed(context, '/home');
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
            Center(
              child: AnimatedLogo(),
            ),
            SizedBox(height: 50),
            _isAuthenticating
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/google_icon.png',
                          height: 24.0,
                        ),
                        SizedBox(width: 10),
                        Text('Login'),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
