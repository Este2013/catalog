import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

var alignmentChoiceData = EnumPropertyData(
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
);
