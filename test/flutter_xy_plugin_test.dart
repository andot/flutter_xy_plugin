import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_xy_plugin/flutter_xy_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_xy_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isLandingPageDisplayActionBarEnabled', () async {
    expect(await FlutterXyPlugin.landingPageDisplayActionBarEnabled, false);
  });
}
