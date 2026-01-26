import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

CatalogEntry iconCatalogEntry = CatalogEntry(
  'Icon',
  docLink: 'https://api.flutter.dev/flutter/widgets/Icon-class.html',
  icon: Icon(Symbols.emoji_symbols),
  widgetBuilder: (controller) => Icon(
    controller.propertyValues['icon'] ?? Symbols.star,
    color: controller.propertyValues['color'],
    fill: controller.propertyValues['fill'],
    size: controller.propertyValues['size'],
    opticalSize: controller.propertyValues['opticalSize'],
    weight: controller.propertyValues['weight'],
    grade: controller.propertyValues['grade'],
  ),
  defaultParameters: [
    EnumPropertyData('icon', choices: [Symbols.star, Symbols.abc, Symbols.settings, Symbols.pause_circle]),

    ColorPropertyData('color', nullAllowed: true),
    NumRangePropertyData('fill', type: double, defaultValue: null, minimum: 0, maximum: 1, nullAllowed: true),
    NumRangePropertyData('size', type: double, defaultValue: null, minimum: 1, maximum: 100, nullAllowed: true, integersOnly: true, defaultValueWhenNotNull: 24),
    NumRangePropertyData('opticalSize', type: double, defaultValue: null, minimum: 1, maximum: 100, nullAllowed: true, defaultValueWhenNotNull: 48),
    NumRangePropertyData('weight', type: double, defaultValue: null, minimum: 1, maximum: 1000, nullAllowed: true, defaultValueWhenNotNull: 400),
    NumRangePropertyData('grade', type: double, defaultValue: null, minimum: 0, maximum: 100, nullAllowed: true),

    // from icontheme: NumRangePropertyData('opacity', type: double, defaultValue: null, minimum: 0, maximum: 1, nullAllowed: true, defaultValueWhenNotNull: 1),
  ],
);
