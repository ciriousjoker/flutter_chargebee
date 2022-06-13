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
  final SubscriptionPeriod subscriptionPeriod;

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
    return AppStoreProduct(
      localizedDescription: map['localizedDescription'],
      contentVersion: map['contentVersion'],
      downloadContentVersion: map['downloadContentVersion'],
      localizedTitle: map['localizedTitle'],
      productIdentifier: map['productIdentifier'],
      debugDescription: map['debugDescription'],
      description: map['description'],
      price: map['price'],
      isDownloadable: map['isDownloadable'],
      priceLocale: map['priceLocale'],
      subscriptionPeriod: SubscriptionPeriod.fromMap(
        Map<String, dynamic>.from(map['subscriptionPeriod']),
      ),
    );
  }
}

class SubscriptionPeriod {
  final String unit;
  final int numberOfUnits;

  SubscriptionPeriod({
    required this.unit,
    required this.numberOfUnits,
  });

  factory SubscriptionPeriod.fromMap(Map<String, dynamic> map) {
    return SubscriptionPeriod(
      unit: map['unit'],
      numberOfUnits: map['numberOfUnits'],
    );
  }
}
