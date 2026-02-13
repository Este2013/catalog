import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'base_classes_data/radiuses.dart';
import 'widget_catalog.dart';

CatalogEntry physicalModelCatalogEntry = BaseCatalogEntry(
  'PhysicalModel',
  icon: Icon(Symbols.shadow),
  widgetBuilder: (context, ctrl, variables) => PhysicalModel(
    color: variables['color'],
    borderRadius: borderRadiusFromChoiceData(variables['borderRadius']),
    //(radiusFromChoiceData(variables['borderRadius'])),
    clipBehavior: Clip.values.firstWhere((e) => e.name == variables['clipBehavior']),
    elevation: variables['elevation'],
    shadowColor: variables['shadowColor'],
    // TODO the shape parameter is not actually set anywhere
    shape: variables['shape'] ?? BoxShape.rectangle,
    child: Image.asset('assets/imgs/shiroko-dance.gif'),
  ),
  defaultParameters: [
    ColorPropertyData('color', defaultValue: Colors.black),
    EnumPropertyData('clipBehavior', choices: Clip.values.map((e) => e.name).toList(), defaultValue: 'none'),
    NumRangePropertyData('elevation', maximum: 50.0, minimum: 0.0, defaultValue: 0.0),

    ColorPropertyData('shadowColor', defaultValue: Colors.black),
    borderRadiusChoiceData('borderRadius'),
  ],
);
