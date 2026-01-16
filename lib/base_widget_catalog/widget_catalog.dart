import 'package:catalog/base_widget_catalog/icon.dart';
import 'package:catalog/base_widget_catalog/placeholder.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Common widgets from flutter/widgets.dart.
class WidgetCatalog extends Catalog {
  WidgetCatalog()
    : super(
        catalogName: 'Widgets',
        catalogPackage: 'flutter/widgets.dart',
        entries: [
          iconCatalogEntry,
          placeholderCatalogEntry,
        ],
        fallbackEntryIcon: Icon(Symbols.widgets),
      );
}
