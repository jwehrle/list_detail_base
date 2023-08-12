<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# ListDetailBase

## A template package for List-Detail or Master-Detail layouts

## Features

* Builds for large or small screens in one simple widget.
* Easily modifiable.
* Handles all state management with no dependencies and no fuss.
* Simple package. Look at the code. There's not much complexity.

## Getting started

Add package

```dart
flutter pub add list_detail_base
```

## Usage

Import

```dart
import 'package:list_detail_base/list_detail_base.dart';
```

Example (explore example code in the example app - it's short).

```dart
/// Example of ListDetailBase
class _MyHomePageState extends State<MyHomePage> {

  /// Make a controller with the same type as your list.
  /// [ColorEtymology] is an example data class
  late final ListDetailController<ColorEtymology> controller;

  @override
  void initState() {
    super.initState();
    /// 5 second delay for show. Transform turns JSON list into a 
    /// list of your model 
    controller = ListDetailController(
      fetch: () => Future.delayed(const Duration(seconds: 5), () => Future.value(colorMapList)),
      transform: ColorEtymology.fromMap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListDetailLayout(
        controller: controller,
        listBuilder: (context, items, isSplitScreen) => ListView.builder(
          itemCount: items.length,
          // [Item] is an example view - a ListTile
          itemBuilder: (context, index) => Item(
            colorModel: items[index],
            isSplitScreen: isSplitScreen,
            onSelect: (value) => controller.select = value,
          ),
        ),
        detailBuilder: (context, item, isSplitScreen) => item == null
            ? Container()
            // [ColorModelDetail] is an example view - a Card
            : ColorModelDetail(
                colorModel: item,
                isSplitScreen: isSplitScreen,
                colorModelListenable: controller.selectedItem,
              ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

## Additional information

This is a quick helper package I put together based on other work I was doing.
If you find it useful or want to add some feature please let me know.
