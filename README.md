# flowlinkapp

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Building global hotkey listener
```bash
    pyinstaller --onefile --hidden-import pynput.keyboard.hotkey --hidden-import pynput.keyboard.listener lib/hotkey_listener.py
```

## Build & run
1. In the main directory, create `auth.json` file.
2. Pase the following content and provide your gemini api key, google cloud client id, project id and secret.
```
{
    {   
    "data_processor": {
        "services": {
            "gemini": {
                "api_key": "YOUR GEMINI API KEY"
            },
            "flowlink": {
                "client_id":"YOUR CLIENT ID",
                "project_id":"YOUR PROJECT ID",
                "auth_uri":"https://accounts.google.com/o/oauth2/auth",
                "token_uri":"https://oauth2.googleapis.com/token",
                "auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs",
                "client_secret":"YOUR CLIENT SECRET",
                "redirect_uris":["http://localhost"]
            }
        }
    }
}
}
```

2. Run
```bash
    flutter run -d windows
```