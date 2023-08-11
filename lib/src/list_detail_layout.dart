import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'list_detail_controller.dart';

/// Leargest size of shortest side of a phone
const double kSizeBreakPoint = 550.0;

/// Flex for list in large mode
const int kListFlex = 2;

/// Flex for detail in large mode
const int kDetailFlex = 3;

/// Builder for list portion of [ListDetailLayout]
typedef ListBuilder<T> = Widget Function(
    BuildContext context, List<T> items, bool isSplitScreen);

/// Builder for dealing with errors in fetching list datat
typedef ListErrorBuilder = Widget Function(BuildContext context, Object error);

/// Builder for detail portion of [ListDetailLayout]
typedef DetailBuilder<T> = Widget Function(
  BuildContext context,
  T? item,
  bool isSplitScreen,
);

/// Order of list and detail in layout
enum LayoutOrder { listDetail, detailList }

/// Widget that coordinates layout and selection of the
/// List-Detail or Master-Detail pattern.
class ListDetailLayout<T> extends StatelessWidget {
  /// Creates a widget that widget that coordinates layout
  ///  and selection of the List-Detail or Master-Detail pattern.
  const ListDetailLayout({
    super.key,
    required this.controller,
    required this.listBuilder,
    required this.detailBuilder,
    this.listErrorBuilder,
    this.loadingBuilder,
    this.orientationAdaptive = true,
    this.alwaysSplit = false,
    this.listFlex = kListFlex,
    this.detailFlex = kDetailFlex,
    this.splitSize = kSizeBreakPoint,
    this.portraitOrder = LayoutOrder.detailList,
    this.landscapeOrder = LayoutOrder.listDetail,
  });

  /// Builder for list portion of layout
  final ListBuilder<T> listBuilder;

  /// Builder for detail portion of combined layout
  final DetailBuilder<T> detailBuilder;

  /// Optional builder for errors in fetching list
  final ListErrorBuilder? listErrorBuilder;

  /// Optional builder to be shown while FutureBuilder is waiting
  final Builder? loadingBuilder;

  /// Whether the layout shoud change when orientation changes.
  /// Defaults to true.
  final bool orientationAdaptive;

  /// Whether the split view should be used regardless of
  /// screen size. Defaults to false, in which case [splitSize]
  /// is used to determine whether to use a split layout
  final bool alwaysSplit;

  /// The flex factor used for list. Defaults to [kListFlex] or 2.
  final int listFlex;

  /// The flex factor used for detail. Defaults to [kDetailFlex] or 3.
  final int detailFlex;

  /// The break point between small screens and large screens
  /// which determines wheher to use a split layout when
  /// [alwaysSplit] is false.
  /// Defaulst to [kSizeBreakPoint] or 550.0
  final double splitSize;

  /// The layout order in portait. Defaults to [LayoutOrder.detailList]
  final LayoutOrder portraitOrder;

  /// The layout order in landscape. Defaults to [LayoutOrder.listDetail]
  final LayoutOrder landscapeOrder;

  /// Controller for this widget.
  final ListDetailController<T> controller;

  /// Determines whether device is larger than a typical phone
  bool _isSplit(BuildContext context, BoxConstraints constraints) {
    bool isLarge;
    if (constraints.hasBoundedHeight && constraints.hasBoundedWidth) {
      double shortest = constraints.maxHeight > constraints.maxWidth
          ? constraints.maxWidth
          : constraints.maxHeight;
      isLarge = shortest > splitSize;
    } else {
      isLarge = MediaQuery.of(context).size.shortestSide > splitSize;
    }
    return isLarge;
  }

