import 'package:flutter_chargebee/flutter_chargebee_method_channel.dart';
import 'package:flutter_chargebee/flutter_chargebee_platform_interface.dart';
import 'package:flutter_chargebee/platforms/android.dart';
import 'package:flutter_chargebee/platforms/ios.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterChargebeePlatform
    with MockPlatformInterfaceMixin
    implements FlutterChargebeePlatform {
  @override
  Future<void> configure({
    required String site,
    required String apiKey,
    required String androidSdkKey,
    required String iosSdkKey,
    required String packageName,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<String>> retrieveProductIDs({
    int limit = 100,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<CBProduct>> retrieveProductsPlaystore({
    required List<String> productIds,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<AppStoreProduct>> retrieveProductsAppstore({
    required List<String> productIds,
  }) {
    throw UnimplementedError();
  }

  @override
  Future purchaseProduct({
    required String customerId,
    required String productId,
  }) {
    throw UnimplementedError();
  }
}

/// This file is just a demonstration of how to create tests for the mock implementation,
/// but since this plugin just wraps the native sdks, there's nothing to test.
void main() {
  final FlutterChargebeePlatform initialPlatform =
      FlutterChargebeePlatform.instance;

  test('$MethodChannelFlutterChargebee is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterChargebee>());
  });

  // test('retrieveProductIDs', () async {
  //   FlutterChargebee flutterChargebeePlugin = FlutterChargebee();
  //   MockFlutterChargebeePlatform fakePlatform = MockFlutterChargebeePlatform();
  //   FlutterChargebeePlatform.instance = fakePlatform;

  //   expect(await flutterChargebeePlugin.retrieveProductIDs(), ['some_id']);
  // });
}
