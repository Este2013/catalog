class Catalog {
  final String catalogName;
  final String catalogPackage;

  final List<WidgetCatalogEntry> entries;

  Catalog({required this.catalogName, required this.catalogPackage, required this.entries});
}

class WidgetCatalog extends Catalog {
  WidgetCatalog() : super(catalogName: 'Widgets', catalogPackage: 'flutter/widgets.dart', entries: [WidgetCatalogEntry('Icon', docLink: null)]);
}

class WidgetCatalogEntry {
  String widgetName;
  String? docLink;

  WidgetCatalogEntry(this.widgetName, {this.docLink});
}
