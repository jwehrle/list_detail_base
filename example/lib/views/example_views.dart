import 'package:flutter/material.dart';
import 'package:list_detail_base/list_detail_base.dart';

import '../data/example_data.dart';

class ColorList extends StatelessWidget {
  const ColorList({
    super.key,
    required this.list,
  });

  final List<ColorEtymology> list;

  @override
  Widget build(BuildContext context) {
    final controller = ListDetail.of<ColorEtymology>(context).controller;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => ColorListTile(
        colorModel: list[index],
        isSplitScreen: controller.isSplit,
        onSelect: (value) => controller.select = value,
      ),
    );
  }
}

class ColorListTile extends StatelessWidget {
  const ColorListTile({
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
                  body: const ColorDetail(),
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

class ColorDetail extends StatelessWidget {
  const ColorDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ListDetail.of<ColorEtymology>(context).controller;

    if (controller.isSplit) {
      return ValueListenableBuilder<ColorEtymology?>(
        valueListenable: controller.selectedItem,
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

    if (controller.selected == null) {
      return Container();
    }
    return ColorModelCard(colorModel: controller.selected!);
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
