import 'package:catalog/cupertino/cupertino_app.dart';
import 'package:catalog/material/material_app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const RootShellApp());
}

/// Root app that hosts the style picker and pushes style-specific preview apps.
/// This is *not* the Material/Cupertino app you’re previewing – it’s just the shell.
class RootShellApp extends StatelessWidget {
  const RootShellApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Style Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
      home: const StylePickerPage(),
    );
  }
}

/// Simple “model” of a style.
/// Easy to extend (add more styles later).
enum AppStyleType { material, cupertino }

class AppStyleDescriptor {
  final AppStyleType type;
  final String title;
  final String description;
  final IconData icon;

  const AppStyleDescriptor({required this.type, required this.title, required this.description, required this.icon});
}

/// Home page: lets the user choose which style of app to preview.
class StylePickerPage extends StatelessWidget {
  const StylePickerPage({super.key});

  static const _styles = <AppStyleDescriptor>[
    AppStyleDescriptor(type: AppStyleType.material, title: 'Material App', description: 'Android / Material Design style application.', icon: Icons.android),
    AppStyleDescriptor(type: AppStyleType.cupertino, title: 'Cupertino App', description: 'iOS-style application using Cupertino widgets.', icon: Icons.phone_iphone),
    // Later: add more styles here (e.g. Fluent, custom design system, etc.).
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose App Style')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _styles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final style = _styles[index];
          return Card(
            child: ListTile(
              leading: Icon(style.icon),
              title: Text(style.title),
              subtitle: Text(style.description),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => StylePreviewShell(style: style)));
              },
            ),
          );
        },
      ),
    );
  }
}

/// Shell page that hosts the actual style-specific WidgetApp in a subtree.
/// This allows easy reuse of the pattern for future styles.
class StylePreviewShell extends StatelessWidget {
  final AppStyleDescriptor style;

  const StylePreviewShell({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    // We pass a callback so the inner app can exit even though it has its own Navigator.
    void exitPreview() {
      Navigator.of(context).pop();
    }

    switch (style.type) {
      case AppStyleType.material:
        return MaterialPreviewApp(onExit: exitPreview);
      case AppStyleType.cupertino:
        return CupertinoPreviewApp(onExit: exitPreview);
    }
  }
}

/// Base interface for theme controllers.
abstract class ThemeController<T> extends ChangeNotifier {
  T get theme;
}
