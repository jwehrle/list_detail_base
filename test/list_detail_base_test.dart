// ignore_for_file: avoid_relative_lib_imports

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:list_detail_base/list_detail_base.dart';
import '../example/lib/data/example_data.dart';
import '../example/lib/views/example_views.dart';

void main() {
  test('Controller', () async {
    ListDetailController controller = ListDetailController(
      fetch: () => Future.value(colorMapList),
      transform: ColorEtymology.fromMap,
    );

    final result1 = await controller.fetch();

    expect(result1, everyElement(const TypeMatcher<Map<String, dynamic>>()));

    final result2 = result1.map(controller.transform).toList();

    expect(result2, everyElement(const TypeMatcher<ColorEtymology>()));

    controller.select = result2.first;
    Future.delayed(const Duration(seconds: 1),
        () => expect(controller.selectedItem.value, result2.first));

    controller.dispose();
  });

  testWidgets('Widgets', (widgetTester) async {
    await widgetTester.binding.setSurfaceSize(const Size(1080.0, 810.0));
    addTearDown(widgetTester.view.resetPhysicalSize);

    const none = ValueKey('none_selected');

    ListDetailController<ColorEtymology> controller = ListDetailController(
      fetch: () => Future.value(colorMapList),
      transform: ColorEtymology.fromMap,
    );
    await widgetTester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListDetailLayout(
            controller: controller,
            listBuilder: (context, items, isSplitScreen) => ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => Item(
              colorModel: items[index],
              isSplitScreen: isSplitScreen,
              onSelect: (value) => controller.select = value,
            ),
          ),
          detailBuilder: (context, item, isSplitScreen) => item == null
              ? Container(key: none)
              : ColorModelDetail(
                  key: ValueKey(item.name),
                  colorModel: item,
                  isSplitScreen: isSplitScreen,
                  colorModelListenable: controller.selectedItem,
                ),
          ),
        ),
      ),
    );

    await widgetTester.pumpAndSettle();

    final noneFinder1 = find.byKey(none);
    expect(noneFinder1, findsOneWidget);

    final redFinder = find.text('Red');
    expect(redFinder, findsOneWidget);
    final pinkFinder = find.text('Pink');
    expect(pinkFinder, findsOneWidget);
    expect(find.text('Purple'), findsOneWidget);
    expect(find.text('Indigo'), findsOneWidget);
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Cyan'), findsOneWidget);
    expect(find.text('Green'), findsOneWidget);
    expect(find.text('Yellow'), findsOneWidget);
    expect(find.text('Amber'), findsOneWidget);
    expect(find.text('Orange'), findsOneWidget);

    await widgetTester.tap(redFinder);

    await widgetTester.pumpAndSettle();

    final noneFinder2 = find.byKey(none);
    expect(noneFinder2, findsNothing);

    final detailFinder1 = find.byKey(const ValueKey('Red'));
    expect(detailFinder1, findsOneWidget);

    await widgetTester.tap(pinkFinder);

    await widgetTester.pumpAndSettle();

    final noneFinder3 = find.byKey(none);
    expect(noneFinder3, findsNothing);

    final detailFinder2 = find.byKey(const ValueKey('Pink'));
    expect(detailFinder2, findsOneWidget);

    controller.dispose();
  });
}