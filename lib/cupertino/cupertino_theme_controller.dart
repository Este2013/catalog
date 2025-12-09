import 'package:catalog/main.dart';
import 'package:flutter/cupertino.dart';

/// Controller for Cupertino themes.
/// Extend with more fields as needed (primary color, etc.).
class CupertinoThemeController extends ThemeController<CupertinoThemeData> {
  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  set brightness(Brightness value) {
    if (value == _brightness) return;
    _brightness = value;
    notifyListeners();
  }

  @override
  CupertinoThemeData get theme => CupertinoThemeData(brightness: _brightness);
}
