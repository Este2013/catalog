import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';

class Catalog {
  final String catalogName;
  final String catalogPackage;
  final Widget fallbackEntryIcon;

  final List<CatalogEntry> entries;

  Catalog({required this.catalogName, required this.catalogPackage, required this.entries, required this.fallbackEntryIcon});
}

class CatalogEntry {
  String widgetName;
  String? docLink;
  Widget? icon;
  Widget Function(BuildContext context, Color? iconColor)? iconBuilder;

  Widget Function(CatalogEntryController controller)? widgetBuilder;

  CatalogEntry(this.widgetName, {this.docLink, this.icon, this.iconBuilder, this.widgetBuilder}) : assert(!(icon != null && iconBuilder != null), 'Can only provide icon or iconBuilder (not both)');
}

class CatalogEntryController extends ChangeNotifier {
  /// State to be used by the widget. For exemple, define the selected state of a checkbox in here.
  Map<String, dynamic> state = {};

  List<CatalogPropertyData> propertyData;

  /// ThemeData used around the widget view.
  ThemeData? _data;
  // Map<String, dynamic> widgetProperties;
  // Map<String, dynamic> selectedWidgetProperties;

  CatalogEntryController({
    this.propertyData = const [],
  });
}

/// Common widgets from flutter/widgets.dart.
class WidgetCatalog extends Catalog {
  WidgetCatalog()
    : super(
        catalogName: 'Widgets',
        catalogPackage: 'flutter/widgets.dart',
        entries: [
          CatalogEntry(
            'Icon',
            docLink: 'https://api.flutter.dev/flutter/widgets/Icon-class.html',
            icon: Icon(Symbols.emoji_symbols),
            widgetBuilder: (controller) => Icon(Symbols.star),
          ),
          CatalogEntry(
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
          ),
        ],
        fallbackEntryIcon: Icon(Symbols.widgets),
      );
}

/// Defines the characteristics of a property: authorized values, range, how to display it...
class CatalogPropertyData {
  final String name;
  final PropertyValueData valueData;

  CatalogPropertyData(this.name, {required this.valueData});
}

abstract class PropertyValueData {
  final Type type;
  final bool nullAllowed;
  PropertyValueData({required this.type, required this.nullAllowed});
}

class NumRangePropertyValueData extends PropertyValueData {
  NumRangePropertyValueData({Type? type, super.nullAllowed = false}) : super(type: type ?? num);
}
