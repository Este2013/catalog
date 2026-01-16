import 'package:flutter/material.dart';

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

  List<CatalogPropertyData> defaultParameters;

  CatalogEntry(this.widgetName, {this.docLink, this.icon, this.iconBuilder, this.widgetBuilder, this.defaultParameters = const []}) : assert(!(icon != null && iconBuilder != null), 'Can only provide icon or iconBuilder (not both)');

  CatalogEntryController createDefaultController() {
    return CatalogEntryController(propertyData: defaultParameters);
  }
}

class CatalogEntryController extends ChangeNotifier {
  /// State to be used by the widget. For exemple, define the selected state of a checkbox in here.
  Map<String, dynamic> state = {};

  /// Data concerning the properties passed programatically to the widget.
  List<CatalogPropertyData> propertyData;
  late Map<String, dynamic> propertyValues;

  /// ThemeData used around the widget view.
  ThemeData? _data;
  // Map<String, dynamic> widgetProperties;
  // Map<String, dynamic> selectedWidgetProperties;

  CatalogEntryController({
    this.propertyData = const [],
  }) {
    propertyValues = {};
    for (var p in propertyData) {
      if (p is BooleanPropertyData) {
        propertyValues[p.name] = p.defaultValue;
      }
    }
  }

  void setValue(String name, dynamic value) {
    if (propertyValues[name] == value) return;
    propertyValues[name] = value;
    notifyListeners();
  }
}

/// Defines the characteristics of a property: authorized values, range, how to display it...
abstract class CatalogPropertyData {
  final String name;
  final Type type;
  final bool nullAllowed;

  CatalogPropertyData(this.name, {required this.type, required this.nullAllowed});
}

class NumRangePropertyData extends CatalogPropertyData {
  NumRangePropertyData(super.name, {Type? type, super.nullAllowed = false, this.maximum, this.minimum, this.defaultValue, this.defaultValueWhenNotNull, this.integersOnly = false}) : super(type: type ?? num);

  final num? minimum, maximum, defaultValue, defaultValueWhenNotNull;
  final bool integersOnly;
}

class BooleanPropertyData extends CatalogPropertyData {
  BooleanPropertyData(super.name, {this.defaultValue, super.nullAllowed = false}) : super(type: bool);

  final bool? defaultValue;
}

class EnumPropertyData<T extends Object> extends CatalogPropertyData {
  EnumPropertyData(super.name, {this.defaultValue, super.nullAllowed = false, required this.choices}) : super(type: T);

  final T? defaultValue;
  final List<T> choices;
}

class ColorPropertyData extends CatalogPropertyData {
  ColorPropertyData(super.name, {this.defaultValue, super.nullAllowed = false, this.choices}) : super(type: Color);

  final Color? defaultValue;
  final List<Color>? choices;
}
