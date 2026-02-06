import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// TODO Complete this with exemples from the documentation
CatalogEntry clipRectCatalogEntry = CatalogEntry(
  'ClipRect',
  docLink: 'https://api.flutter.dev/flutter/widgets/ClipRect-class.html',
  icon: Icon(Symbols.crop),
  widgetBuilder: (ctrl, variables) => ClipRect(
    clipBehavior: Clip.values.firstWhere((e) => e.name == variables['clipBehavior']),

    child: Align(
      key: Key('child'),
      alignment: Alignment.topCenter,
      heightFactor: 0.5,
      child: Image.asset('assets/imgs/shiroko-dance.gif'),
    ),
  ),
  defaultParameters: [
    EnumPropertyData('clipBehavior', choices: Clip.values.map((e) => e.name).toList(), defaultValue: 'hardEdge'),
  ],
);
