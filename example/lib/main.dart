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

/// Example of ListDetailBase
class _MyHomePageState extends State<MyHomePage> {
  /// Make a controller with the same type as your list
  late final ListDetailController<ColorEtymology> controller;

  // final GlobalKey<ListDetailLayoutState> layoutKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = ListDetailController();
  }

  @override
  Widget build(BuildContext context) {
    final list = List<ColorEtymology>.from(
      colorMapList.map(ColorEtymology.fromMap),
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListDetail<ColorEtymology>(
        controller: controller,
        child: Builder(builder: (innerContext) {
          return ListDetailLayout(
            // key: layoutKey,
            controller: ListDetail.of<ColorEtymology>(innerContext).controller,
            listBuilder: (innerContext) => ColorList(list: list),
            detailBuilder: (innerContext) => const ColorDetail(),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}