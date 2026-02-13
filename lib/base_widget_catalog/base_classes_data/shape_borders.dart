import 'radiuses.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';

/// -------------------------
/// BorderSide
/// -------------------------

MultipleObjectTypeChoice borderSideChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    ObjectPropertyData('.none', type: BorderSide, properties: const []),
    ObjectPropertyData(
      '.new',
      type: BorderSide,
      properties: [
        // BorderSide({color, width, style, strokeAlign}) :contentReference[oaicite:6]{index=6}
        ColorPropertyData('color', defaultValue: const Color(0xFF000000)),
        NumRangePropertyData('width', minimum: 0.0, maximum: 50.0, defaultValueWhenNotNull: 1.0),
        EnumPropertyData<BorderStyle>(
          'style',
          choices: BorderStyle.values,
          defaultValueWhenNotNull: BorderStyle.solid,
        ),
        // strokeAlign is double, typical -1..1 (inside..outside). :contentReference[oaicite:7]{index=7}
        NumRangePropertyData('strokeAlign', minimum: -2.0, maximum: 2.0, defaultValueWhenNotNull: BorderSide.strokeAlignInside),
      ],
    ),
  ],
);

BorderSide borderSideFromChoiceData(Map data) {
  if (data['.new'] != null) {
    final m = data['.new'] as Map;
    return BorderSide(
      color: m['color'] as Color,
      width: (m['width'] as num).toDouble(),
      style: m['style'] as BorderStyle,
      strokeAlign: (m['strokeAlign'] as num).toDouble(),
    );
  }
  return BorderSide.none;
}

/// -------------------------
/// LinearBorder helpers
/// (use named constructors so we don't need LinearBorderEdge encoding)
/// -------------------------

MultipleObjectTypeChoice linearBorderChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    ObjectPropertyData(
      '.top',
      type: LinearBorder,
      properties: [
        borderSideChoiceData('side'),
        NumRangePropertyData('alignment', minimum: -1.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('size', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 1.0),
      ],
    ),
    ObjectPropertyData(
      '.bottom',
      type: LinearBorder,
      properties: [
        borderSideChoiceData('side'),
        NumRangePropertyData('alignment', minimum: -1.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('size', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 1.0),
      ],
    ),
    ObjectPropertyData(
      '.start',
      type: LinearBorder,
      properties: [
        borderSideChoiceData('side'),
        NumRangePropertyData('alignment', minimum: -1.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('size', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 1.0),
      ],
    ),
    ObjectPropertyData(
      '.end',
      type: LinearBorder,
      properties: [
        borderSideChoiceData('side'),
        NumRangePropertyData('alignment', minimum: -1.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('size', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 1.0),
      ],
    ),
  ],
);

LinearBorder linearBorderFromChoiceData(Map data) {
  if (data['.top'] != null) {
    final m = data['.top'] as Map;
    return LinearBorder.top(
      side: borderSideFromChoiceData(m['side'] as Map),
      alignment: (m['alignment'] as num).toDouble(),
      size: (m['size'] as num).toDouble(),
    );
  } else if (data['.bottom'] != null) {
    final m = data['.bottom'] as Map;
    return LinearBorder.bottom(
      side: borderSideFromChoiceData(m['side'] as Map),
      alignment: (m['alignment'] as num).toDouble(),
      size: (m['size'] as num).toDouble(),
    );
  } else if (data['.start'] != null) {
    final m = data['.start'] as Map;
    return LinearBorder.start(
      side: borderSideFromChoiceData(m['side'] as Map),
      alignment: (m['alignment'] as num).toDouble(),
      size: (m['size'] as num).toDouble(),
    );
  } else if (data['.end'] != null) {
    final m = data['.end'] as Map;
    return LinearBorder.end(
      side: borderSideFromChoiceData(m['side'] as Map),
      alignment: (m['alignment'] as num).toDouble(),
      size: (m['size'] as num).toDouble(),
    );
  }
  // Fallback
  return LinearBorder.top();
}

/// -------------------------
/// Border / BorderDirectional
/// -------------------------

MultipleObjectTypeChoice borderChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    ObjectPropertyData(
      '.all',
      type: Border,
      properties: [
        ColorPropertyData('color', defaultValue: const Color(0xFF000000)),
        NumRangePropertyData('width', minimum: 0.0, maximum: 50.0, defaultValueWhenNotNull: 1.0),
        EnumPropertyData<BorderStyle>('style', choices: BorderStyle.values, defaultValueWhenNotNull: BorderStyle.solid),
        NumRangePropertyData('strokeAlign', minimum: -2.0, maximum: 2.0, defaultValueWhenNotNull: BorderSide.strokeAlignInside),
      ],
    ),
    ObjectPropertyData(
      '.only',
      type: Border,
      properties: [
        borderSideChoiceData('top'),
        borderSideChoiceData('right'),
        borderSideChoiceData('bottom'),
        borderSideChoiceData('left'),
      ],
    ),
  ],
);

