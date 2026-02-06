import 'dart:convert';

import 'package:catalog/base_widget_catalog/widget_catalog.dart';
import 'package:catalog/catalog.dart';
import 'package:catalog/docs_display.dart';
import 'package:catalog/material/material_theme_controller.dart';
import 'package:catalog/material/material_theme_dialog.dart';
import 'package:catalog/material/widget_tree_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:material_symbols_icons/symbols.dart';
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
                          visualDensity: VisualDensity.compact,
                          selected: w.widgetName == selected?.widgetName,
                          leading: w.icon ?? w.iconBuilder?.call(context, w.widgetName == selected?.widgetName ? Theme.of(context).colorScheme.primary : null) ?? WidgetCatalog().fallbackEntryIcon,
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
        Expanded(
          child: selected == null ? Placeholder() : CatalogItemView(selected!, key: Key(selected?.widgetName ?? 'no widget')),
        ),
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
  bool showWidgetOptions = true;
  late CatalogEntryController itemController;
  @override
  void initState() {
    itemController = widget.item.createDefaultController();
    super.initState();
  }

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
              if (widget.item.widgetBuilder != null)
                AnimatedBuilder(
                  animation: itemController,
                  builder: (context, _) => Row(
                    children: [
                      if (showWidgetOptions && widget.item.defaultParameters.isNotEmpty)
                        Container(
                          width: 400,
                          padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Widget parameters',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(Symbols.refresh),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: PropertyListBuilder(widget: widget, itemController: itemController),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (showWidgetOptions) VerticalDivider(),
                      Expanded(
                        child: ClipRect(
                          child: Scaffold(
                            drawer: Drawer(
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SingleChildScrollView(
                                  child: SelectableText(
                                    JsonEncoder.withIndent(
                                      '   ',
                                      (o) {
                                        if (o is Alignment) return 'Alignment(${o.x}, ${o.y})';
                                        if (o is Color) return o.toHexString();
                                        if (o is IconData) return 'IconData(U+${o.codePoint.toRadixString(16).toUpperCase()})';
                                        return o.toJson();
                                      },
                                    ).convert(itemController.evaluateVariables()),
                                  ),
                                ),
                              ),
                            ),
                            floatingActionButtonLocation: .startFloat,
                            floatingActionButton: Builder(
                              builder: (context) => FloatingActionButton(
                                onPressed: Scaffold.of(context).openDrawer,
                                child: Icon(Symbols.data_object),
                              ),
                            ),
                            body: WidgetTreeExplorer(
                              child: widget.item.widgetBuilder!.call(itemController, itemController.evaluateVariables()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (widget.item.docLink != null) DocsDisplayer(widget.item.docLink!),
            ],
          ),
        ),
      ),
    ),
  );
}

class PropertyListBuilder extends StatelessWidget {
  const PropertyListBuilder({
    super.key,
    required this.widget,
    required this.itemController,
  });

  final CatalogItemView widget;
  final CatalogEntryController itemController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (var property in itemController.propertyRenderers) PropertyEntryRenderer(property)],
    );
  }
}

class PropertyEntryRenderer extends StatelessWidget {
  const PropertyEntryRenderer(this.propertyRenderer, {super.key});

  final CatalogPropertyRenderObject propertyRenderer;
  CatalogPropertyData get property => propertyRenderer.data;

  @override
  Widget build(BuildContext context) {
    if (property is MultipleObjectTypeChoice) {
      return MultipleObjectChoiceEntryProperty(
        property as MultipleObjectTypeChoice,
        propertyRenderer: propertyRenderer,
        // value: propertyRenderer.isNull ? null : propertyRenderer.value,
        // setNullStatus: (bool b) => propertyRenderer.isNull = b,
      );
    } else if (property is ObjectPropertyData) {
      return Column(
        children: [
          for (var r in propertyRenderer.children) PropertyEntryRenderer(r),
        ],
      );
    } else if (property is BooleanPropertyData) {
      return BooleanCatalogEntryProperty(
        property as BooleanPropertyData,
        renderObject: propertyRenderer,
        // value: propertyRenderer.isNull ? null : propertyRenderer.value,
        editValue: (newValue) {
          if (newValue == null) {
            propertyRenderer.isNull = true;
            return null;
          } else {
            return propertyRenderer.value = newValue;
          }
        },
      );
    } else if (property is NumRangePropertyData) {
      return NumRangeEntryProperty(
        property as NumRangePropertyData,
        renderObject: propertyRenderer,
        // TODO refactor to give propertyRenderer and simplify the value editing code
        // value: propertyRenderer.isNull ? null : propertyRenderer.value,
        // editValue: (newValue) {
        //   if (newValue == null) {
        //     propertyRenderer.isNull = true;
        //     return null;
        //   } else {
        //     return propertyRenderer.value = newValue;
        //   }
        // },
      );
    } else if (property is EnumPropertyData) {
      return EnumEntryProperty(
        property as EnumPropertyData,
        renderObject: propertyRenderer,
      );
    } else if (property is ColorPropertyData) {
      return ColorEntryProperty(
        property as ColorPropertyData,
        renderObject: propertyRenderer,
        editValue: (newValue) {
          if (newValue == null) {
            propertyRenderer.isNull = true;
            return null;
          } else {
            return propertyRenderer.value = newValue;
          }
        },
      );
    } else {
      throw UnimplementedError();
    }
  }
}

