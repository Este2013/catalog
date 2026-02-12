import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

CatalogEntry directionalityCatalogEntry = BaseCatalogEntry(
  'Directionality',
  icon: Icon(Symbols.text_rotation_none),
  widgetBuilder: (_, ctrl, variables) => Directionality(
    textDirection: (variables['textDirection'] ?? 'Left to right') == 'Left to right' ? .ltr : .rtl,
    child: Text('This text is a child widget of Directionality.\nAnother line of text.'),
  ),
  defaultParameters: [
    EnumPropertyData('textDirection', choices: ['Left to right', 'Right to left']),
  ],
);
