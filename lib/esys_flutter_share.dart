import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Share {
  static const MethodChannel _channel = MethodChannel('channel:github.com/orgs/esysberlin/esys-flutter-share');

  /// Sends a text to other apps.
  static void text(String? title, String? text, String? mimeType) {
    final Map<String?, String?> argsMap = <String?, String?>{'title': title, 'text': text, 'mimeType': mimeType};
    _channel.invokeMethod('text', argsMap);
  }

  /// Sends a file to other apps.
  static Future<void>? file(String? title, String? name, List<int> bytes, String? mimeType, {String? text = ''}) async {
    final Map<String?, String?> argsMap = <String?, String?>{
      'title': title,
      'name': name,
      'mimeType': mimeType,
      'text': text
    };

    final Directory tempDir = await getTemporaryDirectory();
    final File file = await File('${tempDir.path}/$name').create();
    await file.writeAsBytes(bytes);

    _channel.invokeMethod('file', argsMap);
  }

  /// Sends multiple files to other apps.
  static Future<void>? files(String? title, Map<String, List<int>> files, String? mimeType, {String? text = ''}) async {
    final Map<String?, dynamic> argsMap = <String?, dynamic>{
      'title': title,
      'names': files.entries.toList().map((MapEntry<String, List<int>> x) => x.key).toList(),
      'mimeType': mimeType,
      'text': text
    };

    final Directory tempDir = await getTemporaryDirectory();

    for (final MapEntry<String, List<int>> entry in files.entries) {
      final File file = await File('${tempDir.path}/${entry.key}').create();
      await file.writeAsBytes(entry.value);
    }

    _channel.invokeMethod('files', argsMap);
  }
}
