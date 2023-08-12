// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:example/views/example_views.dart';
import 'package:flutter/material.dart';
import 'package:list_detail_base/list_detail_base.dart';

import 'data/example_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Color Etymology'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ListDetailController<ColorEtymology> controller;

  @override
  void initState() {
    super.initState();
    controller = ListDetailController(
      fetch: () => Future.delayed(const Duration(seconds: 5), () => Future.value(colorMapList)),
      transform: (map) => ColorEtymology.fromMap(map),
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
          itemBuilder: (context, index) => Item(
            colorModel: items[index],
            isSplitScreen: isSplitScreen,
            onSelect: (value) => controller.select = value,
          ),
        ),
        detailBuilder: (context, item, isSplitScreen) => item == null
            ? Container()
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