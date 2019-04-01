import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
      home: MaterialApp(
        home: MyHomePage(),
      ),
    ));

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Esys Share Plugin Sample'),
        ),
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                MaterialButton(
                  child: Text('Share text'),
                  onPressed: () async => await _shareText(),
                ),
                MaterialButton(
                  child: Text('Share image'),
                  onPressed: () async => await _shareImage(),
                ),
              ],
            )));
  }

  Future _shareText() async {
    try {
      await Share.shareText(
          'This is my text to share with other applications.', 'my text title');
    } catch (e) {
      print('error: $e');
    }
  }

  Future _shareImage() async {
    final ByteData bytes = await rootBundle.load('assets/image.png');
    String path = await _localPath + '/image.png';
    await writeBytes(bytes.buffer.asUint8List(), path);
    print(await readBytes(path));
    await Share.file(path, 'image/png');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeBytes(List<int> bytes, String path) async {
    var file = File('$path');
    return await file.writeAsBytes(bytes);
  }

  Future<List<int>> readBytes(String path) async {
    try {
      final file = File(path);

      // Read the file
      List<int> contents = await file.readAsBytes();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return List();
    }
  }
}
