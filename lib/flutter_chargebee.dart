import 'package:flutter_chargebee/platforms/android.dart';
import 'package:flutter_chargebee/platforms/ios.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'flutter_chargebee_platform_interface.dart';

class FlutterChargebee {
  /// Configure the app details with chargebee system.
  Future<void> configure({
    required String site,
    required String apiKey,
    required String androidSdkKey,
    required String iosSdkKey,
  }) async {
    final info = await PackageInfo.fromPlatform();
    return FlutterChargebeePlatform.instance.configure(
      site: site,
      apiKey: apiKey,
      androidSdkKey: androidSdkKey,
      iosSdkKey: iosSdkKey,
      packageName: info.packageName,
    );
  }

  /// Retrieve all available Chargebee product ids based on their native store product ids.
  Future<List<String>> retrieveProductIDs({
    int limit = 100,
  }) async {
    final ret = await FlutterChargebeePlatform.instance.retrieveProductIDs(
      limit: limit,
    );
    return ret;
  }

  /// Retrieves all available Chargebee products from the Google Playstore.
  Future<List<CBProduct>> retrieveProductsPlaystore({
    required List<String> productIds,
  }) async {
    return FlutterChargebeePlatform.instance.retrieveProductsPlaystore(
      productIds: productIds,
    );
  }

  /// Retrieve all available Chargebee products from the Apple Appstore.
  Future<List<AppStoreProduct>> retrieveProductsAppstore({
    required List<String> productIds,
  }) async {
    return FlutterChargebeePlatform.instance.retrieveProductsAppstore(
      productIds: productIds,
    );
  }

  /// Purchase a product in Chargebee through the native store dialog.
  Future<ChargebeePurchaseResult> purchaseProduct({
    required String customerID,
    required String productId,
  }) async {
    final result = await FlutterChargebeePlatform.instance.purchaseProduct(
      customerId: customerID,
      productId: productId,
    );
    return ChargebeePurchaseResult(
      subscriptionId: result['subscriptionId'],
      status: result['status'],
    );
  }
}

class ChargebeePurchaseResult {
  final String subscriptionId;
  final bool status;

  ChargebeePurchaseResult({
    required this.subscriptionId,
    required this.status,
  });
}
