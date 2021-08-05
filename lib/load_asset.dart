import 'dart:async' show Future;
import 'dart:convert' show json, utf8;

import 'package:flutter/services.dart';

Future<Map<String, dynamic>> getDecodedDictJson(String assetPath) async {
  // rootBundle.loadString currently crashes when the asset is too large
  ByteData data = await rootBundle.load(assetPath);
  String jsonData = utf8.decode(data.buffer.asUint8List());
  return json.decode(jsonData) as Map<String, dynamic>;
}
