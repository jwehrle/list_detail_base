import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A controller for list-detail pattern apps
/// that enables fetching the list and selecting items.
/// Built for use-case of fetching with an http client
/// and transforming a json array into a list of type
/// T items.
class ListDetailController<T> {

  /// Creates a controller for list-detail pattern apps
  /// that enables fetching the list and selecting items.
  /// Built for use-case of fetching with an http client
  /// and transforming a json array into a list of type
  /// T items.
  ListDetailController();

  final ValueNotifier<Orientation> _orientation = ValueNotifier(Orientation.landscape);

  ValueListenable<Orientation> get orientationListenable => _orientation;

  Orientation get orientation => _orientation.value;

  set orientation(Orientation value) => _orientation.value = value;

  final ValueNotifier<bool> _isSplit = ValueNotifier(true);

  ValueListenable<bool> get isSplitListenable => _isSplit;

  bool get isSplit => _isSplit.value;

  set isSplit(bool value) => _isSplit.value = value;

  /// Underlying selection ValueNotifier.
  final ValueNotifier<T?> _selectedItem = ValueNotifier(null);

  /// The currently selected item. If none is selected, value == null.
  /// Listen to this Listenable for selection changes.
  ValueListenable<T?> get selectedItem => _selectedItem;

  T? get selected => _selectedItem.value;

  /// Select the [item]. Set to null to unselect. Changes trigger
  /// notifications to all listeners.
  set select(T? item) => _selectedItem.value = item;

  /// Dispose of resources that need to be disposed.
  void dispose() {
    _orientation.dispose();
    _isSplit.dispose();
    _selectedItem.dispose();
  }
}
