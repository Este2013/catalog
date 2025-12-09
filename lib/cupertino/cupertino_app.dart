//
// ------------------------ CUPERTINO PREVIEW APP ------------------------
//

import 'package:catalog/cupertino/cupertino_theme_controller.dart';
import 'package:catalog/cupertino/cupertino_theme_dialog.dart';
import 'package:flutter/cupertino.dart';

class CupertinoPreviewApp extends StatefulWidget {
  final VoidCallback onExit;

  const CupertinoPreviewApp({super.key, required this.onExit});

  @override
  State<CupertinoPreviewApp> createState() => _CupertinoPreviewAppState();
}

class _CupertinoPreviewAppState extends State<CupertinoPreviewApp> {
  late final CupertinoThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = CupertinoThemeController();
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: _themeController.theme,
          home: CupertinoPreviewHome(themeController: _themeController, onExit: widget.onExit),
        );
      },
    );
  }
}

class CupertinoPreviewHome extends StatelessWidget {
  final CupertinoThemeController themeController;
  final VoidCallback onExit;

  const CupertinoPreviewHome({super.key, required this.themeController, required this.onExit});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Cupertino App Preview'),
        leading: CupertinoButton(padding: EdgeInsets.zero, onPressed: onExit, child: const Icon(CupertinoIcons.xmark)),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showCupertinoDialog<void>(
              context: context,
              builder: (_) => CupertinoThemeDialog(controller: themeController),
            );
          },
          child: const Icon(CupertinoIcons.paintbrush),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Demo content', style: theme.textTheme.navLargeTitleTextStyle.copyWith(fontSize: 22)),
            const SizedBox(height: 8),
            const Text('This is a sample Cupertino app. Use the paintbrush button to edit the theme brightness.'),
            const SizedBox(height: 16),
            CupertinoButton.filled(onPressed: () {}, child: const Text('CupertinoButton.filled')),
            const SizedBox(height: 8),
            CupertinoButton(onPressed: () {}, child: const Text('CupertinoButton')),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(color: theme.barBackgroundColor, borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.info),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Observe how text, background and button colors change '
                      'when you toggle light/dark theme.',
                      style: theme.textTheme.textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
