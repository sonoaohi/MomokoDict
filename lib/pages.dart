import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom_textstyle.dart';
import 'custom_widgets.dart';
import 'jmdict_classes.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';

  bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobileDevice ? null : AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: isMobileDevice
                ? <Widget>[
                    const Spacer(),
                    const Text(
                      '和英辞書',
                      style: CustomTextStyle.appHomeScreenTitle,
                      softWrap: false,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SearchForm(searchType: SearchType.writings),
                    ),
                  ]
                : <Widget>[
                    const Text(
                      '和英辞書',
                      style: CustomTextStyle.appHomeScreenTitle,
                      softWrap: false,
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SearchForm(searchType: SearchType.writings),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}

enum SearchType { writings, senses }

class SearchResultPageArguments {
  final List<JMDictWord> words;
  final JMDictTagsDescription tagsDescription;
  final String query;
  final SearchType searchType;

  SearchResultPageArguments(
      this.words, this.tagsDescription, this.query, this.searchType);
}

class SearchResultPage extends StatelessWidget {
  static const String routeName = '/search';

  bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  const SearchResultPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageArguments =
        ModalRoute.of(context)!.settings.arguments as SearchResultPageArguments;
    return Scaffold(
      appBar: isMobileDevice ? null : AppBar(),
      body: Center(
          child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isMobileDevice
              ? <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: pageArguments.words.length,
                      itemBuilder: (context, index) {
                        return WordDetailsCard(
                          word: pageArguments.words[index],
                          tagsDescription: pageArguments.tagsDescription,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SearchForm(
                      initialText: pageArguments.query,
                      searchType: pageArguments.searchType,
                    ),
                  ),
                ]
              : <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SearchForm(
                      initialText: pageArguments.query,
                      searchType: pageArguments.searchType,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: pageArguments.words.length,
                      itemBuilder: (context, index) {
                        return WordDetailsCard(
                          word: pageArguments.words[index],
                          tagsDescription: pageArguments.tagsDescription,
                        );
                      },
                    ),
                  ),
                ],
        ),
      )),
    );
  }
}

//
// class WordDetailsPageArguments {
//   final JMDictWord word;
//   final JMDictTagsDescription tagsDescription;
//
//   WordDetailsPageArguments(this.word, this.tagsDescription);
// }
//
// class WordDetailsPage extends StatelessWidget {
//   static const String routeName = '/word';
//
//   const WordDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final pageArguments = ModalRoute.of(context)!.settings.arguments as WordDetailsPageArguments;
//     return Scaffold(
//       body: Center(
//         child:
//             WordDetailsCard(word: pageArguments.word,
//                 tagsDescription: pageArguments.tagsDescription),
//       ),
//     );
//   }
// }
