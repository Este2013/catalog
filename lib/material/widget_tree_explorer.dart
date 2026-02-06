import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wrap your screen in this to get:
/// - A FAB that opens a right-side drawer
/// - The drawer shows the widget tree of `child` only.
class WidgetTreeExplorer extends StatefulWidget {
  final Widget child;

  const WidgetTreeExplorer({
    super.key,
    required this.child,
  });

  @override
  State<WidgetTreeExplorer> createState() => _WidgetTreeExplorerState();
}

class _WidgetTreeExplorerState extends State<WidgetTreeExplorer> {
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

  @override
  Widget build(BuildContext context) => Scaffold(
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

    floatingActionButton: Builder(
      builder: (context) {
        return FloatingActionButton(
          onPressed: () {
            _updateTree();
            Scaffold.of(context).openEndDrawer();
          },
          child: const Icon(Icons.account_tree),
        );
      },
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
                  isSelected: showNullValues,
                  selectedIcon: Icon(Symbols.circle),
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
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: _DiagnosticsNodeTile(node: node, showNullValues: widget.showNullValues),
    );
  }
}

class _DiagnosticsNodeTile extends StatelessWidget {
  final DiagnosticsNode node;
  final int depth;

  final bool showNullValues;

  const _DiagnosticsNodeTile({required this.node, required this.showNullValues, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final children = node.getChildren().toList();
    final properties = node.getProperties().toList();
    final hasChildren = children.isNotEmpty;

    // Basic label: e.g. "Container" or "Align(alignment: center)"
    final titleText = node.toDescription();

    final propertyWidgets = properties
        .map((p) {
          if (['depth', 'dirty', 'key', 'widget'].contains(p.name)) return null;
          if (!showNullValues && p.toDescription() == 'null') return null;
          return Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 2),
            child: SelectableText(
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
        visualDensity: VisualDensity.compact,
        title: SelectableText(
          titleText,
          style: const TextStyle(fontFamily: 'monospace', fontWeight: .bold),
        ),
      );
    }

    if (depth == 0) {
      return Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            titleText,
            style: const TextStyle(fontFamily: 'monospace', fontWeight: .bold),
          ),

          ...propertyWidgets,
          ...children.map(
            (c) => _DiagnosticsNodeTile(
              node: c,
              showNullValues: showNullValues,
              depth: depth + 1,
            ),
          ),
        ],
      );
    }
    return Card(
      color: depth % 2 == 0 ? null : Theme.of(context).colorScheme.surfaceContainerHighest,
      margin: depth == 0 ? EdgeInsets.zero : EdgeInsets.only(left: 8, top: 8),
      clipBehavior: .hardEdge,
      child: ExpansionTile(
        initiallyExpanded: true,
        dense: true,
        visualDensity: VisualDensity.compact,
        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(
          titleText,
          style: const TextStyle(fontFamily: 'monospace', fontWeight: .bold),
        ),

        expandedAlignment: .centerLeft,
        expandedCrossAxisAlignment: .start,
        children: [
          ...propertyWidgets,
          ...children.map(
            (c) => _DiagnosticsNodeTile(
              node: c,
              showNullValues: showNullValues,
              depth: depth + 1,
            ),
          ),
        ],
      ),
    );
  }
}
