import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:list_detail_base/src/list_detail.dart';

import 'list_detail_controller.dart';

/// Leargest size of shortest side of a phone
const double kDefaultSizeBreakPoint = 550.0;

/// Flex for list in large mode
const int kListFlex = 2;

/// Flex for detail in large mode
const int kDetailFlex = 3;

/// Order of list and detail in layout
enum LayoutOrder { listDetail, detailList }

/// Widget that coordinates layout and selection of the
/// List-Detail or Master-Detail pattern.
class ListDetailLayout<T> extends StatefulWidget {
  /// Creates a widget that widget that coordinates layout
  ///  and selection of the List-Detail or Master-Detail pattern.
  const ListDetailLayout({
    super.key,
    required this.listBuilder,
    required this.detailBuilder,
    required this.controller,
    this.orientationAdaptive = true,
    this.alwaysSplit = false,
    this.listFlex = kListFlex,
    this.detailFlex = kDetailFlex,
    this.splitSize = kDefaultSizeBreakPoint,
    this.portraitOrder = LayoutOrder.detailList,
    this.landscapeOrder = LayoutOrder.listDetail,
  });

  /// Builder for list portion of layout
  final WidgetBuilder listBuilder;

  /// Builder for detail portion of combined layout
  final WidgetBuilder detailBuilder;
  // final Widget detail;

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
  /// Defaulst to [kDefaultSizeBreakPoint] or 550.0
  final double splitSize;

  /// The layout order in portait. Defaults to [LayoutOrder.detailList]
  final LayoutOrder portraitOrder;

  /// The layout order in landscape. Defaults to [LayoutOrder.listDetail]
  final LayoutOrder landscapeOrder;

  /// Controller for this widget.
  final ListDetailController<T> controller;

  @override
  State<ListDetailLayout<T>> createState() => ListDetailLayoutState<T>();
}

class ListDetailLayoutState<T> extends State<ListDetailLayout<T>> {
  
  @override
  Widget build(BuildContext context) {

    // Get split status even if it's not used later.
    // Rely on view physical size because it is accurate,
    // unlike LayoutBuilder which is unreliable.
    // Also, by calling View.of(context) this build
    // method is registered for rebuilds on changes.
    final view = View.of(context);
    final pixelRatio = view.devicePixelRatio;
    final logicalScreenSize = view.physicalSize / pixelRatio;
    final logicalWidth = logicalScreenSize.width;
    final logicalHeight = logicalScreenSize.height;
    final shortest =
        logicalHeight > logicalWidth ? logicalWidth : logicalHeight;
    bool split = shortest > widget.splitSize;
    // Update ValueNotifier
    widget.controller.isSplit = split;

    // Rely on MediaQuery for Orientation because it is 
    // accurate and Orientation builder is just a 
    // LayoutBuilder under the hood.
    // Also, by calling MediaQuery.of(context) this build
    // method is registered for rebuilds on changes.
    Orientation orientation = MediaQuery.of(context).orientation;


    // Wrap in OrientationBuilder for orientation
    //adaptive layouts
    if (widget.orientationAdaptive) {
          widget.controller.orientation = orientation;
          return SizeAdaptiveView<T>(
            isSplit: widget.alwaysSplit ? true : split,
            orientation: orientation,
            onSelect: (character) => widget.controller.select = character,
            selectedItem: widget.controller.selectedItem,
            detailBuilder: widget.detailBuilder,
            listBuilder: widget.listBuilder,
            listFlex: widget.listFlex,
            detailFlex: widget.detailFlex,
            portraitOrder: widget.portraitOrder,
            landscapeOrder: widget.landscapeOrder,
          );
    }

    // Otherwise, default to landscape layout.
    widget.controller.orientation = Orientation.landscape;
    return SizeAdaptiveView<T>(
      isSplit: widget.alwaysSplit ? true : split,
      orientation: Orientation.landscape,
      onSelect: (character) => widget.controller.select = character,
      selectedItem: widget.controller.selectedItem,
      detailBuilder: widget.detailBuilder,
      listBuilder: widget.listBuilder,
      listFlex: widget.listFlex,
      detailFlex: widget.detailFlex,
      portraitOrder: widget.portraitOrder,
      landscapeOrder: widget.landscapeOrder,
    );
  }
}

/// Displays either [BaseLayout] or [listBuilder] depending
/// on [isSplit].
class SizeAdaptiveView<T> extends StatelessWidget {
  /// Creates a widget that displays either [BaseLayout]
  ///  or just [isSplit] depending on split
  const SizeAdaptiveView({
    super.key,
    required this.isSplit,
    required this.orientation,
    required this.selectedItem,
    required this.onSelect,
    required this.listBuilder,
    required this.detailBuilder,
    required this.listFlex,
    required this.detailFlex,
    required this.portraitOrder,
    required this.landscapeOrder,
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

  /// Orientation of device, used by [BaseLayout]
  final Orientation orientation;

  /// ValueListenable of character used by[BaseLayout]
  final ValueListenable<T?> selectedItem;

  /// Function used to select character
  final ValueChanged<T?> onSelect;

  /// Builder for the list part of list-detail.
  // final ListBuilder<T> listBuilder;
  final WidgetBuilder listBuilder;

  /// Builder for the detail part of list-detail.
  final WidgetBuilder detailBuilder;
  // final Widget detail;

  @override
  Widget build(BuildContext context) {
    return isSplit
        ? BaseLayout(
            orientation: orientation,
            selectedItem: selectedItem,
            onSelect: onSelect,
            listBuilder: listBuilder,
            detailBuilder: detailBuilder,
            listFlex: listFlex,
            detailFlex: detailFlex,
            portraitOrder: portraitOrder,
            landscapeOrder: landscapeOrder,
          )
        : listBuilder(context);
  }
}

/// Displays both list and deatil views.
class BaseLayout<T> extends StatelessWidget {
  /// Creates a widget that displays both list and deatil views.
  const BaseLayout({
    super.key,
    required this.orientation,
    required this.selectedItem,
    required this.onSelect,
    required this.listBuilder,
    required this.detailBuilder,
    required this.listFlex,
    required this.detailFlex,
    required this.portraitOrder,
    required this.landscapeOrder,
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

  /// Callback for list items to select character
  final ValueChanged<T?> onSelect;

  /// Builder for the list part of list-detail.
  // final ListBuilder<T> listBuilder;
  final WidgetBuilder listBuilder;

  /// Builder for the detail part of list-detail.
  final WidgetBuilder detailBuilder;

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
    Widget listWidget = Flexible(
      flex: listFlex,
      child: Hero(
        tag: _listHero,
        child: listBuilder(context),
      ),
    );
    Widget detail = Flexible(
      flex: detailFlex,
      child: Hero(
        tag: _detailHero,
        child: BaseDetail(
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
      children: _children(orientation, detail, listWidget),
    );
  }
}

/// A widget that uses [detailBuilder] to return a widget based
/// on [selectedItem] value. Used in [BaseLayout] for split
/// screen layouts.
class BaseDetail<T> extends StatelessWidget {
  /// Creates a widget that uses [detailBuilder] to return a
  /// widget based on [selectedItem] value. Used in
  /// [BaseLayout] for split screen layouts.
  const BaseDetail({
    super.key,
    required this.detailBuilder,
    required this.selectedItem,
  });

  /// Builds a item detail widget based on value of [selectedItem]
  final WidgetBuilder detailBuilder;

  /// Listenable to which a [ValueListenableBuilder] is attached.
  final ValueListenable<T?> selectedItem;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: selectedItem,
      builder: (context, item, _) => detailBuilder(context),
    );
  }
}
