import 'package:flutter/foundation.dart';

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
  ListDetailController({
    required this.fetch,
    required this.transform,
  });

  /// Async function that returns a list of Map<String, dynamic>.
  /// Expected use-case is with an http client that returns result 
  /// of jsonDecode on a response body.
  Future<List<Map<String, dynamic>>> Function() fetch;

  /// A funciton that transforms a [map] into type T. Expected
  /// use-case is with a model with a factory fromMap method.
  final T Function(Map<String, dynamic> map) transform;

  /// Underlying selection ValueNotifier.
  final ValueNotifier<T?> _selectedItem = ValueNotifier(null);

  /// The currently selected item. If none is selected, value == null.
  /// Listen to this Listenable for selection changes.
  ValueListenable<T?> get selectedItem => _selectedItem;

  /// Select the [item]. Set to null to unselect. Changes trigger
  /// notifications to all listeners.
  set select(T? item) => _selectedItem.value = item;

  /// Asynchronously returns list of items.
  Future<List<T>> fetchList() async {
    final result = await fetch();
    return List<T>.from(result.map(transform));
  }

  /// Dispose of resources that need to be disposed.
  void dispose() {
    _selectedItem.dispose();
  }
}
