import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:list_detail_base/base/views/adaptive_layout.dart';

/// Character detail view used for larger screens.
/// Always visible and changes its view depending on
/// the value of [selectedItem].
class ItemDetailTablet<T> extends StatelessWidget {
  /// Creates a character detail view used for larger screens.
  /// Always visible and changes its view depending on
  /// the value of [selectedItem].
  const ItemDetailTablet({
    super.key,
    required this.selectedItem,
    required this.detailBuilder,
  });

  final DetailBuilder<T> detailBuilder;

  /// ValueListenable used in ValueListenableBuilder.
  /// When value is null, an empty Container is shown.
  /// When value is not null, character image (if imageURL
  /// is not empty), name, and description are shown.
  /// Transitions are fade-animated.
  final ValueListenable<T?> selectedItem;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T?>(
      valueListenable: selectedItem,
      builder: (context, item, _) => detailBuilder(context, item, true),
    );
  }
}

/// Character detail view for smaller screens. Instead of
/// being always visible, this view is only shown
/// when an item in CharacterList is tapped.
/// Then [item] is passed to this view which displays
/// character image (if imageURL is not empty), name,
/// and description are shown.
class ItemDetailPhone<T> extends StatelessWidget {
  /// Creates character detail view for smaller screens. Instead of
  /// being always visible, this view is only shown
  /// when an item in CharacterList is tapped.
  /// Then [item] is passed to this view which displays
  /// character image (if imageURL is not empty), name,
  /// and description are shown.
  const ItemDetailPhone({
    super.key,
    required this.item,
    required this.detailBuilder,
  });

  /// The character for which details are shown.
  final T item;
  final DetailBuilder<T> detailBuilder;

  @override
  Widget build(BuildContext context) {
    return detailBuilder(context, item, false);
  }
}

/// Shows the newtork image of [character.imageURL] if it is
/// not empty otherwise shows a "no image" asset.
// class CharacterImage extends StatelessWidget {
//   /// Creates a widget that shows the newtork image of
//   ///  [character.imageURL] if it is not empty otherwise
//   ///  shows a "no image" asset.
//   const CharacterImage({
//     super.key,
//     required this.character,
//   });

//   final Character character;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: kCupertinoNavBarHeight,
//       child: LayoutBuilder(builder: (context, constraints) {
//         return character.imageURL.isEmpty
//             ? Image.asset(
//                 'assets/no_image.png',
//                 fit: BoxFit.contain,
//               )
//             : Image.network(
//                 '$kImageUrlPrefix${character.imageURL}',
//                 fit: BoxFit.contain,
//               );
//       }),
//     );
//   }
// }

// /// Shows the [character.name] and [character.description]
// /// in a platfor adaptive list tile.
// class CharacterDescription extends StatelessWidget {
//   /// Creates a widget that shows the [character.name] and
//   ///  [character.description] in a platfor adaptive list tile.
//   const CharacterDescription({
//     super.key,
//     required this.character,
//   });

//   final Character character;

//   @override
//   Widget build(BuildContext context) {
//     final title = Text(character.name);
//     return Platform.isIOS
//         ? CupertinoListTile(
//             title: title,
//             subtitle: Text(
//               character.description,
//               style: const TextStyle(fontSize: 16.0),
//               maxLines: 50,
//             ),
//           )
//         : ListTile(
//             title: title,
//             subtitle: Text(character.description),
//           );
//   }
// }
