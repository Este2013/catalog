import 'package:catalog/material/material_theme_controller.dart';
import 'package:catalog/material/material_theme_dialog.dart';
import 'package:flutter/material.dart';

//
// ------------------------ MATERIAL PREVIEW APP ------------------------
//

/// Full MaterialApp running in a subtree.
/// Uses MaterialThemeController + dialog for editing.
class MaterialPreviewApp extends StatefulWidget {
  final VoidCallback onExit;

  const MaterialPreviewApp({super.key, required this.onExit});

  @override
  State<MaterialPreviewApp> createState() => _MaterialPreviewAppState();
}

class _MaterialPreviewAppState extends State<MaterialPreviewApp> {
  late final MaterialThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = MaterialThemeController();
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _themeController.theme,
          home: MaterialPreviewHome(themeController: _themeController, onExit: widget.onExit),
        );
      },
    );
  }
}

class MaterialPreviewHome extends StatelessWidget {
  final MaterialThemeController themeController;
  final VoidCallback onExit;

  const MaterialPreviewHome({super.key, required this.themeController, required this.onExit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Preview'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onExit, tooltip: 'Exit to style chooser'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Edit theme',
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => MaterialThemeDialog(controller: themeController),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Demo content', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'This is a sample Material app. Use the palette icon in the app bar to edit its ThemeData. '
            'Later you can plug in more widgets here and expose their parameters.',
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: const Text('FilledButton example')),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () {}, child: const Text('OutlinedButton example')),
          const SizedBox(height: 8),
          TextButton(onPressed: () {}, child: const Text('TextButton example')),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Card & ListTile'),
              subtitle: const Text('Observe how theme changes affect this.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
