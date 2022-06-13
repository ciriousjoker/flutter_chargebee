import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_chargebee/flutter_chargebee_method_channel.dart';

/// This file just demonstrates how to create tests, but since this
/// plugin just wraps the native sdks, there's nothing to test.
void main() {
  // MethodChannelFlutterChargebee platform = MethodChannelFlutterChargebee();
  const MethodChannel channel = MethodChannel('flutter_chargebee');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      // Some mock implementation
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('retrieveProductIDs', () async {
  //   expect(await platform.retrieveProductIDs(), ['some_id']);
  // });
}
