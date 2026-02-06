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
  late List<CatalogPropertyRenderObject> propertyRenderers;

  /// ThemeData used around the widget view.
  ThemeData? _data;

  CatalogEntryController({
    this.propertyData = const [],
  }) {
    propertyRenderers = [
      for (var p in propertyData) CatalogPropertyRenderObject(p)..addListener(notifyListeners),
    ];
  }

  Map<String, dynamic> evaluateVariables() {
    return Map.fromEntries([for (var p in propertyRenderers) MapEntry(p.data.name, p.evaluated())]);
  }
}

/// Defines the characteristics of a property: authorized values, range, how to display it...
abstract class CatalogPropertyData<T> {
  final String name;
  final Type type;
  final bool nullAllowed;

  final T? defaultValue;
  final T? defaultValueWhenNotNull;

  CatalogPropertyData(this.name, {required this.type, required this.nullAllowed, this.defaultValue, this.defaultValueWhenNotNull});
}

/// Makes the link between the CatalogPropertyData and its held value.
class CatalogPropertyRenderObject<V, T extends CatalogPropertyData<V>> extends ChangeNotifier {
  final T data;
  late List<CatalogPropertyRenderObject> children;

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

  CatalogPropertyRenderObject(this.data) {
    _isNull = data.nullAllowed && data.defaultValue == null;
    _value = data.defaultValue ?? data.defaultValueWhenNotNull;

    if (data is BooleanPropertyData && (!data.nullAllowed && _value == null)) {
      _value = false as V;
    } else if (data is ColorPropertyData && (!data.nullAllowed && _value == null)) {
      _value = (data as ColorPropertyData).choices?.first as V;
    } else if (data is EnumPropertyData && (!data.nullAllowed && _value == null)) {
      _value = (data as EnumPropertyData).choices.first as V;
    } else if (data is NumRangePropertyData && (!data.nullAllowed && _value == null)) {
      _value = (data as NumRangePropertyData).minimum as V;
    } else if (data is ObjectPropertyData) {
      children = [for (var p in (data as ObjectPropertyData).properties) CatalogPropertyRenderObject(p)..addListener(notifyListeners)];
    } else if (data is MultipleObjectTypeChoice) {
      if (!data.nullAllowed && _value == null) {
        _value = (data as MultipleObjectTypeChoice).choices.first.name as V;
      }
      children = [for (var p in (data as MultipleObjectTypeChoice).choices) CatalogPropertyRenderObject(p)..addListener(notifyListeners)];
    } else {
      children = [];
    }
  }

  dynamic evaluated() {
    if (_isNull) return null;

    if (data is ObjectPropertyData) {
      return {for (var p in children) p.data.name: p.evaluated()};
    } else if (data is MultipleObjectTypeChoice) {
      var selectedChild = children.firstWhere((c) => c.data.name == value);
      return {selectedChild.data.name: selectedChild.evaluated()};
    } else {
      return value;
    }
  }
}

class NumRangePropertyData extends CatalogPropertyData<num> {
  NumRangePropertyData(super.name, {Type? type, super.nullAllowed = false, required this.maximum, required this.minimum, super.defaultValue, super.defaultValueWhenNotNull, this.integersOnly = false}) : super(type: type ?? num);

  final num minimum, maximum;
  final bool integersOnly;
}

class BooleanPropertyData extends CatalogPropertyData<bool> {
  BooleanPropertyData(super.name, {super.defaultValue, super.defaultValueWhenNotNull, super.nullAllowed = false}) : super(type: bool);
}

class EnumPropertyData<T extends Object> extends CatalogPropertyData<T> {
  EnumPropertyData(super.name, {super.defaultValue, T? defaultValueWhenNotNull, super.nullAllowed = false, required this.choices, this.valueToString}) : super(type: T, defaultValueWhenNotNull: defaultValueWhenNotNull ?? choices.first);

  final List<T> choices;
  final String Function(T? value)? valueToString;
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
