import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

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
          title: Text('Share Example'),
        ),
        floatingActionButton: Builder(
            builder: (BuildContext context) => IconButton(
                  icon: Icon(Icons.file_download),
                  onPressed: () => _shareImage(context),
                )),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share text'),
                          onPressed: () async => await _shareText(context),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share image'),
                          onPressed: () async => await _shareImage(context),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share images'),
                          onPressed: () async => await _shareImages(context),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share CSV'),
                          onPressed: () async => await _shareCSV(context),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share mixed'),
                          onPressed: () async => await _shareMixed(context),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share image from url'),
                          onPressed: () async =>
                              await _shareImageFromUrl(context),
                        ),
                      ),
                      Builder(
                        builder: (BuildContext context) => MaterialButton(
                          child: Text('Share sound'),
                          onPressed: () async => await _shareSound(context),
                        ),
                      ),
                      MaterialButton(
                        child: Text('Share not bounded'),
                        onPressed: () async => await _shareImageNotBounded(),
                      ),
                      MaterialButton(
                        child: Text('Share bounded to window'),
                        onPressed: () async => await _shareImage(context),
                      ),
                    ],
                  )),
            ),
            Positioned(
                child: Builder(
                    builder: (BuildContext context) => IconButton(
                          icon: Icon(Icons.file_download),
                          onPressed: () => _shareImage(context),
                        )),
                bottom: 0,
                left: 0)
          ],
        ));
  }

  Rect rect(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.localToGlobal(Offset.zero) & box.size;
  }

  Future<void> _shareText(BuildContext context) async {
    try {
      Share.text(
        'my text title',
        'This is my text to share with other applications.',
        'text/plain',
        sharePositionOrigin: rect(context),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImage(BuildContext context) async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image1.png');
      await Share.file(
          'esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png',
          text: 'My optional text.', sharePositionOrigin: rect(context));
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImageNotBounded() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image1.png');
      await Share.file(
          'esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png',
          text: 'My optional text.');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImages(BuildContext context) async {
    try {
      final ByteData bytes1 = await rootBundle.load('assets/image1.png');
      final ByteData bytes2 = await rootBundle.load('assets/image2.png');

      await Share.files(
        'esys images',
        {
          'esys.png': bytes1.buffer.asUint8List(),
          'bluedan.png': bytes2.buffer.asUint8List(),
        },
        'image/png',
        sharePositionOrigin: rect(context),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareCSV(BuildContext context) async {
    try {
      final ByteData bytes = await rootBundle.load('assets/addresses.csv');
      await Share.file(
        'addresses',
        'addresses.csv',
        bytes.buffer.asUint8List(),
        'text/csv',
        sharePositionOrigin: rect(context),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareMixed(BuildContext context) async {
    try {
      final ByteData bytes1 = await rootBundle.load('assets/image1.png');
      final ByteData bytes2 = await rootBundle.load('assets/image2.png');
      final ByteData bytes3 = await rootBundle.load('assets/addresses.csv');

      await Share.files(
        'esys images',
        {
          'esys.png': bytes1.buffer.asUint8List(),
          'bluedan.png': bytes2.buffer.asUint8List(),
          'addresses.csv': bytes3.buffer.asUint8List(),
        },
        '*/*',
        text: 'My optional text.',
        sharePositionOrigin: rect(context),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImageFromUrl(BuildContext context) async {
    try {
      var request = await HttpClient().getUrl(Uri.parse(
          'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file(
        'ESYS AMLOG',
        'amlog.jpg',
        bytes,
        'image/jpg',
        sharePositionOrigin: rect(context),
      );
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareSound(BuildContext context) async {
    try {
      final ByteData bytes = await rootBundle.load('assets/cat.mp3');
      await Share.file(
        'Sound',
        'cat.mp3',
        bytes.buffer.asUint8List(),
        'audio/*',
        sharePositionOrigin: rect(context),
      );
    } catch (e) {
      print('error: $e');
    }
  }
}
