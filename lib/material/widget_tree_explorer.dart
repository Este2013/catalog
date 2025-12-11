import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wrap your screen in this to get:
/// - A FAB that opens a right-side drawer
/// - The drawer shows the widget tree of `child` only.
class WidgetTreeViewer extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const WidgetTreeViewer({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  State<WidgetTreeViewer> createState() => _WidgetTreeViewerState();
}

class _WidgetTreeViewerState extends State<WidgetTreeViewer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext? _childContext;
  DiagnosticsNode? _rootNode;
  bool showNullValues = false;

  bool disposed = false;

  @override
  void dispose() {
    disposed = true;

    super.dispose();
  }

  void _updateTree() {
    if (_childContext == null) return;

    final element = _childContext as Element;

    _rootNode = element.toDiagnosticsNode(
      name: 'root',
      style: DiagnosticsTreeStyle.dense,
    );

    setState(() {});
  }

  void _openTreeDrawer() {
    _updateTree();
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: widget.appBar,
    body: Center(
      child: Builder(
        // This Builder gives us a context whose widget is exactly `widget.child`.
        builder: (ctx) {
          if (!disposed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (disposed) return;
              setState(() {
                _childContext = ctx;
                _rootNode = (_childContext! as Element).toDiagnosticsNode().getChildren().first;
              });
            });
          }
          return widget.child;
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _openTreeDrawer,
      child: const Icon(Icons.account_tree),
    ),
    endDrawer: Drawer(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Widget tree',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => setState(() {
                    showNullValues = !showNullValues;
                  }),
                  icon: Icon(Symbols.block),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _rootNode == null
                      ? Text('Oh hi there')
                      : DiagnosticsTreeView(
                          root: _rootNode!,
                          showNullValues: showNullValues,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class DiagnosticsTreeView extends StatefulWidget {
  final DiagnosticsNode root;

  final int skip;
  final bool showNullValues;

  const DiagnosticsTreeView({super.key, required this.root, this.skip = 0, required this.showNullValues});

  @override
  State<DiagnosticsTreeView> createState() => _DiagnosticsTreeViewState();
}

class _DiagnosticsTreeViewState extends State<DiagnosticsTreeView> {
  @override
  Widget build(BuildContext context) {
    var node = widget.root;
    for (int i = 0; i < widget.skip; i++) {
      node = widget.root.getChildren().first;
    }
    return _DiagnosticsNodeTile(node: widget.root, showNullValues: widget.showNullValues);
  }
}

class _DiagnosticsNodeTile extends StatelessWidget {
  final DiagnosticsNode node;

  final bool showNullValues;

  const _DiagnosticsNodeTile({required this.node, required this.showNullValues});

  @override
  Widget build(BuildContext context) {
    final children = node.getChildren().toList();
    final properties = node.getProperties().toList();
    final hasChildren = children.isNotEmpty;

    // Basic label: e.g. "Container" or "Align(alignment: center)"
    final titleText = node.toDescription();
    final subtitleText = node.runtimeType.toString();

    final propertyWidgets = properties
        .map((p) {
          if (['depth', 'dirty', 'key', 'widget'].contains(p.name)) return null;
          if (!showNullValues && p.toDescription() == 'null') return null;
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 2),
            child: Text(
              '• ${p.name}: ${p.toDescription()}',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 10,
              ),
            ),
          );
        })
        .where((element) => element != null)
        .cast<Widget>();

    if (!hasChildren && properties.isEmpty) {
      return ListTile(
        dense: true,
        title: Text(
          titleText,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
        subtitle: Text(subtitleText, style: const TextStyle(fontSize: 10)),
      );
    }

    return ExpansionTile(
      initiallyExpanded: true,
      dense: true,
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        titleText,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
      subtitle: Text(subtitleText, style: const TextStyle(fontSize: 10)),
      children: [
        ...propertyWidgets,
        ...children.map(
          (c) => _DiagnosticsNodeTile(
            node: c,
            showNullValues: showNullValues,
          ),
        ),
      ],
    );
  }
}
