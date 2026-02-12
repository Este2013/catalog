import 'dart:ui';

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

// TODO Complete this with exemples from the documentation
CatalogEntry backdropFilterCatalogEntry = BaseCatalogEntry(
  'BackdropFilter',
  icon: Icon(Symbols.background_replace_rounded),
  widgetBuilder: (_, ctrl, variables) => BackdropFilter(
    filter: ImageFilter.blur(),
    child: Text('This text is a child widget of Directionality.\nAnother line of text.'),
  ),
  defaultParameters: [
    // EnumPropertyData('textDirection', choices: ['Left to right', 'Right to left']),
  ],
);
