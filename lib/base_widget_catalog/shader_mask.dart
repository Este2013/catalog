import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'widget_catalog.dart';

// TODO complete this entry

CatalogEntry shaderMaskCatalogEntry = BaseCatalogEntry(
  'ShaderMask',
  icon: Icon(Symbols.shadow_rounded),
  widgetBuilder: (_, controller, variables) => ShaderMask(
    blendMode: BlendMode.values.firstWhere((e) => e.name == variables['blendMode']),
    shaderCallback: (bounds) {
      Gradient grad;
      if (variables['shaderCallback']?['RadialGradient'] != null) {
        grad = RadialGradient(
          center: variables['shaderCallback']['RadialGradient']['alignment'],
          radius: 1.0,
          colors: [Colors.deepOrange.shade900, Colors.amber.shade700, Colors.green],
          tileMode: TileMode.mirror,
        );
      } else if (variables['shaderCallback']?['LinearGradient'] != null) {
        grad = LinearGradient(
          colors: [Colors.deepOrange.shade900, Colors.amber.shade700, Colors.green],
          tileMode: TileMode.mirror,
        );
      } else if (variables['shaderCallback']?['SweepGradient'] != null) {
        grad = SweepGradient(
          colors: [Colors.deepOrange.shade900, Colors.amber.shade700, Colors.green],
          tileMode: TileMode.mirror,
        );
      } else {
        throw UnimplementedError();
      }
      return grad.createShader(bounds);
    },
    child: Container(
      width: 200,
      height: 200,
      color: Colors.white,
      child: Center(child: Text('This box and text are children of this ShaderMask.')),
    ),
  ),
  defaultParameters: [
    EnumPropertyData(
      'blendMode',
      defaultValue: "modulate",
      choices: BlendMode.values.map((e) => e.name).toList(),
      nullAllowed: false,
    ),
    MultipleObjectTypeChoice(
      'shaderCallback',
      nullAllowed: false,
      choices: [
        ObjectPropertyData(
          'LinearGradient',
          type: Gradient,
          properties: [
            // ObjectPropertyData(name, type: type, properties: properties)
          ],
        ),
        ObjectPropertyData(
          'RadialGradient',
          type: Gradient,
          properties: [
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
              defaultValueWhenNotNull: Alignment.center,
              nullAllowed: false,
              valueToString: (value) => value.toString().split('.')[1],
            ),
          ],
        ),
        ObjectPropertyData(
          'SweepGradient',
          type: Gradient,
          properties: [
            // ObjectPropertyData(name, type: type, properties: properties)
          ],
        ),
      ],
    ),
  ],
);
