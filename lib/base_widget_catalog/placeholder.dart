import 'package:catalog/catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:material_symbols_icons/symbols.dart';

CatalogEntry placeholderCatalogEntry = CatalogEntry(
  'Placeholder',
  docLink: 'https://api.flutter.dev/flutter/widgets/Placeholder-class.html',
  // icon: Icon(Symbols.rectangle),
  iconBuilder: (BuildContext context, Color? iconColor) => SvgPicture.asset(
    'assets/icons/placeholder.svg',
    height: 24,
    width: 24,
    colorFilter: ColorFilter.mode(iconColor ?? Theme.of(context).listTileTheme.iconColor ?? Theme.of(context).iconTheme.color!, .srcIn),
  ),
  widgetBuilder: (controller, variables) => Placeholder(
    color: variables['color'] ?? const Color(0xFF455A64),
    fallbackHeight: (variables['fallbackHeight'] ?? 400.0).toDouble(),
    fallbackWidth: (variables['fallbackWidth'] ?? 400.0).toDouble(),
    strokeWidth: (variables['strokeWidth'] ?? 2.0).toDouble(),
    child: (variables['Provide a child'] ?? false) ? Icon(Icons.emoji_symbols, size: 100) : null,
  ),
  defaultParameters: [
    ColorPropertyData('color', nullAllowed: true, defaultValue: const Color(0xFF455A64)),

    NumRangePropertyData('fallbackHeight', type: double, defaultValue: null, minimum: 1, maximum: 1000, nullAllowed: true, integersOnly: true, defaultValueWhenNotNull: 400),
    NumRangePropertyData('fallbackWidth', type: double, defaultValue: null, minimum: 1, maximum: 1000, nullAllowed: true, integersOnly: true, defaultValueWhenNotNull: 400),
    NumRangePropertyData('strokeWidth', type: double, defaultValue: null, minimum: 1, maximum: 10, nullAllowed: true, integersOnly: true, defaultValueWhenNotNull: 2),

    BooleanPropertyData('Provide a child', nullAllowed: false, defaultValue: false),
  ],
);
