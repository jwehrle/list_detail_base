import 'package:flutter/material.dart';

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