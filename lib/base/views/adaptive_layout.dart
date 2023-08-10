import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:list_detail_base/base/controllers/app_controller.dart';
import 'package:list_detail_base/base/views/character_detail.dart';
import 'package:list_detail_base/base/views/character_list.dart';

typedef ListBuilder<T> = Widget Function(BuildContext context, List<T> items, bool isSplitScreen);

typedef ListErrorBuilder = Widget Function(BuildContext context, Object error);

typedef DetailBuilder<T> = Widget Function(BuildContext context, T? item, bool isSplitScreen);

typedef ListDetailBuilder = Widget Function(BuildContext context, Widget body);

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
    required this.listDetailBuilder,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  final ListBuilder<T> listBuilder;

  final DetailBuilder<T> detailBuilder;

  final ListDetailBuilder listDetailBuilder;

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
            listDetailBuilder: listDetailBuilder,
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
    required this.listDetailBuilder,
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

  final ListBuilder<T> listBuilder;

  final DetailBuilder<T> detailBuilder;

  final ListDetailBuilder listDetailBuilder;

  final ListErrorBuilder? listErrorBuilder;
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
            listDetailBuilder: listDetailBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
            detailBuilder: detailBuilder,
          )
        : ItemList(
            listBuilder: listBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
            fetchList: fetchList,
            onSelect: onSelect,
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
    required this.listDetailBuilder,
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

  final ListDetailBuilder listDetailBuilder;

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
        onSelect: onSelect,
        isSplitScreen: true,
      ),
    );
    list = Flexible(
      flex: kListFlex,
      child: list,
    );
    Widget detail = Hero(
      tag: _detailHero,
      child: ItemDetailTablet<T>(
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
    final body = Flex(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: direction,
      children: flexChildren,
    );
    return listDetailBuilder(context, body);
  }
}
