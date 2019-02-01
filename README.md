# esys_flutter_share

A [Flutter](https://flutter.io) plugin for sharing images & text with other applications.

## Usage

Import:

```dart
import 'package:esys_flutter_share/esys_flutter_share.dart';
```

Share text:

```dart
await EsysFlutterShare.shareText('This is my text to share with other applications.', 'my text title');
```

Share image:

```dart
final ByteData bytes = await rootBundle.load('assets/image.png');
await EsysFlutterShare.shareImage('myImageTest.png', bytes, 'my image title');
```

Share images:

```dart
List<ByteData> byteDatas = List<ByteData>();
List<String> fileNames = List<String>();

ByteData bytes = await rootBundle.load('assets/image.png');
byteDatas.add(bytes);
fileNames.add("image1");

ByteData bytes2 = await rootBundle.load('assets/image2.png');
byteDatas.add(bytes2);
fileNames.add("image2");

await EsysFlutterShare.shareImages(fileNames, byteDatas, 'my image title');
```

Share image from URL:

This method return ByteData from given image's url.
```dart
  Future<ByteData> _getImageBytes(String imageUrl) async {
    var request = await HttpClient().getUrl(Uri.parse(imageUrl));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    ByteData byteData = ByteData.view(bytes.buffer);
    return byteData;
  }
```


Check out the example app in the Repository for further information.


