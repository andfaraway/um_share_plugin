import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:um_share_plugin/um_share_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('um_share_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await UmSharePlugin.platformVersion, '42');
  });
}
