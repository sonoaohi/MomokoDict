class JMDictWord {
  final int id;
  final List<JMDictWordWriting> writings;
  final List<JMDictWordSense> senses;

  JMDictWord({required this.id, required this.writings, required this.senses});

  factory JMDictWord.fromJson(Map<String, dynamic> unparsedWord) {
    final _kanjis = List<JMDictWordWriting>.from((unparsedWord['kanji'].map(
        (dynamic unparsedKanji) => JMDictWordWriting.fromJson(
            unparsedKanji as Map<String, dynamic>, true))) as Iterable);
    final _kanas = List<JMDictWordWriting>.from((unparsedWord['kana'].map(
        (dynamic unparsedKana) => JMDictWordWriting.fromJson(
            unparsedKana as Map<String, dynamic>, false))) as Iterable);
    return JMDictWord(
      id: int.parse(unparsedWord['id'] as String),
      writings: _kanjis + _kanas,
      senses: List<JMDictWordSense>.from((unparsedWord['sense'].map(
          (dynamic unparsedSense) => JMDictWordSense.fromJson(
              unparsedSense as Map<String, dynamic>))) as Iterable),
    );
  }
}

class JMDictWordSense {
  final List<JMDictTag> partsOfSpeech;
  final List<JMDictSenseDefinition> definitions;
  final List<String> info;
  final List<JMDictTag> misc;

  JMDictWordSense(
      {required this.partsOfSpeech,
      required this.definitions,
      required this.info,
      required this.misc});

  factory JMDictWordSense.fromJson(Map<String, dynamic> unparsedSense) {
    return JMDictWordSense(
        partsOfSpeech:
            List<JMDictTag>.from(unparsedSense['partOfSpeech'] as Iterable),
        definitions: List<JMDictSenseDefinition>.from((unparsedSense['gloss']
            .map((dynamic unparsedDefinition) =>
                unparsedDefinition['text'] as String)) as Iterable),
        info: List<String>.from(unparsedSense['info'] as Iterable),
        misc: List<JMDictTag>.from(unparsedSense['misc'] as Iterable));
  }
}

class JMDictWordWriting {
  final bool isCommon;
  final bool hasKanji;
  final String text;
  final List<JMDictTag> tags;

  JMDictWordWriting(
      {required this.isCommon,
      required this.hasKanji,
      required this.text,
      required this.tags});

  factory JMDictWordWriting.fromJson(
      Map<String, dynamic> unparsedWriting, bool hasKanji) {
    return JMDictWordWriting(
        isCommon: unparsedWriting['common'] as bool,
        hasKanji: hasKanji,
        text: unparsedWriting['text'] as String,
        tags: List<JMDictTag>.from(unparsedWriting['tags'] as Iterable));
  }
}

class JMDict {
  final JMDictTagsDescription tagsDescription;
  final List<JMDictWord> words;

  JMDict({required this.tagsDescription, required this.words});

  factory JMDict.fromJson(Map<String, dynamic> unparsedDict) {
    return JMDict(
        tagsDescription: JMDictTagsDescription.from(
            unparsedDict['tags'] as Map<String, dynamic>),
        words: List<JMDictWord>.from((unparsedDict['words'].map(
                (dynamic unparsedWord) =>
                    JMDictWord.fromJson(unparsedWord as Map<String, dynamic>)))
            as Iterable));
  }
}

typedef JMDictSenseDefinition = String;
typedef JMDictTag = String;
typedef JMDictTagsDescription = Map<JMDictTag, String>;
