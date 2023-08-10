import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:list_detail_base/base/controllers/list_detail_controller.dart';

/// Builder for list portion of [ListDetailLayout]
typedef ListBuilder<T> = Widget Function(BuildContext context, List<T> items, bool isSplitScreen);

/// Builder for dealing with errors in fetching list datat
typedef ListErrorBuilder = Widget Function(BuildContext context, Object error);

/// Builder for detail portion of [ListDetailLayout]
typedef DetailBuilder<T> = Widget Function(BuildContext context, T? item, bool isSplitScreen);

/// Display for app. Adaptive to size (tablet or phone), orientation
/// (in large size), and platform (iOS or otherwise).
/// In large mode, displays list + detail of selected Character.
/// In small mode, displays list.
class ListDetailLayout<T> extends StatelessWidget {
  /// Creates a widget that displays for app. Adaptive to size
  ///  (tablet or phone), orientation (in large size), and
  /// platform (iOS or otherwise). In large mode, displays
  /// list + detail of selected Character. In small mode, displays list.
  const ListDetailLayout({
    super.key,
    required this.controller,
    required this.listBuilder,
    required this.detailBuilder,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  final ListBuilder<T> listBuilder;

  final DetailBuilder<T> detailBuilder;

  final ListErrorBuilder? listErrorBuilder;
  final Builder? loadingBuilder;

  /// Controller for fetching list of characters and selecting
  /// characters
  final ListDetailController<T> controller;

  /// Determines whether device is larger than a typical phone
  bool _isLarge(BuildContext context, BoxConstraints constraints) {
    bool isLarge;
    if (constraints.hasBoundedHeight && constraints.hasBoundedWidth) {
      double shortest = constraints.maxHeight > constraints.maxWidth
          ? constraints.maxWidth
          : constraints.maxHeight;
      isLarge = shortest > kSizeBreakPoint;
    } else {
      isLarge = MediaQuery.of(context).size.shortestSide > kSizeBreakPoint;
    }
    return isLarge;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizeAdaptiveView<T>(
            isLarge: _isLarge(context, constraints),
            orientation: orientation,
            fetchList: controller.fetchList,
            onSelect: (character) => controller.select = character,
            selectedItem: controller.selectedItem,
            detailBuilder: detailBuilder,
            listBuilder: listBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
          );
        },
      );
    });
  }
}

