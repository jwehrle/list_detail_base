import 'package:flutter/material.dart';

import 'package:list_detail_base/base/views/adaptive_layout.dart';

/// Displays list of character names adaptively based on
/// platform and [isSplitScreen], which is set by the device size
/// and indicates phone or tablet.
class ItemList<T> extends StatelessWidget {
  final Future<List<T>> Function() fetchList;
  final ListBuilder<T> listBuilder;
  final ListErrorBuilder? listErrorBuilder;
  final Builder? loadingBuilder;
  final ValueChanged<T?> onSelect;
  final bool isSplitScreen;

  /// Creates a searchable list of character names using [getCharacterList].
  /// Character name tiles are selectable, which calls [onSelect].
  /// if [isSplitScreen] is true list is wrapped in scaffold.
  /// Widget is adaptive to iOS, in which case it makes Cupertino widgets,
  /// otherwise Material widgets are used.
  const ItemList({
    super.key,
    required this.listBuilder,
    required this.fetchList,
    required this.onSelect,
    required this.isSplitScreen,
    this.listErrorBuilder,
    this.loadingBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
        future: fetchList(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              if (listErrorBuilder != null) {
                return listErrorBuilder!(context, 'Unexpected Error');
              }
              return const Center(
                child: Text('Unexpected Error'),
              );
            case ConnectionState.waiting:
              if (loadingBuilder != null) {
                return loadingBuilder!.build(context);
              }
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snap.hasData) {
                return listBuilder(context, snap.data!, isSplitScreen);
              }
              if (snap.hasError) {
                if (listErrorBuilder != null) {
                return listErrorBuilder!(context, snap.error!);
              }
              return Center(
                child: Text(snap.error!.toString()),
              );
              }
              return listBuilder(context, [], isSplitScreen);
          }
        });
  }
}

/// Shows a progress indicator, iOS adaptible, and wrapped in
/// scaffold if [useScaffold] is true.
// class CharacterListLoading extends StatelessWidget {
//   final bool useScaffold;

//   const CharacterListLoading({
//     super.key,
//     required this.useScaffold,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isIOS) {
//       const Widget cuperChild = Center(
//         child: CupertinoActivityIndicator(),
//       );
//       if (useScaffold) {
//         return const CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(
//             middle: Text('Characters'),
//           ),
//           child: cuperChild,
//         );
//       }
//       return cuperChild;
//     }
//     const Widget matChild = Center(
//       child: CircularProgressIndicator(),
//     );
//     if (useScaffold) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Characters'),
//         ),
//         body: matChild,
//       );
//     }
//     return matChild;
//   }
// }

// /// Creates a searchable list of character names using [getCharacterList].
// /// Character name tiles are selectable, which calls [onSelect].
// /// if [useScaffold] is true list is wrapped in scaffold.
// /// Widget is adaptive to iOS, in which case it makes Cupertino widgets,
// /// otherwise Material widgets are used.
// class CharacterListBody extends StatefulWidget {
//   final String appTitle;
//   final List<Character> characters;
//   final bool useScaffold;
//   final ValueChanged<Character?> onSelect;

//   /// Creates a searchable list of character names using [getCharacterList].
//   /// Character name tiles are selectable, which calls [onSelect].
//   /// if [useScaffold] is true list is wrapped in scaffold.
//   /// Widget is adaptive to iOS, in which case it makes Cupertino widgets,
//   /// otherwise Material widgets are used.
//   const CharacterListBody({
//     super.key,
//     required this.appTitle,
//     required this.characters,
//     required this.useScaffold,
//     required this.onSelect,
//   });

//   @override
//   State<CharacterListBody> createState() => _CharacterListBodyState();
// }

// class _CharacterListBodyState extends State<CharacterListBody> {
//   /// Current search string value only used in iOS version.
//   String _cuperSearch = '';

//   /// Controller for [CupertinoSearchTextField] which is only used
//   ///  in iOS version
//   late final TextEditingController _cuperCtl;

//   /// Callback that keeps [_cuperSearch] current
//   void _cuperListener() {
//     setState(() => _cuperSearch = _cuperCtl.value.text);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _cuperCtl = TextEditingController();
//     _cuperCtl.addListener(_cuperListener);
//   }

//   /// Returns list of platform adaptive tiles based on search
//   List<Widget> _searchResults(String text, bool isIOS, Brightness brightness) {
//     if (text.isEmpty) {
//       return [];
//     }
//     return widget.characters
//         .where((e) => e.description.toLowerCase().contains(text.toLowerCase()))
//         .map((e) => _transformCharacter(e, text, isIOS, brightness))
//         .toList();
//   }

//   /// Transforms [character] into a platform adaptive tile with
//   /// search substring in bold.
//   Widget _transformCharacter(
//     Character character,
//     String text,
//     bool isIOS,
//     Brightness brightness,
//   ) {
//     return isIOS
//         ? CupertinoListTile(
//             title: Text(character.name),
//             subtitle: _subtitle(character, text, brightness),
//             onTap: () => _tileTap(character),
//           )
//         : ListTile(
//             title: Text(character.name),
//             subtitle: _subtitle(character, text, brightness),
//             onTap: () => _tileTap(character),
//           );
//   }

