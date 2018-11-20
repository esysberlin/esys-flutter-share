import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class EsysFlutterShare {
  static const MethodChannel _channel = const MethodChannel(
      'channel:github.com/orgs/esysberlin/esys-flutter-share');

  /// Shares text with other supported applications on Android and iOS.
  /// The title parameter is just supported on Android and does nothing on iOS.
  static Future shareText(String text, String droidTitle) async {
    Map argsMap = <String, String>{'text': '$text', 'title': '$droidTitle'};
    _channel.invokeMethod('shareText', argsMap);
  }

  /// Shares images with other supported applications on Android and iOS.
  /// The title parameter is just supported on Android and does nothing on iOS.
  static Future shareImage(
      String fileName, ByteData imageBytes, String droidTitle) async {
    Map argsMap = <String, String>{
      'fileName': '$fileName',
      'title': '$droidTitle'
    };

    final Uint8List list = imageBytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(list);

    _channel.invokeMethod('shareImage', argsMap);
  }
}
