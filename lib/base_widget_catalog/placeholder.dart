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
  widgetBuilder: (controller) => Placeholder(),
  defaultParameters: [
    // TODO
  ],
);