  /// Returns a [_SizeAdaptiveView] based on [split] and [orientation]
  Widget _viewBuilder(bool split, Orientation orientation) {
    return _SizeAdaptiveView<T>(
      isSplit: split,
      orientation: orientation,
      fetchList: controller.fetchList,
      onSelect: (character) => controller.select = character,
      selectedItem: controller.selectedItem,
      detailBuilder: detailBuilder,
      listBuilder: listBuilder,
      listErrorBuilder: listErrorBuilder,
      loadingBuilder: loadingBuilder,
      listFlex: listFlex,
      detailFlex: detailFlex,
      portraitOrder: portraitOrder,
      landscapeOrder: landscapeOrder,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (orientationAdaptive) {
      return OrientationBuilder(
        builder: (context, orientation) {
          return alwaysSplit
              ? _viewBuilder(true, orientation)
              : LayoutBuilder(
                  builder: (context, constraints) => _viewBuilder(
                    _isSplit(context, constraints),
                    orientation,
                  ),
                );
        },
      );
    }
    return alwaysSplit
        ? _viewBuilder(true, Orientation.landscape)
        : LayoutBuilder(
            builder: (context, constraints) => _viewBuilder(
              _isSplit(context, constraints),
              Orientation.landscape,
            ),
          );
  }
}

/// Displays either [_ListDetail] or [_ItemList] depending
/// on [isSplit].
class _SizeAdaptiveView<T> extends StatelessWidget {
  /// Creates a widget that displays either [_ListDetail]
  ///  or [_ItemList] depending on [isSplit].
  const _SizeAdaptiveView({
    super.key,
    required this.isSplit,
    required this.orientation,
    required this.selectedItem,
    required this.fetchList,
    required this.onSelect,
    required this.listBuilder,
    required this.detailBuilder,
    required this.listFlex,
    required this.detailFlex,
    required this.portraitOrder,
    required this.landscapeOrder,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  /// The layout order in portrait when split
  final LayoutOrder portraitOrder;

  /// The layout order in landscape when split
  final LayoutOrder landscapeOrder;

  /// The flex factor of list when split
  final int listFlex;

  /// The flex factor of detail when split
  final int detailFlex;

  ///Whether device is larger than a phone (tablet)
  final bool isSplit;

  /// Orientation of device, used by [_ListDetail]
  final Orientation orientation;

  /// ValueListenable of character used by
  /// both [_ListDetail] and [CharacterList]
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
    return isSplit
        ? _ListDetail(
            orientation: orientation,
            selectedItem: selectedItem,
            fetchList: fetchList,
            onSelect: onSelect,
            listBuilder: listBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
            detailBuilder: detailBuilder,
            listFlex: listFlex,
            detailFlex: detailFlex,
            portraitOrder: portraitOrder,
            landscapeOrder: landscapeOrder,
          )
        : _ItemList(
            listBuilder: listBuilder,
            listErrorBuilder: listErrorBuilder,
            loadingBuilder: loadingBuilder,
            fetchList: fetchList,
            isSplit: false,
          );
  }
}

/// Displays both list and deatil views.
class _ListDetail<T> extends StatelessWidget {
  /// Creates a widget that displays both list and deatil views.
  const _ListDetail({
    super.key,
    required this.orientation,
    required this.selectedItem,
    required this.fetchList,
    required this.onSelect,
    required this.listBuilder,
    required this.detailBuilder,
    required this.listFlex,
    required this.detailFlex,
    required this.portraitOrder,
    required this.landscapeOrder,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  /// The layout order in portrait when split
  final LayoutOrder portraitOrder;

  /// The layout order in landscape when split
  final LayoutOrder landscapeOrder;

  /// The flex factor of list when split
  final int listFlex;

  /// The flex factor of detail when split
  final int detailFlex;

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

  /// Builder for the list part of list-detail.
  final ListBuilder<T> listBuilder;

  /// Builder for the detail part of list-detail.
  final DetailBuilder<T> detailBuilder;

  /// Optional builder for errors in fetching list
  final ListErrorBuilder? listErrorBuilder;

  /// Optional builder for progress indicator while fetching list
  final Builder? loadingBuilder;

  /// Hero tag for list
  final String _listHero = 'list_hero';

  /// Hero tag for detail
  final String _detailHero = 'detail_hero';

  /// Returns Flex children based on [orientation],
  /// [portraitOrder], and [landscapeOrder]
  List<Widget> _children(
    Orientation orientation,
    Widget detail,
    Widget list,
  ) {
    if (orientation == Orientation.portrait) {
      if (portraitOrder == LayoutOrder.detailList) {
        return [detail, list];
      } else {
        return [list, detail];
      }
    }
    if (landscapeOrder == LayoutOrder.detailList) {
      return [detail, list];
    } else {
      return [list, detail];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Make basic list view
    Widget list = Flexible(
      flex: listFlex,
      child: Hero(
        tag: _listHero,
        child: _ItemList(
          listBuilder: listBuilder,
          listErrorBuilder: listErrorBuilder,
          loadingBuilder: loadingBuilder,
          fetchList: fetchList,
          isSplit: true,
        ),
      ),
    );
    Widget detail = Flexible(
      flex: detailFlex,
      child: Hero(
        tag: _detailHero,
        child: _ItemDetail(
          selectedItem: selectedItem,
          detailBuilder: detailBuilder,
        ),
      ),
    );
    final isPortait = orientation == Orientation.portrait;
    return Flex(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      direction: isPortait ? Axis.vertical : Axis.horizontal,
      children: _children(orientation, detail, list),
    );
  }
}

/// Displays a list of T - based widgets, the list in [_ListDetail].
class _ItemList<T> extends StatelessWidget {
  /// Creates a list of T, the list in [_ListDetail].
  const _ItemList({
    super.key,
    required this.listBuilder,
    required this.fetchList,
    required this.isSplit,
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

  /// Flag determined by [_ListDetail] and passed to this widget
  /// in order to passed to [listBuilder] as a parameter.
  final bool isSplit;

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
              return listBuilder(context, snap.data!, isSplit);
            }
            if (snap.hasError) {
              if (listErrorBuilder != null) {
                return listErrorBuilder!(context, snap.error!);
              }
              return Center(
                child: Text(snap.error!.toString()),
              );
            }
            return listBuilder(context, [], isSplit);
        }
      },
    );
  }
}

/// A widget that uses [detailBuilder] to return a widget based
/// on [selectedItem] value. Used in [_ListDetail] for split
/// screen layouts.
class _ItemDetail<T> extends StatelessWidget {
  /// Creates a widget that uses [detailBuilder] to return a
  /// widget based on [selectedItem] value. Used in
  /// [_ListDetail] for split screen layouts.
  const _ItemDetail({
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
