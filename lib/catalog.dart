import 'package:flutter/material.dart';
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

  Widget Function(CatalogEntryController controller)? widgetBuilder;

  CatalogEntry(this.widgetName, {this.docLink, this.icon, this.widgetBuilder});
}

class CatalogEntryController extends ChangeNotifier {
  /// State to be used by the widget. For exemple, define the selected state of a checkbox in here.
  Map<String, dynamic> state = {};

  /// ThemeData used around the widget view.
  ThemeData? _data;
  // Map<String, dynamic> widgetProperties;
  // Map<String, dynamic> selectedWidgetProperties;
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
            widgetBuilder: (controller) => Icon(Symbols.abc),
          ),
        ],
        fallbackEntryIcon: Icon(Symbols.widgets),
      );
}
