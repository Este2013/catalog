import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

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

Radius fromChoiceData(Map data) {
  if (data['.circular'] != null) {
    return Radius.circular(data['.circular']['radius']);
  } else if (data['.elliptical'] != null) {
    return Radius.elliptical(
      data['.elliptical']['x'],
      data['.elliptical']['y'],
    );
  }
  return Radius.zero;
}

CatalogEntry clipRRectCatalogEntry = BaseCatalogEntry(
  'ClipRRect',
  icon: Icon(Symbols.crop),
  widgetBuilder: (_, ctrl, variables) {
    BorderRadius? rad;
    if (variables['borderRadius']['.circular'] != null) {
      rad = BorderRadius.circular(variables['borderRadius']['.circular']['radius']);
    }
    if (variables['borderRadius']['.horizontal'] != null) {
      rad = BorderRadius.horizontal(
        left: fromChoiceData(variables['borderRadius']['.horizontal']['left']),
        right: fromChoiceData(variables['borderRadius']['.horizontal']['right']),
      );
    }
    if (variables['borderRadius']['.vertical'] != null) {
      rad = BorderRadius.vertical(
        top: fromChoiceData(variables['borderRadius']['.vertical']['top']),
        bottom: fromChoiceData(variables['borderRadius']['.vertical']['bottom']),
      );
    }
    if (variables['borderRadius']['.only'] != null) {
      rad = BorderRadius.only(
        bottomLeft: fromChoiceData(variables['borderRadius']['.only']['bottomLeft']),
        bottomRight: fromChoiceData(variables['borderRadius']['.only']['bottomRight']),
        topLeft: fromChoiceData(variables['borderRadius']['.only']['topLeft']),
        topRight: fromChoiceData(variables['borderRadius']['.only']['topRight']),
      );
    }
    rad ??= BorderRadius.zero;

    return ClipRRect(
      borderRadius: rad,
      clipBehavior: Clip.values.firstWhere((e) => e.name == variables['clipBehavior']),
      child: Image.asset(
        'assets/imgs/shiroko-dance.gif',
        key: Key('child'),
      ),
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
        ObjectPropertyData(
          '.vertical',
          type: BorderRadius,
          properties: [
            _radiusChoiceData('top'),
            _radiusChoiceData('bottom'),
          ],
        ),
        ObjectPropertyData(
          '.only',
          type: BorderRadius,
          properties: [
            _radiusChoiceData('bottomLeft'),
            _radiusChoiceData('bottomRight'),
            _radiusChoiceData('topLeft'),
            _radiusChoiceData('topRight'),
          ],
        ),
      ],
    ),
  ],
);
