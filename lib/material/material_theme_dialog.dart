import 'package:catalog/material/material_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Edit Material Theme'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRESET BUTTONS (top)
          const Text('Defaults', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              _PresetChip(label: 'Default light', selected: _preset == MaterialThemePreset.materialLight, onPressed: () => _selectPreset(MaterialThemePreset.materialLight)),
              _PresetChip(label: 'Default dark', selected: _preset == MaterialThemePreset.materialDark, onPressed: () => _selectPreset(MaterialThemePreset.materialDark)),
              _PresetChip(label: 'High contrast', selected: _preset == MaterialThemePreset.highContrast, onPressed: () => _selectPreset(MaterialThemePreset.highContrast)),
            ],
          ),
          const SizedBox(height: 16),

          const Divider(),
          const SizedBox(height: 8),

          // COLORS
          const Text('Colors and brightness', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            title: Text('App brightness'),
            trailing: SegmentedButton<Brightness>(
              segments: [
                ButtonSegment(value: Brightness.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                ButtonSegment(value: Brightness.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
              ],
              selected: <Brightness>{_brightness},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _brightness = newSelection.first;
                  _preset = MaterialThemePreset.custom;
                });
              },
              showSelectedIcon: false,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.primary;
                  }
                  return null;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.onPrimary;
                  }
                  return null;
                }),
              ),
            ),
            onTap: () {
              setState(() {
                _brightness = _brightness == .light ? .dark : .light;
                _preset = MaterialThemePreset.custom;
              });
            },
          ),

          const SizedBox(height: 16),
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
          SegmentedButton<DensityPreset>(
            segments: [
              ButtonSegment(value: DensityPreset.compact, label: Text('Compact'), icon: Icon(Symbols.view_compact)),
              ButtonSegment(value: DensityPreset.standard, label: Text('Standard'), icon: Icon(Symbols.calendar_view_month)),
              ButtonSegment(value: DensityPreset.comfortable, label: Text('Comfortable'), icon: Icon(Symbols.view_comfy)),
            ],
            selected: <DensityPreset>{_density},
            onSelectionChanged: (newSelection) {
              setState(() {
                _density = newSelection.first;
                _preset = MaterialThemePreset.custom;
              });
            },
            showSelectedIcon: false,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return null;
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).colorScheme.onPrimary;
                }
                return null;
              }),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _useMaterial3,
            onChanged: (value) {
              setState(() {
                _useMaterial3 = value;
                _preset = MaterialThemePreset.custom;
              });
            },
            title: const Text('Use Material 3'),
            subtitle: const Text('Turn off to use the old Material 2 style.'),
          ),

          // TYPOGRAPHY
          // const Text('Typography', style: TextStyle(fontWeight: FontWeight.bold)),
          // const SizedBox(height: 8),

          // Row(
          //   children: [
          //     Expanded(
          //       child: Slider(
          //         value: _textScaleFactor,
          //         min: 0.8,
          //         max: 1.4,
          //         divisions: 6,
          //         label: '${_textScaleFactor.toStringAsFixed(1)}x',
          //         onChanged: (value) {
          //           setState(() {
          //             _textScaleFactor = value;
          //             _preset = MaterialThemePreset.custom;
          //           });
          //         },
          //       ),
          //     ),
          //     const SizedBox(width: 8),
          //     Text('${_textScaleFactor.toStringAsFixed(1)}x'),
          //   ],
          // ),
          // const SizedBox(height: 4),
          // const Text(
          //   'Affects textTheme and primaryTextTheme.\n'
          //   'You can extend this later with font families, weights, etc.',
          //   style: TextStyle(fontSize: 11),
          // ),
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
