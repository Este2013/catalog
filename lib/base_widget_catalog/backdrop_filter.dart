import 'dart:ui';

import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// TODO Complete this with exemples from the documentation
CatalogEntry backdropFilterCatalogEntry = CatalogEntry(
  'BackdropFilter',
  docLink: 'https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html',
  icon: Icon(Symbols.background_replace_rounded),
  widgetBuilder: (ctrl, variables) => BackdropFilter(
    filter: ImageFilter.blur(),
    child: Text('This text is a child widget of Directionality.\nAnother line of text.'),
  ),
  defaultParameters: [
    // EnumPropertyData('textDirection', choices: ['Left to right', 'Right to left']),
  ],
);
