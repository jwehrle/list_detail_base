import 'package:flutter/material.dart';
import 'package:list_detail_base/list_detail_base.dart';

class ListDetail<T> extends InheritedWidget {
  const ListDetail({
    super.key,
    required this.controller,
    required super.child,
  });

  final ListDetailController<T> controller;

  static ListDetail<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ListDetail<T>>();
  }

  static ListDetail<T> of<T>(BuildContext context) {
    final state = maybeOf<T>(context);
    assert(state != null, 'No ListDetail ancester in context');
    return state!;
  }

  @override
  bool updateShouldNotify(covariant ListDetail oldWidget) =>
      controller != oldWidget.controller;
}
