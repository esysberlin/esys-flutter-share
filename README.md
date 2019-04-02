# esys_flutter_share

A [Flutter](https://flutter.io) plugin for sharing images & text with other applications.

## Usage

Import:

```dart
import 'package:esys_flutter_share/esys_flutter_share.dart';
```

Share text:

```dart
Share.text('my text title', 'This is my text to share with other applications.', 'text/plain');
```

Share file:

```dart
final ByteData bytes = await rootBundle.load('assets/image1.png');
await Share.file('esys image', 'esys.png', bytes.buffer.asUint8List(), 'image/png');
```

Share files:

```dart
final ByteData bytes1 = await rootBundle.load('assets/image1.png');
final ByteData bytes2 = await rootBundle.load('assets/image2.png');

await Share.files(
    'esys images',
    {
        'esys.png': bytes1.buffer.asUint8List(),
        'bluedan.png': bytes2.buffer.asUint8List(),
    },
    'image/png');
```

Share file from url:

```dart
var request = await HttpClient().getUrl(Uri.parse('https://shop.esys.eu/media/image/6f/8f/af/amlog_transport-berwachung.jpg'));
var response = await request.close();
Uint8List bytes = await consolidateHttpClientResponseBytes(response);
await Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
```

Check out the example app in the Repository for further information.


