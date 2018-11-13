import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class EsysFlutterShare {
  static const MethodChannel _channel = const MethodChannel(
      'channel:github.com/orgs/esysberlin/esys-flutter-share');

  /// Shares images with other supported applications on Android and iOS.
  /// The title parameter is just supported on Android and does nothing on iOS.
  static Future shareImage(
      String name, String title, ByteData imageBytes) async {
    Map sendMap = <String, String>{'name': '$name', 'title': '$title'};

    final Uint8List list = imageBytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$name').create();
    file.writeAsBytesSync(list);

    _channel.invokeMethod('shareImage', sendMap);
  }
}
