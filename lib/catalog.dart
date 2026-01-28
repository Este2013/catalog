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
  Widget Function(CatalogEntryController controller, Map<String, dynamic> evaluatedVariables)? widgetBuilder;

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
  late List<CatalogPropertyRenderer> propertyRenderers;

  /// ThemeData used around the widget view.
  ThemeData? _data;

  CatalogEntryController({
    this.propertyData = const [],
  }) {
    propertyRenderers = [for (var p in propertyData) CatalogPropertyRenderer(p)..addListener(() => notifyListeners())];
    // propertyValues = {};
    // for (var p in propertyData) {
    //   propertyValues[p.name] = p.defaultValue;
    // }
    // print(propertyValues);
  }

  Map<String, dynamic> evaluateVariables() {
    return Map.fromEntries([for (var p in propertyRenderers) MapEntry(p.data.name, p.evaluated())]);
  }

  // void setValue(String name, dynamic value, {List<String> path = const []}) {
  //   Map map = propertyValues;
  //   for (var v in path) {
  //     if (map[v] == null) {}
  //     map = propertyValues[v];
  //   }
  //   if (propertyValues[name] == value) return;
  //   propertyValues[name] = value;
  //   notifyListeners();
  // }
}

/// Defines the characteristics of a property: authorized values, range, how to display it...
abstract class CatalogPropertyData<T> {
  final String name;
  final Type type;
  final bool nullAllowed;

  final T? defaultValue;

  CatalogPropertyData(this.name, {required this.type, required this.nullAllowed, this.defaultValue});
}

/// Makes the link between the CatalogPropertyData and its held value.
class CatalogPropertyRenderer<V, T extends CatalogPropertyData<V>> extends ChangeNotifier {
  final T data;
  late List<CatalogPropertyRenderer> children;

  late bool _isNull;
  bool get isNull => _isNull;
  set isNull(bool state) {
    _isNull = state;
    notifyListeners();
  }

  V? _value;
  V? get value => _value;
  set value(V? newValue) {
    if (newValue == null && !data.nullAllowed) {
      return;
    }
    if (newValue == null) {
      _isNull = true;
    } else {
      _isNull = false;
      _value = newValue;
    }
    notifyListeners();
  }

  CatalogPropertyRenderer(this.data) {
    _isNull = data.defaultValue == null;
    _value = data.defaultValue;

    if (data is ObjectPropertyData) {
      children = [for (var p in (data as ObjectPropertyData).properties) CatalogPropertyRenderer(p)..addListener(notifyListeners)];
    } else if (data is MultipleObjectTypeChoice) {
      children = [for (var p in (data as MultipleObjectTypeChoice).choices) CatalogPropertyRenderer(p)..addListener(notifyListeners)];
    } else {
      children = [];
    }
  }

  dynamic evaluated() {
    if (_isNull) return null;
    if (data is ObjectPropertyData) {
      return {for (var p in children) p.data.name: p.evaluated()};
    } else if (data is MultipleObjectTypeChoice) {
      return children.firstWhere((c) => c.data.name == value).evaluated();
    } else {
      return value;
    }
  }
}

class NumRangePropertyData extends CatalogPropertyData<num> {
  NumRangePropertyData(super.name, {Type? type, super.nullAllowed = false, this.maximum, this.minimum, super.defaultValue, this.defaultValueWhenNotNull, this.integersOnly = false}) : super(type: type ?? num);

  final num? minimum, maximum, defaultValueWhenNotNull;
  final bool integersOnly;
}

class BooleanPropertyData extends CatalogPropertyData<bool> {
  BooleanPropertyData(super.name, {super.defaultValue, super.nullAllowed = false}) : super(type: bool);
}

class EnumPropertyData<T extends Object> extends CatalogPropertyData<T> {
  EnumPropertyData(super.name, {super.defaultValue, super.nullAllowed = false, required this.choices}) : super(type: T);

  final List<T> choices;
}

class ColorPropertyData extends CatalogPropertyData<Color> {
  ColorPropertyData(super.name, {super.defaultValue, super.nullAllowed = false, this.choices}) : super(type: Color);

  final List<Color>? choices;
}

class MultipleObjectTypeChoice extends CatalogPropertyData<String> {
  MultipleObjectTypeChoice(super.name, {required super.nullAllowed, required this.choices}) : super(type: String);

  final List<CatalogPropertyData> choices;
}

class ObjectPropertyData extends CatalogPropertyData<Null> {
  ObjectPropertyData(super.name, {required super.type, super.defaultValue, super.nullAllowed = false, required this.properties});

  final List<CatalogPropertyData> properties;
}
