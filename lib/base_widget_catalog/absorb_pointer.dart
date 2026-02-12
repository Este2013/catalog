import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

CatalogEntry absorbPointerCatalogEntry = BaseCatalogEntry(
  'AbsorbPointer',
  icon: Icon(Symbols.mouse_lock),
  widgetBuilder: (context, ctrl, variables) => AbsorbPointer(
    absorbing: variables['absorbing'],
    child: FilledButton(
      key: Key('child'),
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The button has been clicked'))),
      child: Text('Try to click me :D'),
    ),
  ),
  defaultParameters: [
    BooleanPropertyData('absorbing', defaultValue: true),
  ],
);
