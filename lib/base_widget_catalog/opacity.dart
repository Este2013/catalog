import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

CatalogEntry opacityCatalogEntry = CatalogEntry(
  'Opacity',
  docLink: 'https://api.flutter.dev/flutter/widgets/Opacity-class.html',
  icon: Icon(Symbols.opacity),
  widgetBuilder: (controller, variables) => Opacity(
    opacity: variables['opacity'],
    alwaysIncludeSemantics: variables['alwaysIncludeSemantics'],
    child: Text(
      'This text is a child widget of Opacity.',
      semanticsLabel: 'Some semantics label',
    ),
  ),
  defaultParameters: [
    NumRangePropertyData(
      'opacity',
      defaultValueWhenNotNull: 1.0,
      minimum: 0.0,
      maximum: 1.0,
      defaultValue: 1.0,
      nullAllowed: false,
    ),
    BooleanPropertyData('alwaysIncludeSemantics', defaultValue: false),
  ],
);
