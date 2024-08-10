import 'package:flutter_auto_gui/flutter_auto_gui.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:mouse_event/mouse_event.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';


class DataRetriever {
  late HotKey _currentHotKey;

  DataRetriever(Map <String, dynamic> config, Future<void> Function() hotkeyCallback) {
    _currentHotKey = hotKeyFromString(config['capture_hotkey']);
    if(config['enable_mouse_x_button']) _registerMouseXButton(hotkeyCallback);
    _registerHotKey(_currentHotKey, hotkeyCallback);
  }

  Future<void> registerHotKey(String hotKeyString, Future<void> Function() hotkeyCallback) async {
    await _registerHotKey(hotKeyFromString(hotKeyString), hotkeyCallback);
  }

  Future<void> _registerHotKey(HotKey _hotKey, Future<void> Function() hotkeyCallback) async {
    await hotKeyManager.unregisterAll();
    await hotKeyManager.register(
      _hotKey,
      keyDownHandler: (hotKey) async {
        await hotkeyCallback();
      },
    );
  }

  Future<void> _registerMouseXButton(Future<void> Function() hotkeyCallback) async {
    MouseEventPlugin.startListening((mouseEvent) async {
      if(mouseEvent.mouseMsg == MouseEventMsg.WM_XBUTTONDOWN) {
        await hotkeyCallback();
      }
    });
  }

  Future<void> unregisterMouseXButton() async {
    MouseEventPlugin.cancelListening();
  }

  Future<void> unregisterHotKeys() async {
    await hotKeyManager.unregisterAll();
  }

  static Future<void> simulateCtrlC() async {
    if (Platform.isWindows || Platform.isLinux) {
      // FlutterAutoGUI.hotkey(keys: ['ctrl', 'c']);
      FlutterAutoGUI.keyDown(key: 'ctrl');
      FlutterAutoGUI.keyDown(key: 'c');
      await Future.delayed(const Duration(milliseconds: 200));
      FlutterAutoGUI.keyUp(key: 'c');
      FlutterAutoGUI.keyUp(key: 'ctrl');
    } else if (Platform.isMacOS) {
      FlutterAutoGUI.keyDown(key: 'command');
      FlutterAutoGUI.keyDown(key: 'c');
      await Future.delayed(const Duration(milliseconds: 200));
      FlutterAutoGUI.keyUp(key: 'c');
      FlutterAutoGUI.keyUp(key: 'command');
    } else {
      print('Unsupported platform');
    }
}

