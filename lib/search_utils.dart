import 'dart:math';

import 'package:characters/characters.dart';
import 'jmdict_classes.dart';

double calculateCustomIndex(String a, String b) {
  Set<String> aStringCharacterSet = a.characters.toSet();
  Set<String> bStringCharacterSet = b.characters.toSet();

  return aStringCharacterSet.intersection(bStringCharacterSet).length /
      max(a.length, b.length);
}

// double calculateMean(Iterable<double> nums) {
//   double _mean = 0.0;
//   for (double _num in nums) {
//     _mean += _num;
//   }
//   _mean = _mean / nums.length;
//   return _mean;
// }
//
// double findMedian(Iterable<double> nums) {
//   var _nums = nums.toList();
//   var _index = (_nums.length / 2).floor();
//   if (_nums.length.isEven) {
//     return ((_nums.toList()[_index - 1] + _nums.toList()[_index]) / 2);
//   }
//   if (_nums.length.isOdd) {
//     return _nums.toList()[_index];
//   }
//   throw Error();
// }

int Function(JMDictWord, JMDictWord) compareWritingsByCustomIndex(String keyword) {
  return (JMDictWord a, JMDictWord b) {
    // compare maximum indices of all writings
    Iterable<double> aAllWritingIndices = a.writings
        .map((writing) => calculateCustomIndex(writing.text, keyword));
    Iterable<double> bAllWritingIndices = b.writings
        .map((writing) => calculateCustomIndex(writing.text, keyword));

    double aAllWritingMaxIndex = aAllWritingIndices.reduce(max);
    double bAllWritingMaxIndex = bAllWritingIndices.reduce(max);

    if (aAllWritingMaxIndex > bAllWritingMaxIndex) {
      // a should come earlier
      return -1;
    }
    if (aAllWritingMaxIndex < bAllWritingMaxIndex) {
      // b should come earlier
      return 1;
    }

    // tie in maximum indices of all writings, on to compare maximum indices of common writings
    Iterable<double> aCommonWritingIndices = a.writings.map((writing) {
      if (writing.isCommon) {
        return calculateCustomIndex(writing.text, keyword);
      } else {
        return 0.0;
      }
    });
    Iterable<double> bCommonWritingIndices = b.writings.map((writing) {
      if (writing.isCommon) {
        return calculateCustomIndex(writing.text, keyword);
      } else {
        return 0.0;
      }
    });

    double aCommonWritingMaxIndex = aCommonWritingIndices.reduce(max);
    double bCommonWritingMaxIndex = bCommonWritingIndices.reduce(max);

    if (aCommonWritingMaxIndex > bCommonWritingMaxIndex) {
      // a should come earlier
      return -1;
    }
    if (aCommonWritingMaxIndex < bCommonWritingMaxIndex) {
      // b should come earlier
      return 1;
    }

    // // on to compare means
    // double aAllWritingMeanIndex = calculateMean(aAllWritingIndices);
    // double bAllWritingMeanIndex = calculateMean(bAllWritingIndices);
    // if (aAllWritingMeanIndex > bAllWritingMeanIndex) {
    //   // a should come earlier
    //   return -1;
    // }
    // if (aAllWritingMeanIndex < bAllWritingMeanIndex) {
    //   // b should come earlier
    //   return 1;
    // }

    // // on to compare medians
    // double aAllWritingMedianIndex = findMedian(aAllWritingIndices);
    // double bAllWritingMedianIndex = findMedian(bAllWritingIndices);
    // if (aAllWritingMedianIndex > bAllWritingMedianIndex) {
    //   // a should come earlier
    //   return -1;
    // }
    // if (aAllWritingMedianIndex < bAllWritingMedianIndex) {
    //   // b should come earlier
    //   return 1;
    // }

    // return tie
    return 0;
  };
}

int Function(JMDictWord, JMDictWord) compareDefinitionsByCustomIndex(String keyword) {
  return (JMDictWord a, JMDictWord b) {
    // compare maximum indices of all definitions

    double aAllDefinitionsMaxIndex = 0.0;
    double bAllDefinitionsMaxIndex = 0.0;

    for (var _sense in a.senses) {
      for (var _definition in _sense.definitions) {
        aAllDefinitionsMaxIndex = max(aAllDefinitionsMaxIndex, calculateCustomIndex(_definition.toLowerCase(), keyword.toLowerCase()));
      }
    }
    for (var _sense in b.senses) {
      for (var _definition in _sense.definitions) {
        bAllDefinitionsMaxIndex = max(bAllDefinitionsMaxIndex, calculateCustomIndex(_definition.toLowerCase(), keyword.toLowerCase()));
      }
    }

    if (aAllDefinitionsMaxIndex > bAllDefinitionsMaxIndex) {
      // a should come earlier
      return -1;
    }
    if (aAllDefinitionsMaxIndex < bAllDefinitionsMaxIndex) {
      // b should come earlier
      return 1;
    }

    double aMeanOfMaxDefinitionIndex = 0.0;
    double bMeanOfMaxDefinitionIndex = 0.0;

    for (var _sense in a.senses) {
      double _maxDefinitionIndex = 0.0;
      for (var _definition in _sense.definitions) {
        _maxDefinitionIndex = max(_maxDefinitionIndex, calculateCustomIndex(_definition, keyword));
      }
      aMeanOfMaxDefinitionIndex += _maxDefinitionIndex;
    }
    aMeanOfMaxDefinitionIndex = aMeanOfMaxDefinitionIndex / a.senses.length;

    for (var _sense in b.senses) {
      double _maxDefinitionIndex = 0.0;
      for (var _definition in _sense.definitions) {
        _maxDefinitionIndex = max(_maxDefinitionIndex, calculateCustomIndex(_definition, keyword));
      }
      bMeanOfMaxDefinitionIndex += _maxDefinitionIndex;
    }
    bMeanOfMaxDefinitionIndex = bMeanOfMaxDefinitionIndex / b.senses.length;

    if (aMeanOfMaxDefinitionIndex > bMeanOfMaxDefinitionIndex) {
      // a should come earlier
      return -1;
    }
    if (aMeanOfMaxDefinitionIndex < bMeanOfMaxDefinitionIndex) {
      // b should come earlier
      return 1;
    }

    // return tie
    return 0;
  };
}

List<JMDictWord> searchWritings(
    {required String keyword, required JMDict dictData}) {
  List<JMDictWord> _result = dictData.words
      .where(
        (word) => word.writings.any(
          (writing) => writing.text.contains(keyword),
        ),
      )
      .toList();

  _result.sort(compareWritingsByCustomIndex(keyword));

  return _result;
}

List<JMDictWord> searchSenses(
    {required String keyword, required JMDict dictData}) {
  List<JMDictWord> _result = dictData.words
      .where(
        (word) => word.senses.any(
          (sense) => sense.definitions.any(
              (definition) => definition.toLowerCase().contains(keyword.toLowerCase()),
          ),
        ),
      )
      .toList();

  _result.sort(compareDefinitionsByCustomIndex(keyword));

  return _result;
}
