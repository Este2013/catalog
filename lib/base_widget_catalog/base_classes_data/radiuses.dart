import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

MultipleObjectTypeChoice radiusChoiceData(String name) => MultipleObjectTypeChoice(
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

Radius radiusFromChoiceData(Map data) {
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

MultipleObjectTypeChoice borderRadiusChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    ObjectPropertyData('.zero', type: BorderRadius, properties: []),

    ObjectPropertyData('.all', type: BorderRadius, properties: [radiusChoiceData('radius')]),
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
      '.only',
      type: BorderRadius,
      properties: [
        radiusChoiceData('bottomLeft'),
        radiusChoiceData('bottomRight'),
        radiusChoiceData('topLeft'),
        radiusChoiceData('topRight'),
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
  ],
);

BorderRadius borderRadiusFromChoiceData(Map data) {
  if (data['.all'] != null) {
    return BorderRadius.all(radiusFromChoiceData(data['.all']['radius']));
  } else if (data['.circular'] != null) {
    return BorderRadius.circular(data['.circular']['radius']);
  } else if (data['.horizontal'] != null) {
    return BorderRadius.horizontal(
      left: radiusFromChoiceData(data['.horizontal']['left']),
      right: radiusFromChoiceData(data['.horizontal']['right']),
    );
  } else if (data['.vertical'] != null) {
    return BorderRadius.vertical(
      top: radiusFromChoiceData(data['.vertical']['top']),
      bottom: radiusFromChoiceData(data['.vertical']['bottom']),
    );
  } else if (data['.only'] != null) {
    return BorderRadius.only(
      topLeft: radiusFromChoiceData(data['.only']['topLeft']),
      topRight: radiusFromChoiceData(data['.only']['topRight']),
      bottomLeft: radiusFromChoiceData(data['.only']['bottomLeft']),
      bottomRight: radiusFromChoiceData(data['.only']['bottomRight']),
    );
  }
  return BorderRadius.zero;
}
