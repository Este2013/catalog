import 'package:catalog/catalog.dart';
import 'package:catalog/docs_display.dart';
import 'package:catalog/material/material_theme_controller.dart';
import 'package:catalog/material/material_theme_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

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

class MaterialPreviewHome extends StatefulWidget {
  final MaterialThemeController themeController;
  final VoidCallback onExit;

  const MaterialPreviewHome({super.key, required this.themeController, required this.onExit});

  @override
  State<MaterialPreviewHome> createState() => _MaterialPreviewHomeState();
}

class _MaterialPreviewHomeState extends State<MaterialPreviewHome> {
  CatalogEntry? selected;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Material App Preview'),
      leading: IconButton(icon: const Icon(Icons.close), onPressed: widget.onExit, tooltip: 'Exit to style chooser'),
      actions: [
        IconButton(
          icon: const Icon(Icons.palette_outlined),
          tooltip: 'Edit theme',
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => MaterialThemeDialog(controller: widget.themeController),
            );
          },
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 8),
    ),
    body: Row(
      children: [
        // widget list
        SizedBox(
          width: 300,
          child: ListTileTheme(
            selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(50),
            selectedColor: Theme.of(context).colorScheme.primary,

            child: Column(
              children: [
                // TODO search
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      for (var w in WidgetCatalog().entries) // TODO add material list
                        ListTile(
                          selected: w.widgetName == selected?.widgetName,
                          leading: w.icon ?? WidgetCatalog().fallbackEntryIcon,
                          title: Text(w.widgetName),
                          onTap: () => setState(() {
                            selected = w;
                          }),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // single widget explorer
        Expanded(child: selected == null ? Placeholder() : CatalogItemView(selected!)),
      ],
    ),
  );
}

class CatalogItemView extends StatefulWidget {
  const CatalogItemView(this.item, {super.key});

  final CatalogEntry item;

  @override
  State<CatalogItemView> createState() => _CatalogItemViewState();
}

class _CatalogItemViewState extends State<CatalogItemView> {
  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Theme.of(context).hintColor),
    ),
    clipBehavior: Clip.hardEdge,
    child: DefaultTabController(
      length: [
        widget.item.docLink,
        widget.item.widgetBuilder,
      ].where((e) => e != null).length,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(24),
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.item.widgetName),
            leading: widget.item.icon,
            actionsPadding: EdgeInsets.only(right: 8),
            actions: [
              if (widget.item.docLink != null)
                IconButton.filledTonal(
                  tooltip: 'Open the documentation',
                  onPressed: () => launchUrl(Uri.parse(widget.item.docLink!)),
                  icon: Icon(Symbols.book_2, fill: 1),
                ),
            ],
            bottom: TabBar(
              tabs: [
                if (widget.item.widgetBuilder != null)
                  Tab(
                    text: 'Widget view',
                    icon: Icon(Symbols.view_in_ar),
                  ),
                if (widget.item.docLink != null)
                  Tab(
                    text: 'Documentation',
                    icon: Icon(Symbols.book_2),
                  ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              if (widget.item.widgetBuilder != null) widget.item.widgetBuilder!.call(CatalogEntryController()),
              if (widget.item.docLink != null) DocsDisplayer(widget.item.docLink!),
            ],
          ),
        ),
      ),
    ),
  );
}
