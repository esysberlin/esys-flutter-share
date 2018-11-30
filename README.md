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

Check out the example app in the Repository for further information.


