import 'directionality.dart';
import 'icon.dart';
import 'opacity.dart';
import 'placeholder.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'shader_mask.dart';

/// Common widgets from flutter/widgets.dart.
class WidgetCatalog extends Catalog {
  WidgetCatalog()
    : super(
        catalogName: 'Widgets',
        catalogPackage: 'flutter/widgets.dart',
        entries: [
          directionalityCatalogEntry,
          iconCatalogEntry,
          opacityCatalogEntry,
          placeholderCatalogEntry,
          shaderMaskCatalogEntry,
        ],
        fallbackEntryIcon: Icon(Symbols.widgets),
      );
}