Border borderFromChoiceData(Map data) {
  if (data['.all'] != null) {
    final m = data['.all'] as Map;
    return Border.all(
      color: m['color'] as Color,
      width: (m['width'] as num).toDouble(),
      style: m['style'] as BorderStyle,
      strokeAlign: (m['strokeAlign'] as num).toDouble(),
    );
  } else if (data['.only'] != null) {
    final m = data['.only'] as Map;
    return Border(
      top: borderSideFromChoiceData(m['top'] as Map),
      right: borderSideFromChoiceData(m['right'] as Map),
      bottom: borderSideFromChoiceData(m['bottom'] as Map),
      left: borderSideFromChoiceData(m['left'] as Map),
    );
  }
  return const Border();
}

MultipleObjectTypeChoice borderDirectionalChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    ObjectPropertyData(
      '.only',
      type: BorderDirectional,
      properties: [
        borderSideChoiceData('top'),
        borderSideChoiceData('start'),
        borderSideChoiceData('end'),
        borderSideChoiceData('bottom'),
      ],
    ),
  ],
);

BorderDirectional borderDirectionalFromChoiceData(Map data) {
  if (data['.only'] != null) {
    final m = data['.only'] as Map;
    return BorderDirectional(
      top: borderSideFromChoiceData(m['top'] as Map),
      start: borderSideFromChoiceData(m['start'] as Map),
      end: borderSideFromChoiceData(m['end'] as Map),
      bottom: borderSideFromChoiceData(m['bottom'] as Map),
    );
  }
  return const BorderDirectional();
}

/// -------------------------
/// ShapeBorder (main)
/// Requires your existing:
/// - borderRadiusChoiceData(...)
/// - borderRadiusFromChoiceData(...)
/// -------------------------

