import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

// TODO Complete this with exemples from the documentation
CatalogEntry clipRectCatalogEntry = BaseCatalogEntry(
  'ClipRect',
  icon: Icon(Symbols.crop),
  widgetBuilder: (_, ctrl, variables) => ClipRect(
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
