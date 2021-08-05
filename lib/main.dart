import 'package:flutter/material.dart';

import 'jmdict_classes.dart';
import 'load_asset.dart';
import 'pages.dart';

Future<JMDict> getParsedDict(Map<String, dynamic> unparsedDict) async {
  return JMDict.fromJson(unparsedDict);
}

class DictDataAccess extends InheritedWidget {
  const DictDataAccess(
      {Key? key, required this.dictData, required Widget child})
      : super(key: key, child: child);

  final JMDict dictData;

  static DictDataAccess of(BuildContext context) {
    final DictDataAccess result =
        context.dependOnInheritedWidgetOfExactType<DictDataAccess>()!;
    return result;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class ThisApp extends StatelessWidget {
  const ThisApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        SearchResultPage.routeName: (context) => const SearchResultPage(),
        // WordDetailsPage.routeName: (context) => const WordDetailsPage(),
      },
      theme: ThemeData(
        fontFamily: 'Noto Sans CJK JP',
        textTheme: Typography.dense2018,
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // JMDict jmDictData = await getParsedDict(await getDecodedDictJson('assets/jmdict-eng-3.1.0.json'));
  // JMDict jmneDictData = await getParsedDict(await getDecodedDictJson('assets/jmnedict-3.1.0.json'));
  //
  // JMDictTagsDescription tagsData = {};
  // tagsData.addAll(jmDictData.tagsDescription);
  // tagsData.addAll(jmneDictData.tagsDescription);
  // JMDict dictData = JMDict(words: jmDictData.words + jmneDictData.words,
  //     tagsDescription: tagsData);

  JMDict dictData = await getParsedDict(
      await getDecodedDictJson('assets/jmdict-eng-common-3.1.0.json'));

  runApp(
    DictDataAccess(
      dictData: dictData,
      child: const ThisApp(),
    ),
  );
}
