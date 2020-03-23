import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
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
  Rect getSharePopoverLocation() {
    return Rect.fromLTWH(MediaQuery.of(context).size.width - 100.0,
        MediaQuery.of(context).size.height, 0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Share Example'),
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
                MaterialButton(
                  child: Text('Share images'),
                  onPressed: () async => await _shareImages(),
                ),
                MaterialButton(
                  child: Text('Share CSV'),
                  onPressed: () async => await _shareCSV(),
                ),
                MaterialButton(
                  child: Text('Share mixed'),
                  onPressed: () async => await _shareMixed(),
                ),
                MaterialButton(
                  child: Text('Share image from url'),
                  onPressed: () async => await _shareImageFromUrl(),
                ),
                MaterialButton(
                  child: Text('Share sound'),
                  onPressed: () async => await _shareSound(),
                ),
              ],
            )));
  }

  Future<bool> _isIpad() async {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    return iosInfo.name.toLowerCase().contains('ipad');
  }

  Future<void> _shareText() async {
    try {
      final bool isIpad = await _isIpad();
      Share.text('my text title',
          'This is my text to share with other applications.', 'text/plain',
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImage() async {
    try {
      final bool isIpad = await _isIpad();
      final ByteData bytes = await rootBundle.load('assets/image1.png');
      await Share.file(
          'esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png',
          text: 'My optional text.',
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImages() async {
    try {
      final bool isIpad = await _isIpad();
      final ByteData bytes1 = await rootBundle.load('assets/image1.png');
      final ByteData bytes2 = await rootBundle.load('assets/image2.png');

      await Share.files(
          'esys images',
          {
            'esys.png': bytes1.buffer.asUint8List(),
            'bluedan.png': bytes2.buffer.asUint8List(),
          },
          'image/png',
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareCSV() async {
    try {
      final bool isIpad = await _isIpad();
      final ByteData bytes = await rootBundle.load('assets/addresses.csv');
      await Share.file(
          'addresses', 'addresses.csv', bytes.buffer.asUint8List(), 'text/csv',
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareMixed() async {
    try {
      final bool isIpad = await _isIpad();
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
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareImageFromUrl() async {
    try {
      final bool isIpad = await _isIpad();
      var request = await HttpClient().getUrl(Uri.parse(
          'https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg',
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _shareSound() async {
    try {
      final bool isIpad = await _isIpad();
      final ByteData bytes = await rootBundle.load('assets/cat.mp3');
      await Share.file(
          'Sound', 'cat.mp3', bytes.buffer.asUint8List(), 'audio/*',
          sharePositionOrigin: isIpad ? getSharePopoverLocation() : null);
    } catch (e) {
      print('error: $e');
    }
  }
}
