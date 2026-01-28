import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

CatalogEntry shaderMaskCatalogEntry = CatalogEntry(
  'ShaderMask',
  docLink: 'https://api.flutter.dev/flutter/widgets/ShaderMask-class.html',
  icon: Icon(Symbols.shadow_rounded),
  widgetBuilder: (controller, variables) => ShaderMask(
    blendMode: BlendMode.modulate,
    shaderCallback: (bounds) {
      return RadialGradient(
        center: Alignment.topLeft,
        radius: 1.0,
        colors: [Colors.deepOrange.shade900, Colors.amber.shade700, Colors.green],
        tileMode: TileMode.mirror,
      ).createShader(bounds);
    },
    child: Text(
      'This text is a child widget of Opacity.',
      style: TextStyle(color: Colors.white),
    ),
  ),
  defaultParameters: [
    MultipleObjectTypeChoice(
      'shaderCallback',
      nullAllowed: true,
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
            // ObjectPropertyData(name, type: type, properties: properties)
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
