import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

CatalogEntry transformCatalogEntry = BaseCatalogEntry(
  'Transform',
  icon: Icon(Symbols.transform),
  widgetBuilder: (context, ctrl, variables) => Transform.flip(
    child: Image.asset('assets/imgs/shiroko-dance.gif'),
  ),
  defaultParameters: [
    MultipleObjectTypeChoice(
      'Constructor',
      nullAllowed: false,
      choices: [
        ObjectPropertyData(
          'Transform',
          type: Transform,
          properties: [],
        ),
        ObjectPropertyData(
          '.flip',
          type: Transform,
          properties: [],
        ),
        ObjectPropertyData(
          '.rotate',
          type: Transform,
          properties: [],
        ),
        ObjectPropertyData(
          '.scale',
          type: Transform,
          properties: [],
        ),
        ObjectPropertyData(
          '.translate',
          type: Transform,
          properties: [],
        ),
      ],
    ),
  ],
);