class MultipleObjectChoiceEntryProperty<T> extends StatefulWidget {
  const MultipleObjectChoiceEntryProperty(this.data, {super.key, required this.propertyRenderer, /*required this.setNullStatus,*/ this.valueToString});

  final MultipleObjectTypeChoice data;
  // final T value;
  final CatalogPropertyRenderObject propertyRenderer;
  final String? Function(T value)? valueToString;

  @override
  State<MultipleObjectChoiceEntryProperty<T>> createState() => _MultipleObjectChoiceEntryPropertyState<T>();
}

class _MultipleObjectChoiceEntryPropertyState<T> extends State<MultipleObjectChoiceEntryProperty<T>> with TickerProviderStateMixin {
  // TODO render the property name somehow
  // late TabController tabController;
  // @override
  // void initState() {
  //   tabController = TabController(length: widget.data.choices.length + (widget.data.nullAllowed ? 1 : 0), vsync: this);
  //   tabController.addListener(
  //     () {
  //       if (tabController.index == 0 && widget.data.nullAllowed) {
  //         widget.propertyRenderer.isNull = true;
  //       } else {
  //         widget.propertyRenderer.value = widget.data.choices[tabController.index - (widget.data.nullAllowed ? 1 : 0)].name;
  //       }
  //     },
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 600,
      child: Card(
        clipBehavior: .hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: .min,
            children: [
              Row(
                children: [
                  Text(widget.data.name, style: Theme.of(context).textTheme.bodyLarge),
                  Spacer(),
                  DropdownMenu<String>(
                    dropdownMenuEntries: [
                      if (widget.data.nullAllowed) DropdownMenuEntry(value: '', label: 'null'),
                      for (var c in widget.data.choices) DropdownMenuEntry(value: c.name, label: c.name),
                    ],
                    onSelected: (value) {
                      if (value == null) widget.propertyRenderer.value = null;
                      widget.propertyRenderer.value = value;
                    },
                    initialSelection: widget.propertyRenderer.value ?? '',
                  ),
                ],
              ),

              if (widget.propertyRenderer.value == null)
                SizedBox.shrink()
              else ...[
                if (widget.propertyRenderer.children
                    .firstWhere(
                      (e) => e.data.name == widget.propertyRenderer.value,
                    )
                    .children
                    .isNotEmpty)
                  Divider(),
                PropertyEntryRenderer(
                  widget.propertyRenderer.children.firstWhere(
                    (e) => e.data.name == widget.propertyRenderer.value,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CatalogEntryProperty<T> extends StatelessWidget {
  const CatalogEntryProperty(this.data, {super.key, required this.value, required this.child, required this.setNullStatus, this.valueToString});

  final CatalogPropertyData data;
  final T value;
  final String? Function(T value)? valueToString;
  final Widget child;
  final void Function(bool isNowNull) setNullStatus;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: (data.nullAllowed) ? Checkbox(value: value != null, onChanged: (value) => setNullStatus(!value!)) : Tooltip(message: 'This property cannot be set to null', child: Checkbox(value: null, onChanged: null, tristate: true)),
    title: Text(data.name),
    subtitle: Text(valueToString?.call(value) ?? value.toString()),
    trailing: child,
  );
}

class ObjectCatalogEntryProperty<T> extends StatelessWidget {
  const ObjectCatalogEntryProperty(this.data, {super.key, required this.value, required this.editValue});

  final BooleanPropertyData data;

  final bool? value;
  final Function(bool? newValue) editValue;

  @override
  Widget build(BuildContext context) => CatalogEntryProperty<bool?>(
    data,
    value: value,
    child: Switch(value: value ?? false, onChanged: editValue),
    setNullStatus: (isNowNull) => editValue(isNowNull ? null : data.defaultValue ?? false),
  );
}

class BooleanCatalogEntryProperty extends StatelessWidget {
  const BooleanCatalogEntryProperty(this.data, {super.key, required this.renderObject, required this.editValue});

  final BooleanPropertyData data;

  final CatalogPropertyRenderObject renderObject;

  bool? get value => renderObject.isNull ? null : renderObject.value;

  final Function(bool? newValue) editValue;

  @override
  Widget build(BuildContext context) => CatalogEntryProperty<bool?>(
    data,
    value: value,
    child: Switch(value: value ?? false, onChanged: editValue),
    setNullStatus: (isNowNull) {
      renderObject.isNull = isNowNull;
    },
  );
}

class NumRangeEntryProperty extends StatelessWidget {
  const NumRangeEntryProperty(this.data, {super.key, required this.renderObject /* required this.value, required this.editValue */});

  final NumRangePropertyData data;

  final CatalogPropertyRenderObject renderObject;

  num? get value => renderObject.isNull ? null : renderObject.value;

  @override
  Widget build(BuildContext context) => CatalogEntryProperty<num?>(
    data,
    value: value,
    child: SizedBox(
      width: 150,
      child: Slider(
        value: value?.toDouble() ?? data.minimum.toDouble(),
        onChanged: (newValue) => renderObject.value = newValue,
        min: data.minimum.toDouble(),
        max: data.maximum.toDouble(),
        divisions: data.integersOnly ? data.maximum.round() - data.minimum.round() : null,
      ),
    ),
    setNullStatus: (isNowNull) {
      renderObject.isNull = isNowNull;
      if (!isNowNull && value == null) {
        renderObject.value = data.defaultValueWhenNotNull;
      }
    },
    valueToString: (value) => data.integersOnly ? value?.toInt().toString() : value?.toStringAsPrecision(3),
  );
}

class EnumEntryProperty<T extends Object> extends StatelessWidget {
  const EnumEntryProperty(this.data, {super.key, required this.renderObject});

  final EnumPropertyData<T> data;

  final CatalogPropertyRenderObject renderObject;

  T? get value => renderObject.isNull ? null : renderObject.value;

  @override
  Widget build(BuildContext context) => CatalogEntryProperty<T?>(
    data,
    value: value,
    valueToString: data.valueToString,
    setNullStatus: (isNowNull) {
      renderObject.isNull = isNowNull;
    },
    child: SizedBox(
      width: 150,
      child: DropdownMenu(
        initialSelection: renderObject.value ?? data.choices.first,
        onSelected: (value) => renderObject.value = value,
        dropdownMenuEntries: [
          for (var v in data.choices)
            DropdownMenuEntry(
              value: v,
              label: data.valueToString?.call(v) ?? v.toString(),
            ),
        ],
      ),
    ),
  );
}

class ColorEntryProperty extends StatelessWidget {
  const ColorEntryProperty(this.data, {super.key, required this.renderObject, required this.editValue});

  final ColorPropertyData data;
  final CatalogPropertyRenderObject renderObject;

  Color? get value => renderObject.isNull ? null : renderObject.value;

  final Function(Color? newValue) editValue;

  @override
  Widget build(BuildContext context) => CatalogEntryProperty(
    data,
    value: value,
    child: Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        for (var c in data.choices ?? [Theme.brightnessOf(context) == .light ? Colors.black : Colors.white, Theme.of(context).colorScheme.primary, Colors.lightBlue, Colors.green, Colors.amber, Colors.red])
          Container(
            width: c == value ? 24 : 22,
            height: c == value ? 24 : 22,
            decoration: BoxDecoration(
              color: c,
              border: Border.all(color: Colors.black, width: c == value ? 4 : 1),
              borderRadius: BorderRadius.circular(4),
            ),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => editValue(c),
            ),
          ),
      ],
    ),
    setNullStatus: (isNowNull) {
      renderObject.isNull = isNowNull;
    },
    valueToString: (value) => value?.toHexString(),
  );
}
