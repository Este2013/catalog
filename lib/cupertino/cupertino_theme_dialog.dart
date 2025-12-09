import 'package:catalog/cupertino/cupertino_theme_controller.dart';
import 'package:flutter/cupertino.dart';

class CupertinoThemeDialog extends StatefulWidget {
  final CupertinoThemeController controller;

  const CupertinoThemeDialog({super.key, required this.controller});

  @override
  State<CupertinoThemeDialog> createState() => _CupertinoThemeDialogState();
}

class _CupertinoThemeDialogState extends State<CupertinoThemeDialog> {
  late Brightness _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.controller.brightness;
  }

  void _apply() {
    widget.controller.brightness = _brightness;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text('Edit Cupertino Theme'),
      content: Column(
        children: [
          const SizedBox(height: 8),
          CupertinoSegmentedControl<Brightness>(
            groupValue: _brightness,
            children: const {
              Brightness.light: Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Light')),
              Brightness.dark: Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('Dark')),
            },
            onValueChanged: (value) {
              setState(() => _brightness = value);
            },
          ),
          const SizedBox(height: 8),
          const Text('Extend this dialog later with more CupertinoThemeData options.', style: TextStyle(fontSize: 12)),
        ],
      ),
      actions: [
        CupertinoDialogAction(onPressed: Navigator.of(context).pop, child: const Text('Cancel')),
        CupertinoDialogAction(isDefaultAction: true, onPressed: _apply, child: const Text('Apply')),
      ],
    );
  }
}
