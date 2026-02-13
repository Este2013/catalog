import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'base_classes_data/radiuses.dart';
import 'widget_catalog.dart';

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
        left: radiusFromChoiceData(variables['borderRadius']['.horizontal']['left']),
        right: radiusFromChoiceData(variables['borderRadius']['.horizontal']['right']),
      );
    }
    if (variables['borderRadius']['.vertical'] != null) {
      rad = BorderRadius.vertical(
        top: radiusFromChoiceData(variables['borderRadius']['.vertical']['top']),
        bottom: radiusFromChoiceData(variables['borderRadius']['.vertical']['bottom']),
      );
    }
    if (variables['borderRadius']['.only'] != null) {
      rad = BorderRadius.only(
        bottomLeft: radiusFromChoiceData(variables['borderRadius']['.only']['bottomLeft']),
        bottomRight: radiusFromChoiceData(variables['borderRadius']['.only']['bottomRight']),
        topLeft: radiusFromChoiceData(variables['borderRadius']['.only']['topLeft']),
        topRight: radiusFromChoiceData(variables['borderRadius']['.only']['topRight']),
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
            radiusChoiceData('left'),
            radiusChoiceData('right'),
          ],
        ),
        ObjectPropertyData(
          '.vertical',
          type: BorderRadius,
          properties: [
            radiusChoiceData('top'),
            radiusChoiceData('bottom'),
          ],
        ),
        ObjectPropertyData(
          '.only',
          type: BorderRadius,
          properties: [
            radiusChoiceData('bottomLeft'),
            radiusChoiceData('bottomRight'),
            radiusChoiceData('topLeft'),
            radiusChoiceData('topRight'),
          ],
        ),
      ],
    ),
  ],
);
