import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/example_data.dart';

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