MultipleObjectTypeChoice shapeBorderChoiceData(String name) => MultipleObjectTypeChoice(
  name,
  nullAllowed: false,
  choices: [
    /// OutlinedBorder family
    ObjectPropertyData(
      '.roundedRectangle',
      type: RoundedRectangleBorder,
      properties: [
        borderSideChoiceData('side'),
        borderRadiusChoiceData('borderRadius'),
      ],
    ),
    ObjectPropertyData(
      '.beveledRectangle',
      type: BeveledRectangleBorder,
      properties: [
        borderSideChoiceData('side'),
        borderRadiusChoiceData('borderRadius'),
      ],
    ),
    ObjectPropertyData(
      '.continuousRectangle',
      type: ContinuousRectangleBorder,
      properties: [
        borderSideChoiceData('side'),
        borderRadiusChoiceData('borderRadius'),
      ],
    ),
    ObjectPropertyData(
      '.roundedSuperellipse',
      type: RoundedSuperellipseBorder,
      properties: [
        borderSideChoiceData('side'),
        // RoundedSuperellipseBorder(borderRadius can be null, but you can still encode as non-null.) :contentReference[oaicite:8]{index=8}
        borderRadiusChoiceData('borderRadius'),
      ],
    ),
    ObjectPropertyData(
      '.circle',
      type: CircleBorder,
      properties: [
        borderSideChoiceData('side'),
        // 0..1 :contentReference[oaicite:9]{index=9}
        NumRangePropertyData('eccentricity', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
      ],
    ),
    ObjectPropertyData(
      '.stadium',
      type: StadiumBorder,
      properties: [
        borderSideChoiceData('side'),
      ],
    ),
    ObjectPropertyData(
      '.oval',
      type: OvalBorder,
      properties: [
        borderSideChoiceData('side'),
        // OvalBorder eccentricity default 1.0 :contentReference[oaicite:10]{index=10}
        NumRangePropertyData('eccentricity', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 1.0),
      ],
    ),

    /// StarBorder (+ polygon)
    ObjectPropertyData(
      '.star',
      type: StarBorder,
      properties: [
        borderSideChoiceData('side'),
        NumRangePropertyData('points', minimum: 3.0, maximum: 16.0, defaultValueWhenNotNull: 5.0),
        NumRangePropertyData('innerRadiusRatio', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.4),
        NumRangePropertyData('pointRounding', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('valleyRounding', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        // rotation is in clockwise degrees :contentReference[oaicite:11]{index=11}
        NumRangePropertyData('rotation', minimum: -360.0, maximum: 360.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('squash', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
      ],
    ),
    ObjectPropertyData(
      '.polygon',
      type: StarBorder,
      properties: [
        borderSideChoiceData('side'),
        NumRangePropertyData('sides', minimum: 3.0, maximum: 64.0, defaultValueWhenNotNull: 5.0),
        NumRangePropertyData('pointRounding', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('rotation', minimum: -360.0, maximum: 360.0, defaultValueWhenNotNull: 0.0),
        NumRangePropertyData('squash', minimum: 0.0, maximum: 1.0, defaultValueWhenNotNull: 0.0),
      ],
    ),

    /// BoxBorder family
    ObjectPropertyData(
      '.border',
      type: Border,
      properties: [
        borderChoiceData('border'),
      ],
    ),
    ObjectPropertyData(
      '.borderDirectional',
      type: BorderDirectional,
      properties: [
        borderDirectionalChoiceData('borderDirectional'),
      ],
    ),

    /// LinearBorder (OutlinedBorder)
    ObjectPropertyData(
      '.linear',
      type: LinearBorder,
      properties: [
        linearBorderChoiceData('linear'),
      ],
    ),

    /// InputBorder family (still ShapeBorder)
    ObjectPropertyData(
      '.outlineInput',
      type: OutlineInputBorder,
      properties: [
        borderRadiusChoiceData('borderRadius'),
        borderSideChoiceData('borderSide'),
        NumRangePropertyData('gapPadding', minimum: 0.0, maximum: 32.0, defaultValueWhenNotNull: 4.0),
      ],
    ),
    ObjectPropertyData(
      '.underlineInput',
      type: UnderlineInputBorder,
      properties: [
        borderRadiusChoiceData('borderRadius'),
        borderSideChoiceData('borderSide'),
      ],
    ),
  ],
);

ShapeBorder shapeBorderFromChoiceData(Map data) {
  if (data['.roundedRectangle'] != null) {
    final m = data['.roundedRectangle'] as Map;
    return RoundedRectangleBorder(
      borderRadius: borderRadiusFromChoiceData(m['borderRadius'] as Map),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.beveledRectangle'] != null) {
    final m = data['.beveledRectangle'] as Map;
    return BeveledRectangleBorder(
      borderRadius: borderRadiusFromChoiceData(m['borderRadius'] as Map),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.continuousRectangle'] != null) {
    final m = data['.continuousRectangle'] as Map;
    return ContinuousRectangleBorder(
      borderRadius: borderRadiusFromChoiceData(m['borderRadius'] as Map),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.roundedSuperellipse'] != null) {
    final m = data['.roundedSuperellipse'] as Map;
    return RoundedSuperellipseBorder(
      borderRadius: borderRadiusFromChoiceData(m['borderRadius'] as Map),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.circle'] != null) {
    final m = data['.circle'] as Map;
    return CircleBorder(
      eccentricity: (m['eccentricity'] as num).toDouble(),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.stadium'] != null) {
    final m = data['.stadium'] as Map;
    return StadiumBorder(
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.oval'] != null) {
    final m = data['.oval'] as Map;
    return OvalBorder(
      eccentricity: (m['eccentricity'] as num).toDouble(),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.star'] != null) {
    final m = data['.star'] as Map;
    return StarBorder(
      points: (m['points'] as num).toDouble(),
      innerRadiusRatio: (m['innerRadiusRatio'] as num).toDouble(),
      pointRounding: (m['pointRounding'] as num).toDouble(),
      valleyRounding: (m['valleyRounding'] as num).toDouble(),
      rotation: (m['rotation'] as num).toDouble(),
      squash: (m['squash'] as num).toDouble(),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.polygon'] != null) {
    final m = data['.polygon'] as Map;
    return StarBorder.polygon(
      sides: (m['sides'] as num).toDouble(),
      pointRounding: (m['pointRounding'] as num).toDouble(),
      rotation: (m['rotation'] as num).toDouble(),
      squash: (m['squash'] as num).toDouble(),
      side: borderSideFromChoiceData(m['side'] as Map),
    );
  } else if (data['.border'] != null) {
    final m = data['.border'] as Map;
    return borderFromChoiceData(m['border'] as Map);
  } else if (data['.borderDirectional'] != null) {
    final m = data['.borderDirectional'] as Map;
    return borderDirectionalFromChoiceData(m['borderDirectional'] as Map);
  } else if (data['.linear'] != null) {
    final m = data['.linear'] as Map;
    return linearBorderFromChoiceData(m['linear'] as Map);
  } else if (data['.outlineInput'] != null) {
    final m = data['.outlineInput'] as Map;
    return OutlineInputBorder(
      borderSide: borderSideFromChoiceData(m['borderSide'] as Map),
      borderRadius: borderRadiusFromChoiceData(m['borderRadius'] as Map),
      gapPadding: (m['gapPadding'] as num).toDouble(),
    );
  } else if (data['.underlineInput'] != null) {
    final m = data['.underlineInput'] as Map;
    return UnderlineInputBorder(
      borderSide: borderSideFromChoiceData(m['borderSide'] as Map),
      borderRadius: borderRadiusFromChoiceData(m['borderRadius'] as Map),
    );
  }

  // Sensible default if nothing matched
  return const RoundedRectangleBorder();
}
