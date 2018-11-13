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
          title: Text('Esys Share Plugin Sample'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: MaterialButton(
                  child: Text('Share image'),
                  onPressed: _shareImage,
                ),
              ),
            ],
          ),
        ));
  }

  _shareImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/image.png');
      // title just for android, not supported in ios
      EsysFlutterShare.shareImage('myImageTest.png', 'myTitle', bytes);
    } catch (e) {
      print('error: $e');
    }
  }
}
