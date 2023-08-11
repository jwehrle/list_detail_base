// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:list_detail_base/list_detail_base.dart';

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

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.colorModel,
    required this.isSplitScreen,
    required this.onSelect,
  });

  final ColorEtymology colorModel;
  final bool isSplitScreen;
  final ValueChanged<ColorEtymology?> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorModel.color,
      ),
      title: Text(colorModel.name),
      onTap: () {
        onSelect(colorModel);
        if (!isSplitScreen) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(colorModel.name),
                  ),
                  body: ColorModelDetail(
                    colorModel: colorModel,
                    isSplitScreen: isSplitScreen,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

const double kLuminancePivot = 0.28; //0.179;

Color textColor(Color background) {
  return background.computeLuminance() > kLuminancePivot
      ? Colors.black87
      : Colors.white;
}

class ColorModelDetail extends StatelessWidget {
  const ColorModelDetail({
    super.key,
    required this.colorModel,
    required this.isSplitScreen,
    this.colorModelListenable,
  }) : assert(
          !isSplitScreen || colorModelListenable != null,
        );

  final ColorEtymology? colorModel;
  final bool isSplitScreen;
  final ValueListenable<ColorEtymology?>? colorModelListenable;

  @override
  Widget build(BuildContext context) {
    if (isSplitScreen) {
      return ValueListenableBuilder<ColorEtymology?>(
        valueListenable: colorModelListenable!,
        builder: (context, value, _) {
          return AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: value == null
                ? Container()
                : ColorModelCard(
                    key: ValueKey(value.hashCode),
                    colorModel: value,
                  ),
          );
        },
      );
    }

    if (colorModel == null) {
      return Container();
    }
    return ColorModelCard(colorModel: colorModel!);
  }
}

class ColorModelCard extends StatelessWidget {
  const ColorModelCard({
    super.key,
    required this.colorModel,
  });

  final ColorEtymology colorModel;

  @override
  Widget build(BuildContext context) {
    Color foreground = textColor(colorModel.color);
    TextStyle style = TextStyle(color: foreground);
    if (foreground == Colors.white) {
      style = style.copyWith(fontWeight: FontWeight.bold);
    }
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Card(
        color: colorModel.color,
        child: Center(
          child: ListTile(
            title: Text(colorModel.name, style: style),
            subtitle: Text(colorModel.etymology, style: style),
          ),
        ),
      ),
    );
  }
}

/// Data

class ColorEtymology {
  final Color color;
  final String name;
  final String etymology;

  const ColorEtymology({
    required this.color,
    required this.name,
    required this.etymology,
  });

  factory ColorEtymology.fromMap(Map<String, dynamic> map) {
    return ColorEtymology(
      color: Color(map['color']),
      name: map['name'],
      etymology: map['etymology'],
    );
  }

  @override
  bool operator ==(covariant ColorEtymology other) {
    if (identical(this, other)) return true;

    return other.color == color &&
        other.name == name &&
        other.etymology == etymology;
  }

  @override
  int get hashCode => color.hashCode ^ name.hashCode ^ etymology.hashCode;
}

List<Map<String, dynamic>> colorMapList = [
  {
    'color': Colors.redAccent.value,
    'name': 'Red',
    'etymology':
        'Middle English red, rede, reed, going back to Old English rēad, going back to Germanic *rauđa- (whence also Old Frisian rād, rōd "red, yellow," Old Saxon rōd "red," Middle Dutch root, rood, Old High German rōt, Old Norse rauðr, Gothic rauþs), going back to Indo-European *h1rou̯dh-o-, whence also Old Irish rúad "reddish brown, dark red," Welsh rhudd "red, tawny," Latin rūfus (from a dialect or another Italic language, with -f- for expected -b-), Lithuanian raũdas "red-brown, reddish," Russian dialect rúdyj "blood-red," Bosnian-Croatian-Serbian rûd "reddish brown"; from a suffixed zero-grade form *h1rudh-ro-, Old Norse roðra "blood," Latin ruber "red," Tocharian B ratre, Greek erythrós, Sanskrit rudhiráḥ "red, bloody".',
  },
  {
    'color': Colors.pinkAccent.value,
    'name': 'Pink',
    'etymology': 'Middle English, from Middle Dutch pinke.',
  },
  {
    'color': Colors.purpleAccent.value,
    'name': 'Purple',
    'etymology':
        'Middle English purpel, alteration of purper, from Old English purpuran of purple, genitive of purpure purple color, from Latin purpura, from Greek porphyra.',
  },
  {
    'color': Colors.indigoAccent.value,
    'name': 'Indigo',
    'etymology':
        'Italian dialect, from Latin indicum, from Greek indikon, from neuter of indikos Indic, from Indos India.',
  },
  {
    'color': Colors.blueAccent.value,
    'name': 'Blue',
    'etymology':
        'Middle English, from Anglo-French blef, blew, of Germanic origin; akin to Old High German blāo blue; akin to Latin flavus yellow.',
  },
  {
    'color': Colors.cyanAccent.value,
    'name': 'Cyan',
    'etymology': 'Greek kyanos.',
  },
  {
    'color': Colors.greenAccent.value,
    'name': 'Green',
    'etymology':
        'Middle English grene, from Old English grēne; akin to Old English grōwan to grow.',
  },
  {
    'color': Colors.yellowAccent.value,
    'name': 'Yellow',
    'etymology':
        'Middle English yelwe, yelow, from Old English geolu; akin to Old High German gelo yellow, Latin helvus light bay, Greek chlōros greenish yellow, Sanskrit hari yellowish.',
  },
  {
    'color': Colors.amberAccent.value,
    'name': 'Amber',
    'etymology':
        'Middle English ambre, from Anglo-French, from Medieval Latin ambra, from Arabic ʽanbar ambergris.',
  },
  {
    'color': Colors.orangeAccent.value,
    'name': 'Orange',
    'etymology':
        'Middle English, from Anglo-French orrange, araunge, from Old Occitan auranja, from Arabic nāranj, from Persian nārang, from Sanskrit nāraṅga orange tree.',
  },
];