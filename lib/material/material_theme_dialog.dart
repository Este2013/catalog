import 'dart:ui';

import 'package:catalog/material/material_theme_controller.dart';
import 'package:flutter/material.dart';

class MaterialThemeDialog extends StatefulWidget {
  final MaterialThemeController controller;

  const MaterialThemeDialog({super.key, required this.controller});

  @override
  State<MaterialThemeDialog> createState() => _MaterialThemeDialogState();
}

class _MaterialThemeDialogState extends State<MaterialThemeDialog> {
  late MaterialThemePreset _preset;
  late Brightness _brightness;
  late Color _seedColor;
  late bool _useMaterial3;
  late DensityPreset _density;
  late double _textScaleFactor;

  // Simple palette – extend as you like
  final List<Color> _seedPalette = const [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.brown,
    Colors.grey,
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.controller;
    _preset = c.preset;
    _brightness = c.brightness;
    _seedColor = c.seedColor;
    _useMaterial3 = c.useMaterial3;
    _density = c.density;
    _textScaleFactor = c.textScaleFactor;
  }

  void _selectPreset(MaterialThemePreset preset) {
    // Apply to controller immediately so the preview updates live.
    widget.controller.applyPreset(preset);

    // Sync local fields with controller after preset.
    final c = widget.controller;
    setState(() {
      _preset = c.preset;
      _brightness = c.brightness;
      _seedColor = c.seedColor;
      _useMaterial3 = c.useMaterial3;
      _density = c.density;
      _textScaleFactor = c.textScaleFactor;
    });
  }

  void _apply() {
    // If user tweaked anything manually, mark as custom.
    if (_preset != MaterialThemePreset.materialLight && _preset != MaterialThemePreset.materialDark && _preset != MaterialThemePreset.highContrast) {
      _preset = MaterialThemePreset.custom;
    }

    widget.controller.applyPreset(_preset);
    widget.controller
      ..brightness = _brightness
      ..seedColor = _seedColor
      ..useMaterial3 = _useMaterial3
      ..density = _density
      ..textScaleFactor = _textScaleFactor;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Material Theme'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRESET BUTTONS (top)
            const Text('Defaults', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PresetChip(label: 'Default light', selected: _preset == MaterialThemePreset.materialLight, onPressed: () => _selectPreset(MaterialThemePreset.materialLight)),
                _PresetChip(label: 'Default dark', selected: _preset == MaterialThemePreset.materialDark, onPressed: () => _selectPreset(MaterialThemePreset.materialDark)),
                _PresetChip(label: 'High contrast', selected: _preset == MaterialThemePreset.highContrast, onPressed: () => _selectPreset(MaterialThemePreset.highContrast)),
              ],
            ),
            const SizedBox(height: 16),

            const Divider(),
            const SizedBox(height: 8),

            // CORE PROPERTIES
            const Text('Core properties', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            DropdownButtonFormField<Brightness>(
              decoration: const InputDecoration(labelText: 'Brightness', border: OutlineInputBorder()),
              value: _brightness,
              items: const [
                DropdownMenuItem(value: Brightness.light, child: Text('Light')),
                DropdownMenuItem(value: Brightness.dark, child: Text('Dark')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _brightness = value;
                    _preset = MaterialThemePreset.custom;
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              value: _useMaterial3,
              onChanged: (value) {
                setState(() {
                  _useMaterial3 = value;
                  _preset = MaterialThemePreset.custom;
                });
              },
              title: const Text('Use Material 3'),
              subtitle: const Text('Toggle to see component style changes'),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // COLORS
            const Text('Color seed', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Seed color', border: OutlineInputBorder()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (final color in _seedPalette)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _seedColor = color;
                          _preset = MaterialThemePreset.custom;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: _seedColor == color ? Colors.black : Colors.transparent, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // LAYOUT / DENSITY
            const Text('Layout & density', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            DropdownButtonFormField<DensityPreset>(
              decoration: const InputDecoration(labelText: 'Density', border: OutlineInputBorder()),
              value: _density,
              items: const [
                DropdownMenuItem(value: DensityPreset.standard, child: Text('Standard')),
                DropdownMenuItem(value: DensityPreset.comfortable, child: Text('Comfortable')),
                DropdownMenuItem(value: DensityPreset.compact, child: Text('Compact')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _density = value;
                    _preset = MaterialThemePreset.custom;
                  });
                }
              },
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // TYPOGRAPHY
            const Text('Typography', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _textScaleFactor,
                    min: 0.8,
                    max: 1.4,
                    divisions: 6,
                    label: '${_textScaleFactor.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      setState(() {
                        _textScaleFactor = value;
                        _preset = MaterialThemePreset.custom;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text('${_textScaleFactor.toStringAsFixed(1)}x'),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Affects textTheme and primaryTextTheme.\n'
              'You can extend this later with font families, weights, etc.',
              style: TextStyle(fontSize: 11),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: const Text('Close')),
        FilledButton(onPressed: _apply, child: const Text('Apply')),
      ],
    );
  }
}

// Small helper widget to make the preset buttons look nice.
class _PresetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _PresetChip({required this.label, required this.selected, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (selected) {
      return FilledButton.tonal(onPressed: onPressed, child: Text(label));
    }

    return OutlinedButton(
      style: OutlinedButton.styleFrom(side: BorderSide(color: theme.colorScheme.outline)),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