/// Displays either [ListDetail] or [CharacterList] depending
/// on [isLarge].
/// [isLarge] : Whether device is larger than a phone (tablet)
/// [orientation] : Orientation of device, used by [ListDetail]
/// [selectedCharacter] : ValueListenable of character used by
/// both [ListDetail] and [CharacterList]
/// [getCharacterList] : Function used to fetch list of characters
/// [onSelect] : Function used to select character
class SizeAdaptiveView<T> extends StatelessWidget {
  /// Creates a widget that displays either [ListDetail] or
  /// [CharacterList] depending on [isLarge].
  /// [isLarge] : Whether device is larger than a phone (tablet)
  /// [orientation] : Orientation of device, used by [ListDetail]
  /// [selectedCharacter] : ValueListenable of character used by
  /// both [ListDetail] and [CharacterList]
  /// [getCharacterList] : Function used to fetch list of characters
  /// [onSelect] : Function used to select character
  const SizeAdaptiveView({
    super.key,
    required this.isLarge,
    required this.orientation,
    required this.selectedItem,
    required this.fetchList,
    required this.onSelect,
    required this.listBuilder,
    required this.detailBuilder,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  ///Whether device is larger than a phone (tablet)
  final bool isLarge;

  /// Orientation of device, used by [ListDetail]
  final Orientation orientation;

  /// ValueListenable of character used by
  /// both [ListDetail] and [CharacterList]
  final ValueListenable<T?> selectedItem;

  /// Function used to fetch list of characters
  final Future<List<T>> Function() fetchList;

  /// Function used to select character
  final ValueChanged<T?> onSelect;

  /// Builder for the list part of list-detail.
  final ListBuilder<T> listBuilder;

  /// Builder for the detail part of list-detail.
  final DetailBuilder<T> detailBuilder;

  /// Optional builder for errors in fetching list
  final ListErrorBuilder? listErrorBuilder;

  /// Optional builder for progress indicator while fetching list
  final Builder? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return isLarge
        ? ListDetail(
            orientation: orientation,
            selectedItem: selectedItem,
            fetchList: fetchList,
            onSelect: onSelect,
            listBuilder: listBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
            detailBuilder: detailBuilder,
          )
        : ItemList(
            listBuilder: listBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
            fetchList: fetchList,
            isSplitScreen: false,
          );
  }
}

/// Displays both list and deatil views. Facilitates search
/// and selection and detail display in one view.
/// [orientation] determines the location of list and detail.
/// [selectedCharacter] ValueListenable detail listens to.
/// [getCharacterList] Function returns Future<List<Character>>
/// [onSelect] callback for list to select characters.
class ListDetail<T> extends StatelessWidget {
  /// Creates a widget that displays both list and deatil views.
  /// Facilitates search and selection and detail display in one view.
  /// [orientation] determines the location of list and detail.
  /// [selectedCharacter] ValueListenable detail listens to.
  /// [getCharacterList] Function returns Future<List<Character>>
  /// [onSelect] callback for list to select characters.
  const ListDetail({
    super.key,
    required this.orientation,
    required this.selectedItem,
    required this.fetchList,
    required this.onSelect,
    required this.listBuilder,
    required this.detailBuilder,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  /// Device orientation. Determines direction and location
  /// of list and detail
  final Orientation orientation;

  /// ValueListenable to which detail listens to displays
  /// character details.
  final ValueListenable<T?> selectedItem;

  /// Function that fetches list of characters for use by list.
  final Future<List<T>> Function() fetchList;

  /// Callback for list items to select character
  final ValueChanged<T?> onSelect;

  final ListBuilder<T> listBuilder;

  final DetailBuilder<T> detailBuilder;

  final ListErrorBuilder? listErrorBuilder;
  final Builder? loadingBuilder;

  final String _listHero = 'list_hero';
  final String _detailHero = 'detail_hero';

  @override
  Widget build(BuildContext context) {
    // Make basic list view
    Widget list = Hero(
      tag: _listHero,
      child: ItemList(
        listBuilder: listBuilder,
        listErrorBuilder: listErrorBuilder,
        loadingBuilder: loadingBuilder,
        fetchList: fetchList,
        isSplitScreen: true,
      ),
    );
    list = Flexible(
      flex: kListFlex,
      child: list,
    );
    Widget detail = Hero(
      tag: _detailHero,
      child: ItemDetail(
        selectedItem: selectedItem,
        detailBuilder: detailBuilder,
      ),
    );
    detail = Flexible(
      flex: kDetailFlex,
      child: detail,
    );
    // Assemble Flex params
    final Axis direction;
    final List<Widget> flexChildren;
    if (orientation == Orientation.portrait) {
      direction = Axis.vertical;
      flexChildren = [detail, const Divider(), list];
    } else {
      direction = Axis.horizontal;
      flexChildren = [list, const Divider(), detail];
    }
    return Flex(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: direction,
      children: flexChildren,
    );
  }
}

/// Displays a list of T - based widgets, the list in [ListDetail].
class ItemList<T> extends StatelessWidget {
  /// Creates a list of T, the list in [ListDetail].
  const ItemList({
    super.key,
    required this.listBuilder,
    required this.fetchList,
    required this.isSplitScreen,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  /// Used in [FutureBuilder] to get the list of T
  final Future<List<T>> Function() fetchList;

  /// Builder that wraps individual T in widgets
  final ListBuilder<T> listBuilder;

  /// If not null, builds error-wrapping widget if
  /// [FutureBuilder] results in an error.
  final ListErrorBuilder? listErrorBuilder;

  /// If not null, provides a loading widget while [FutureBuilder] is
  /// in [ConnectionState.waiting]
  final Builder? loadingBuilder;

  /// Flag determined by [ListDetail] and passed to this widget
  /// in order to passed to [listBuilder] as a parameter.
  final bool isSplitScreen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: fetchList(),
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
            if (listErrorBuilder != null) {
              return listErrorBuilder!(context, 'Unexpected Error');
            }
            return const Center(
              child: Text('Unexpected Error'),
            );
          case ConnectionState.waiting:
            if (loadingBuilder != null) {
              return loadingBuilder!.build(context);
            }
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            if (snap.hasData) {
              return listBuilder(context, snap.data!, isSplitScreen);
            }
            if (snap.hasError) {
              if (listErrorBuilder != null) {
                return listErrorBuilder!(context, snap.error!);
              }
              return Center(
                child: Text(snap.error!.toString()),
              );
            }
            return listBuilder(context, [], isSplitScreen);
        }
      },
    );
  }
}

/// A widget that uses [detailBuilder] to return a widget based
/// on [selectedItem] value. Used in [ListDetail] for split 
/// screen layouts.
class ItemDetail<T> extends StatelessWidget {
  /// Creates a widget that uses [detailBuilder] to return a 
  /// widget based on [selectedItem] value. Used in 
  /// [ListDetail] for split screen layouts.
  const ItemDetail({
    super.key,
    required this.detailBuilder,
    required this.selectedItem,
  });

  /// Builds a item detail widget based on value of [selectedItem]
  final DetailBuilder<T> detailBuilder;

  /// Listenable to which a [ValueListenableBuilder] is attached.
  final ValueListenable<T?> selectedItem;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: selectedItem,
      builder: (context, item, _) => detailBuilder(context, item, true),
    );
  }
}