//   /// Returns a RichText based on [character.description] with [text] in bold.
//   RichText _subtitle(Character character, String text, Brightness brightness) {
//     int start = character.description.toLowerCase().indexOf(text.toLowerCase());
//     int end = start + text.length;
//     TextStyle style = TextStyle(
//       color: brightness == Brightness.dark ? Colors.white70 : Colors.black87,
//     );
//     return RichText(
//       text: TextSpan(
//         children: [
//           if (start != 0)
//             TextSpan(
//               text: character.description.substring(0, start),
//               style: style,
//             ),
//           TextSpan(
//               text: character.description.substring(start, end),
//               style: style.copyWith(fontWeight: FontWeight.bold)),
//           if (end != character.description.length)
//             TextSpan(
//               text: character.description.substring(end),
//               style: style,
//             ),
//         ],
//       ),
//     );
//   }

//   void _tileTap(Character character) {
//     widget.onSelect(character);
//     if (widget.useScaffold) {
//       _openDetails(character);
//     }
//   }

//   void _openDetails(Character character) {
//     final route = Platform.isIOS
//         ? CupertinoPageRoute(
//             builder: (context) => CharacterDetailPhone(
//               character: character,
//             ),
//           )
//         : MaterialPageRoute(
//             builder: (context) => CharacterDetailPhone(
//               character: character,
//             ),
//           );
//     Navigator.of(context).push(route);
//   }

//   /// Transforms [character] into a [CupertinoListTile]
//   Widget _cuperTransform(Character character) => CupertinoListTile(
//         title: Text(character.name),
//         onTap: () => _tileTap(character),
//       );

//   /// Transforms [character] into a [ListTile]
//   Widget _matTransform(Character character) => ListTile(
//         title: Text(character.name),
//         onTap: () => _tileTap(character),
//       );

//   @override
//   Widget build(BuildContext context) {
//     if (Platform.isIOS) {
//       final Widget cuperChild = SingleChildScrollView(
//         child: CupertinoListSection(
//           header: CupertinoSearchTextField(
//             controller: _cuperCtl,
//             onSuffixTap: _cuperCtl.clear,
//           ),
//           children: _cuperSearch.isEmpty
//               ? widget.characters.map(_cuperTransform).toList()
//               : _searchResults(
//                   _cuperSearch,
//                   true,
//                   CupertinoTheme.brightnessOf(context),
//                 ),
//         ),
//       );
//       if (widget.useScaffold) {
//         return CupertinoPageScaffold(
//           navigationBar: CupertinoNavigationBar(middle: Text(widget.appTitle)),
//           child: Padding(
//             padding: kCupertinoNavBarHeight,
//             child: cuperChild,
//           ),
//         );
//       }
//       return cuperChild;
//     }
//     Widget matChild = ListView(
//       children: widget.characters.map(_matTransform).toList(),
//     );
//     matChild = Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Padding(
//           padding: kMaterialSearchPadding,
//           child: SearchAnchor.bar(
//             suggestionsBuilder: (context, ctl) => _searchResults(
//               ctl.value.text,
//               false,
//               Theme.of(context).brightness,
//             ),
//             isFullScreen: widget.useScaffold,
//           ),
//         ),
//         Expanded(child: matChild),
//       ],
//     );
//     if (widget.useScaffold) {
//       return Scaffold(
//         appBar: AppBar(title: Text(widget.appTitle)),
//         body: matChild,
//       );
//     }
//     return matChild;
//   }

//   @override
//   void dispose() {
//     _cuperCtl.removeListener(_cuperListener);
//     _cuperCtl.dispose();
//     super.dispose();
//   }
// }

// /// Shows [error] in platform adaptive widget wrapped in scaffold
// /// if [useScaffold] is true.
// class CharacterListError extends StatelessWidget {
//   final Object error;
//   final bool useScaffold;

//   /// Shows [error] in platform adaptive widget wrapped in scaffold
//   /// if [useScaffold] is true.
//   const CharacterListError({
//     super.key,
//     required this.error,
//     required this.useScaffold,
//   });

//   @override
//   Widget build(BuildContext context) {
//     const title = Text('Characters');
//     if (Platform.isIOS) {
//       Widget cuperChild = Center(
//         child: Text(
//           error.toString(),
//           style: TextStyle(
//               color: CupertinoTheme.of(context).brightness == Brightness.dark
//                   ? Colors.white70
//                   : Colors.black87),
//         ),
//       );
//       if (useScaffold) {
//         return CupertinoPageScaffold(
//           navigationBar: const CupertinoNavigationBar(
//             middle: title,
//           ),
//           child: cuperChild,
//         );
//       }
//       return cuperChild;
//     }
//     Widget matChild = Center(
//       child: Text(error.toString()),
//     );
//     if (useScaffold) {
//       return Scaffold(
//         appBar: AppBar(
//           title: title,
//         ),
//         body: matChild,
//       );
//     }
//     return matChild;
//   }
// }
