import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
  onScreenshot: (name, bytes, [args]) async {
    if (!const {'home', 'work', 'calendar'}.contains(name) || bytes.isEmpty) {
      return false;
    }
    final directory = Directory('build/qa/device');
    await directory.create(recursive: true);
    await File('${directory.path}/$name.png').writeAsBytes(bytes);
    return true;
  },
);
