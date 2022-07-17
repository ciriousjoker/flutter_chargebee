import 'package:flutter_chargebee/flutter_chargebee_method_channel.dart';
import 'package:flutter_chargebee/platforms/android.dart';
import 'package:flutter_chargebee/platforms/ios.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterChargebeePlatform extends PlatformInterface {
  /// Constructs a ChargebeePlatform.
  FlutterChargebeePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterChargebeePlatform _instance = MethodChannelFlutterChargebee();

  /// The default instance of [FlutterChargebeePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterChargebee].
  static FlutterChargebeePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterChargebeePlatform] when
  /// they register themselves.
  static set instance(FlutterChargebeePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Configure the app details with chargebee system.
  Future<void> configure({
    required String site,
    required String apiKey,
    required String androidSdkKey,
    required String iosSdkKey,
    required String packageName,
  }) {
    throw UnimplementedError('configure() has not been implemented.');
  }

  /// Retrieve all available Chargebee product ids based on their native store product ids.
  Future<List<String>> retrieveProductIDs({
    int limit = 100,
  }) async {
    throw UnimplementedError('retrieveProductIDs() has not been implemented.');
  }

  /// Retrieves all available Chargebee products from the Google Playstore.
  Future<List<CBProduct>> retrieveProductsPlaystore({
    required List<String> productIds,
  }) async {
    throw UnimplementedError(
      'retrieveProductsPlaystore() has not been implemented.',
    );
  }

  /// Retrieve all available Chargebee products from the Apple Appstore.
  Future<List<AppStoreProduct>> retrieveProductsAppstore({
    required List<String> productIds,
  }) async {
    throw UnimplementedError(
      'retrieveProductsAppstore() has not been implemented.',
    );
  }

  /// Purchase a product in Chargebee through the native store dialog.
  Future<dynamic> purchaseProduct({
    required String customerId,
    required String productId,
  }) {
    throw UnimplementedError('purchaseProduct() has not been implemented.');
  }
}
