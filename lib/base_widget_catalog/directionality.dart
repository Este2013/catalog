import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

CatalogEntry directionalityCatalogEntry = CatalogEntry(
  'Directionality',
  docLink: 'https://api.flutter.dev/flutter/widgets/Directionality-class.html',
  icon: Icon(Symbols.text_rotation_none),
  widgetBuilder: (ctrl, variables) => Directionality(
    textDirection: (variables['textDirection'] ?? 'Left to right') == 'Left to right' ? .ltr : .rtl,
    child: Text('This text is a child widget of Directionality.\nAnother line of text.'),
  ),
  defaultParameters: [
    EnumPropertyData('textDirection', choices: ['Left to right', 'Right to left']),
  ],
);
