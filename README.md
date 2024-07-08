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
1. In the main directory, create `api_keys.json` file.
```
{
    "GEMINI_KEY": "PASTE THE API KEY"
}
```
2. Run
```bash
    flutter run --dart-define-from-file=api_keys.json -d windows
```