import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'jmdict_classes.dart';
import 'main.dart';
import 'pages.dart';
import 'search_utils.dart';
import 'custom_textstyle.dart';

class SearchForm extends StatefulWidget {
  String? initialText;
  SearchType searchType;

  SearchForm({Key? key, this.initialText, this.searchType  = SearchType.writings}) : super(key: key);

  @override
  SearchFormState createState() => SearchFormState();
}

class SearchFormState extends State<SearchForm> {
  // late final TextEditingController searchTextController;

  // @override
  // void dispose() {
  //   // searchTextController.dispose();
  //   super.dispose();
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   // searchTextController = TextEditingController(text: widget.initialText);
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: 4),
        Container(
          child: DropdownButton<SearchType>(
            value: widget.searchType,
            onChanged: (SearchType? newSelectedValue) {
              setState(() {
                widget.searchType = newSelectedValue!;
              });
            },
            underline: const Offstage(),
            items: const [
              DropdownMenuItem(child: Text('Writings'), value: SearchType.writings),
              DropdownMenuItem(child: Text('Senses'), value: SearchType.senses),
            ],
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).disabledColor),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 8, right: 0),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextFormField(
              autofocus: true,
              initialValue: widget.initialText,
              onFieldSubmitted: (submittedText) {
                if (submittedText.isEmpty) {
                  return;
                }
                JMDict dictData = DictDataAccess.of(context).dictData;
                List<JMDictWord> words = (widget.searchType == SearchType.writings) ?
                    searchWritings(keyword: submittedText, dictData: dictData) :
                    searchSenses(keyword: submittedText, dictData: dictData);
                Navigator.pushNamed(
                  context,
                  SearchResultPage.routeName,
                  arguments: SearchResultPageArguments(
                      words, dictData.tagsDescription, submittedText, widget.searchType),
                );
              },
              // controller: searchTextController,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: const OutlineInputBorder(),
                hintText: widget.searchType == SearchType.writings ?
                'e.g. 日本語' :
                'e.g. Japanese',
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(4.0),
        //   child: IconButton(
        //     iconSize: 36,
        //     icon: const Icon(Icons.search),
        //     onPressed: () {
        //       JMDict dictData = DictDataAccess.of(context).dictData;
        //       List<JMDictWord> words = searchWritings(
        //           keyword: searchTextController.text, dictData: dictData);
        //       Navigator.pushNamed(context, SearchResultPage.routeName,
        //           arguments: SearchResultPageArguments(
        //               words, dictData.tagsDescription));
        //     },
        //   ),
        // ),
      ],
    );
  }
}

int compareWriting(JMDictWordWriting a, JMDictWordWriting b) {
  // No difference
  if (a.isCommon && a.hasKanji) {
    if (b.isCommon && b.hasKanji) {
      return 0;
    }
  }
  if (a.isCommon && !a.hasKanji) {
    if (b.isCommon && !b.hasKanji) {
      return 0;
    }
  }
  if (!a.isCommon) {
    if (!b.isCommon) {
      return 0;
    }
  }

  // a should come earlier in the list
  if (a.isCommon && a.hasKanji) {
    if (!b.isCommon || !b.hasKanji) {
      return -1;
    }
  }
  if (a.isCommon && !a.hasKanji) {
    if (!b.isCommon) {
      return -1;
    }
  }

  // b should come earlier in the list
  if (b.isCommon && b.hasKanji) {
    if (!a.isCommon || !a.hasKanji) {
      return 1;
    }
  }
  if (b.isCommon && !b.hasKanji) {
    if (!a.isCommon) {
      return 1;
    }
  }

  throw Error();
}

class WordDetailsCard extends StatelessWidget {
  final JMDictWord word;
  final JMDictTagsDescription tagsDescription;

  const WordDetailsCard(
      {Key? key, required this.word, required this.tagsDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<JMDictWordWriting> _writings = word.writings;
    List<JMDictWordSense> _senses = word.senses;

    _writings.sort(compareWriting);

    SelectableText _outstandingWritingWidget = SelectableText(
      _writings.elementAt(0).text,
      style: CustomTextStyle.entryOutstandingWriting,
    );

    List<Widget> _alternativeWritingWidgets;
    if (_writings.length > 1) {
      _alternativeWritingWidgets = _writings
          .sublist(1)
          .expand(
            (writing) => {
              const Text(
                '|',
                style: CustomTextStyle.entryDivider,
              ),
              SelectableText(
                writing.text,
                style: writing.isCommon
                    ? CustomTextStyle.entryCommonWriting
                    : CustomTextStyle.entryUncommonWriting,
              ),
            },
          )
          .toList()
          .sublist(1);
    } else {
      _alternativeWritingWidgets = [];
    }

    String capitalize(String string) {
      return string.characters.first.toUpperCase() + string.substring(1);
    }

    String getSenseDefinitionString(JMDictWordSense wordSense) {
      return capitalize(wordSense.definitions.join('; ')) + '. ';
    }

    String getSenseOtherString(JMDictWordSense wordSense) {
      String _senseString2 = '';

      if (wordSense.info.isNotEmpty) {
        _senseString2 += wordSense.info.map(capitalize).join('. ');
        _senseString2 += '. ';
      }
      if (wordSense.partsOfSpeech.isNotEmpty) {
        _senseString2 += wordSense.partsOfSpeech
            .map((partOfSpeech) => tagsDescription[partOfSpeech]!)
            .map(capitalize)
            .join('. ');
        _senseString2 += '. ';
      }
      if (wordSense.misc.isNotEmpty) {
        _senseString2 += wordSense.misc
            .map((misc) => tagsDescription[misc]!)
            .map(capitalize)
            .join('. ');
        _senseString2 += '. ';
      }

      return _senseString2;
    }

    List<TableRow> _senseTableRowWidgets = [];
    for (int _index = 0; _index < _senses.length; _index += 1) {
      _senseTableRowWidgets.add(
        TableRow(
          children: [
            Text(
              '${_index + 1}. ',
              style: CustomTextStyle.entryBodyOthers,
              textAlign: TextAlign.start,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  getSenseDefinitionString(_senses[_index]),
                  style: CustomTextStyle.entryBodyDefinition,
                ),
                SelectableText(
                  getSenseOtherString(_senses[_index]),
                  style: CustomTextStyle.entryBodyOthers,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  textBaseline: TextBaseline.ideographic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    _outstandingWritingWidget,
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _alternativeWritingWidgets,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(30.0),
                    1: FlexColumnWidth(),
                  },
                  children: _senseTableRowWidgets,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