  static HotKey hotKeyFromString(String hotKeyString) {
    final hotKeyComponents = hotKeyString.split('+');
    final keyComponent = hotKeyComponents.last.trim();
    final modifierComponents = hotKeyComponents.sublist(0, hotKeyComponents.length - 1);

    PhysicalKeyboardKey key;
    List<HotKeyModifier> modifiers = [];

    // Map the key component
    switch (keyComponent.toUpperCase()) {
      case 'A':
        key = PhysicalKeyboardKey.keyA;
        break;
      case 'B':
        key = PhysicalKeyboardKey.keyB;
        break;
      case 'C':
        key = PhysicalKeyboardKey.keyC;
        break;
      case 'D':
        key = PhysicalKeyboardKey.keyD;
        break;
      case 'E':
        key = PhysicalKeyboardKey.keyE;
        break;
      case 'F':
        key = PhysicalKeyboardKey.keyF;
        break;
      case 'G':
        key = PhysicalKeyboardKey.keyG;
        break;
      case 'H':
        key = PhysicalKeyboardKey.keyH;
        break;
      case 'I':
        key = PhysicalKeyboardKey.keyI;
        break;
      case 'J':
        key = PhysicalKeyboardKey.keyJ;
        break;
      case 'K':
        key = PhysicalKeyboardKey.keyK;
        break;
      case 'L':
        key = PhysicalKeyboardKey.keyL;
        break;
      case 'M':
        key = PhysicalKeyboardKey.keyM;
        break;
      case 'N':
        key = PhysicalKeyboardKey.keyN;
        break;
      case 'O':
        key = PhysicalKeyboardKey.keyO;
        break;
      case 'P':
        key = PhysicalKeyboardKey.keyP;
        break;
      case 'Q':
        key = PhysicalKeyboardKey.keyQ;
        break;
      case 'R':
        key = PhysicalKeyboardKey.keyR;
        break;
      case 'S':
        key = PhysicalKeyboardKey.keyS;
        break;
      case 'T':
        key = PhysicalKeyboardKey.keyT;
        break;
      case 'U':
        key = PhysicalKeyboardKey.keyU;
        break;
      case 'V':
        key = PhysicalKeyboardKey.keyV;
        break;
      case 'W':
        key = PhysicalKeyboardKey.keyW;
        break;
      case 'X':
        key = PhysicalKeyboardKey.keyX;
        break;
      case 'Y':
        key = PhysicalKeyboardKey.keyY;
        break;
      case 'Z':
        key = PhysicalKeyboardKey.keyZ;
        break;
      case '0':
        key = PhysicalKeyboardKey.digit0;
        break;
      case '1':
        key = PhysicalKeyboardKey.digit1;
        break;
      case '2':
        key = PhysicalKeyboardKey.digit2;
        break;
      case '3':
        key = PhysicalKeyboardKey.digit3;
        break;
      case '4':
        key = PhysicalKeyboardKey.digit4;
        break;
      case '5':
        key = PhysicalKeyboardKey.digit5;
        break;
      case '6':
        key = PhysicalKeyboardKey.digit6;
        break;
      case '7':
        key = PhysicalKeyboardKey.digit7;
        break;
      case '8':
        key = PhysicalKeyboardKey.digit8;
        break;
      case '9':
        key = PhysicalKeyboardKey.digit9;
        break;
      case 'F1':
        key = PhysicalKeyboardKey.f1;
        break;
      case 'F2':
        key = PhysicalKeyboardKey.f2;
        break;
      case 'F3':
        key = PhysicalKeyboardKey.f3;
        break;
      case 'F4':
        key = PhysicalKeyboardKey.f4;
        break;
      case 'F5':
        key = PhysicalKeyboardKey.f5;
        break;
      case 'F6':
        key = PhysicalKeyboardKey.f6;
        break;
      case 'F7':
        key = PhysicalKeyboardKey.f7;
        break;
      case 'F8':
        key = PhysicalKeyboardKey.f8;
        break;
      case 'F9':
        key = PhysicalKeyboardKey.f9;
        break;
      case 'F10':
        key = PhysicalKeyboardKey.f10;
        break;
      case 'F11':
        key = PhysicalKeyboardKey.f11;
        break;
      case 'F12':
        key = PhysicalKeyboardKey.f12;
        break;
      case 'ESC':
      case 'ESCAPE':
        key = PhysicalKeyboardKey.escape;
        break;
      case 'TAB':
        key = PhysicalKeyboardKey.tab;
        break;
      case 'SPACE':
      case 'SPACEBAR':
        key = PhysicalKeyboardKey.space;
        break;
      case 'ENTER':
      case 'RETURN':
        key = PhysicalKeyboardKey.enter;
        break;
      case 'BACKSPACE':
        key = PhysicalKeyboardKey.backspace;
        break;
      case 'DELETE':
        key = PhysicalKeyboardKey.delete;
        break;
      case 'INSERT':
        key = PhysicalKeyboardKey.insert;
        break;
      case 'HOME':
        key = PhysicalKeyboardKey.home;
        break;
      case 'END':
        key = PhysicalKeyboardKey.end;
        break;
      case 'PAGEUP':
      case 'PAGE_UP':
        key = PhysicalKeyboardKey.pageUp;
        break;
      case 'PAGEDOWN':
      case 'PAGE_DOWN':
        key = PhysicalKeyboardKey.pageDown;
        break;
      case 'LEFT':
        key = PhysicalKeyboardKey.arrowLeft;
        break;
      case 'UP':
        key = PhysicalKeyboardKey.arrowUp;
        break;
      case 'RIGHT':
        key = PhysicalKeyboardKey.arrowRight;
        break;
      case 'DOWN':
        key = PhysicalKeyboardKey.arrowDown;
        break;
      default:
        throw Exception('Unsupported key: $keyComponent');
    }

    // Map the modifier components
    for (var modifier in modifierComponents) {
      switch (modifier.toUpperCase()) {
        case 'ALT':
          modifiers.add(HotKeyModifier.alt);
          break;
        case 'CTRL':
        case 'CONTROL':
          modifiers.add(HotKeyModifier.control);
          break;
        case 'SHIFT':
          modifiers.add(HotKeyModifier.shift);
          break;
        case 'META':
          modifiers.add(HotKeyModifier.meta);
          break;
        default:
          throw Exception('Unsupported modifier: $modifier');
      }
    }

    return HotKey(
      key: key,
      modifiers: modifiers,
      scope: HotKeyScope.system,
    );
  }
}