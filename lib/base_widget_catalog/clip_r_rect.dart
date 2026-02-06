import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

MultipleObjectTypeChoice _radiusChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    ObjectPropertyData('.zero', type: BorderRadius, properties: []),
    ObjectPropertyData(
      '.circular',
      type: BorderRadius,
      properties: [
        NumRangePropertyData('radius', minimum: 00.0, maximum: 150.0),
      ],
    ),
    ObjectPropertyData(
      '.elliptical',
      type: BorderRadius,
      properties: [
        NumRangePropertyData('x', minimum: 00.0, maximum: 150.0),
        NumRangePropertyData('y', minimum: 00.0, maximum: 150.0),
      ],
    ),
  ],
);

CatalogEntry clipRoundedRectCatalogEntry = CatalogEntry(
  'ClipRRect',
  docLink: 'https://api.flutter.dev/flutter/widgets/ClipRRect-class.html',
  icon: Icon(Symbols.crop),
  widgetBuilder: (ctrl, variables) {
    BorderRadius? rad;
    if (variables['borderRadius']['.circular'] != null) {
      rad = BorderRadius.circular(variables['borderRadius']['.circular']['radius']);
    }
    if (variables['borderRadius']['.horizontal'] != null) {
      // rad = BorderRadius.horizontal(left: Rad);
    }
    rad ??= BorderRadius.zero;

    return ClipRRect(
      borderRadius: rad,
      clipBehavior: Clip.values.firstWhere((e) => e.name == variables['clipBehavior']),
      child: Image.asset('assets/imgs/shiroko-dance.gif'),
    );
  },
  defaultParameters: [
    EnumPropertyData('clipBehavior', choices: Clip.values.map((e) => e.name).toList(), defaultValue: 'hardEdge'),
    MultipleObjectTypeChoice(
      'borderRadius',
      nullAllowed: false,
      choices: [
        ObjectPropertyData('.zero', type: BorderRadius, properties: []),
        ObjectPropertyData(
          '.circular',
          type: BorderRadius,
          properties: [
            NumRangePropertyData('radius', minimum: 00.0, maximum: 150.0),
          ],
        ),
        ObjectPropertyData(
          '.horizontal',
          type: BorderRadius,
          properties: [
            _radiusChoiceData('left'),
            _radiusChoiceData('right'),
          ],
        ),
      ],
    ),
  ],
);
