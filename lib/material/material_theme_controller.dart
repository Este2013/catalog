import 'package:flutter/material.dart';

enum MaterialThemePreset { materialLight, materialDark, highContrast, custom }

enum DensityPreset { standard, comfortable, compact }

class MaterialThemeController extends ChangeNotifier {
  MaterialThemePreset _preset;
  Brightness _brightness;
  Color _seedColor;
  bool _useMaterial3;
  DensityPreset _density;
  double _textScaleFactor;

  MaterialThemeController({
    MaterialThemePreset preset = MaterialThemePreset.materialLight,
    Brightness brightness = Brightness.light,
    Color seedColor = Colors.indigo,
    bool useMaterial3 = true,
    DensityPreset density = DensityPreset.standard,
    double textScaleFactor = 1.0,
  }) : _preset = preset,
       _brightness = brightness,
       _seedColor = seedColor,
       _useMaterial3 = useMaterial3,
       _density = density,
       _textScaleFactor = textScaleFactor;

  // Getters
  MaterialThemePreset get preset => _preset;
  Brightness get brightness => _brightness;
  Color get seedColor => _seedColor;
  bool get useMaterial3 => _useMaterial3;
  DensityPreset get density => _density;
  double get textScaleFactor => _textScaleFactor;

  // Setters (if you want to tune from outside the dialog)
  set brightness(Brightness value) {
    if (value == _brightness) return;
    _brightness = value;
    _preset = MaterialThemePreset.custom;
    notifyListeners();
  }

  set seedColor(Color value) {
    if (value == _seedColor) return;
    _seedColor = value;
    _preset = MaterialThemePreset.custom;
    notifyListeners();
  }

  set useMaterial3(bool value) {
    if (value == _useMaterial3) return;
    _useMaterial3 = value;
    _preset = MaterialThemePreset.custom;
    notifyListeners();
  }

  set density(DensityPreset value) {
    if (value == _density) return;
    _density = value;
    _preset = MaterialThemePreset.custom;
    notifyListeners();
  }

  set textScaleFactor(double value) {
    if (value == _textScaleFactor) return;
    _textScaleFactor = value;
    _preset = MaterialThemePreset.custom;
    notifyListeners();
  }

  // Apply a known preset and notify.
  void applyPreset(MaterialThemePreset preset) {
    _preset = preset;

    switch (preset) {
      case MaterialThemePreset.materialLight:
        _brightness = Brightness.light;
        _seedColor = Colors.indigo;
        _useMaterial3 = true;
        _density = DensityPreset.standard;
        _textScaleFactor = 1.0;
        break;
      case MaterialThemePreset.materialDark:
        _brightness = Brightness.dark;
        _seedColor = Colors.indigo;
        _useMaterial3 = true;
        _density = DensityPreset.standard;
        _textScaleFactor = 1.0;
        break;
      case MaterialThemePreset.highContrast:
        _brightness = Brightness.light;
        _seedColor = Colors.deepPurple;
        _useMaterial3 = true;
        _density = DensityPreset.compact;
        _textScaleFactor = 1.1; // slightly larger text
        break;
      case MaterialThemePreset.custom:
        // Don't touch current values, just mark as custom.
        break;
    }

    notifyListeners();
  }

  // Build the actual ThemeData used by the preview app.
  ThemeData get theme {
    final base = ThemeData(
      useMaterial3: _useMaterial3,
      brightness: _brightness,
      colorScheme: ColorScheme.fromSeed(seedColor: _seedColor, brightness: _brightness),
      visualDensity: _densityToVisualDensity(_density),
    );

    // Scale text without losing the base ThemeData config.
    // final scaledTextTheme = base.textTheme.apply(fontSizeFactor: _textScaleFactor);
    // final scaledPrimaryTextTheme = base.primaryTextTheme.apply(fontSizeFactor: _textScaleFactor);

    return base; //.copyWith(textTheme: scaledTextTheme, primaryTextTheme: scaledPrimaryTextTheme);
  }

  static VisualDensity _densityToVisualDensity(DensityPreset preset) {
    switch (preset) {
      case DensityPreset.standard:
        return VisualDensity.standard;
      case DensityPreset.comfortable:
        return const VisualDensity(horizontal: -1, vertical: -1);
      case DensityPreset.compact:
        return const VisualDensity(horizontal: -2, vertical: -2);
    }
  }
}
