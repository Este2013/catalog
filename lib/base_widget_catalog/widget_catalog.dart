import 'dart:convert';

import 'package:catalog/base_widget_catalog/backdrop_filter.dart';
import 'package:catalog/base_widget_catalog/clip_r_rect.dart';
import 'package:catalog/base_widget_catalog/clip_rect.dart';
import 'package:catalog/base_widget_catalog/custom_paint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
          if (kDebugMode)
            CatalogEntry(
              'TEST',
              widgetBuilder: (controller, evaluatedVariables) => Text(
                JsonEncoder.withIndent(
                  '   ',
                  (object) {
                    if (object is Color) return object.toHexString();
                    return object.toJson();
                  },
                ).convert(evaluatedVariables),
              ),
              defaultParameters: [
                BooleanPropertyData('bool (nullable)', defaultValueWhenNotNull: true, nullAllowed: true),
                BooleanPropertyData('bool - def false'),
                BooleanPropertyData('bool - def true', defaultValue: true),
                ColorPropertyData('color (nullable)', nullAllowed: true),
                ColorPropertyData('color'),
                EnumPropertyData(
                  'enum (nullable)',
                  nullAllowed: true,
                  choices: ['a', 'b', 'c'],
                ),
                EnumPropertyData(
                  'enum',
                  nullAllowed: false,
                  choices: ['a2', 'b2', 'c2'],
                ),
                NumRangePropertyData('num (nullable)', nullAllowed: true, minimum: 0, maximum: 3),
                NumRangePropertyData('num', minimum: 0, maximum: 3),
                NumRangePropertyData('int (nullable)', nullAllowed: true, minimum: 0, maximum: 3, integersOnly: true, defaultValueWhenNotNull: 2),
                NumRangePropertyData('int', minimum: 0, maximum: 3, integersOnly: true, defaultValue: 2),
              ],
            ),
          backdropFilterCatalogEntry,
          clipRectCatalogEntry,
          clipRoundedRectCatalogEntry,
          customPaintCatalogEntry,
          directionalityCatalogEntry,
          iconCatalogEntry,
          opacityCatalogEntry,
          placeholderCatalogEntry,
          shaderMaskCatalogEntry,
        ],
        fallbackEntryIcon: Icon(Symbols.widgets),
      );
}
