import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

CatalogEntry alignCatalogEntry = BaseCatalogEntry(
  'Align',
  icon: Icon(Symbols.position_top_right_rounded),
  widgetBuilder: (context, ctrl, variables) {
    Widget w = Align(
      alignment: variables['alignment'],
      heightFactor: variables['heightFactor'],
      widthFactor: variables['widthFactor'],

      child: FlutterLogo(key: Key('child'), size: 100),
    );
    if (variables['Wrap in ClipRect?']) {
      w = ClipRect(child: w);
    }
    return w;
  },
  defaultParameters: [
    EnumPropertyData(
      'alignment',
      choices: [
        Alignment.topLeft,
        Alignment.topCenter,
        Alignment.topRight,
        Alignment.centerLeft,
        Alignment.center,
        Alignment.centerRight,
        Alignment.bottomLeft,
        Alignment.bottomCenter,
        Alignment.bottomRight,
      ],
      defaultValue: Alignment.center,
      valueToString: (value) => value.toString().split('.')[1],
    ),
    NumRangePropertyData('heightFactor', maximum: 2.0, minimum: 0.0, defaultValue: null, defaultValueWhenNotNull: 1.0, nullAllowed: true),
    NumRangePropertyData('widthFactor', maximum: 2.0, minimum: 0.0, defaultValue: null, defaultValueWhenNotNull: 1.0, nullAllowed: true),
    BooleanPropertyData('Wrap in ClipRect?', defaultValue: true),
  ],
);
