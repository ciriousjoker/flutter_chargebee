import 'package:deep_pick/deep_pick.dart';

/// A simplified version of an Appstore product
/// This thing is not 100% complete, complete it as necessary.
class AppStoreProduct {
  final String localizedDescription;
  final String contentVersion;
  final String downloadContentVersion;
  final String localizedTitle;
  final String productIdentifier;
  final String debugDescription;
  final String description;
  final double price;
  final bool isDownloadable;
  final String priceLocale;
  final SubscriptionPeriod? subscriptionPeriod;

  AppStoreProduct({
    required this.localizedDescription,
    required this.contentVersion,
    required this.downloadContentVersion,
    required this.localizedTitle,
    required this.productIdentifier,
    required this.debugDescription,
    required this.description,
    required this.price,
    required this.isDownloadable,
    required this.priceLocale,
    required this.subscriptionPeriod,
  });

  factory AppStoreProduct.fromMap(Map<String, dynamic> map) {
    final subscriptionPeriodData =
        pick(map, "subscriptionPeriod").asMapOrNull<String, dynamic>();

    return AppStoreProduct(
      localizedDescription: pick(map, "localizedDescription").asStringOrThrow(),
      contentVersion: pick(map, "contentVersion").asStringOrThrow(),
      downloadContentVersion:
          pick(map, "downloadContentVersion").asStringOrThrow(),
      localizedTitle: pick(map, "localizedTitle").asStringOrThrow(),
      productIdentifier: pick(map, "productIdentifier").asStringOrThrow(),
      debugDescription: pick(map, "debugDescription").asStringOrThrow(),
      description: pick(map, "description").asStringOrThrow(),
      price: pick(map, "price").asDoubleOrThrow(),
      isDownloadable: pick(map, "isDownloadable").asBoolOrThrow(),
      priceLocale: pick(map, "priceLocale").asStringOrThrow(),
      subscriptionPeriod: subscriptionPeriodData != null
          ? SubscriptionPeriod.fromMap(subscriptionPeriodData)
          : null,
    );
  }
}

class SubscriptionPeriod {
  final String? unit;
  final int numberOfUnits;

  SubscriptionPeriod({
    required this.unit,
    required this.numberOfUnits,
  });

  factory SubscriptionPeriod.fromMap(Map<String, dynamic> map) {
    return SubscriptionPeriod(
      unit: pick(map, "unit").asStringOrNull(),
      numberOfUnits: pick(map, "numberOfUnits").asIntOrThrow(),
    );
  }
}
