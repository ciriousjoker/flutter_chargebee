import Flutter
import UIKit
import Chargebee
import StoreKit

public class SwiftFlutterChargebeePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_chargebee", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterChargebeePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "configure":
            configure(call, result);
            break;
        case "retrieveProductIDs":
            retrieveProductIDs(call, result);
            break;
        case "retrieveProducts":
            retrieveProducts(call, result);
            break;
        case "purchaseProduct":
            purchaseProduct(call, result);
            break;
        default:
            result(FlutterMethodNotImplemented);
        }
    }
    
    public func configure(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = MapArgumentReader(call.arguments as? [String: Any])
        
        Chargebee.configure(
            site: args.string("site")!,
            apiKey:args.string("apiKey")!,
            sdkKey:args.string("iosSdkKey")!
        )
        result(nil)
    }
    
    public func retrieveProductIDs(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        CBPurchase.shared.retrieveProductIdentifers(
            queryParams: ["limit": "100"],
            completion:  { chargebeeResult in
                switch chargebeeResult {
                case let .success(products):
                    result(products.ids);
                    break;
                case let .failure(error):
                    self.sendError(result, error)
                    break;
                }
            })
    }
    
    public func retrieveProducts(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = MapArgumentReader(call.arguments as? [String: Any])
        
        CBPurchase.shared.retrieveProducts(
            withProductID: args.stringArray("productIds")!,
            completion: { chargebeeResult in
                switch chargebeeResult {
                case let .success(products):
                    let retProducts = products.map {
                        $0.product.toDictionary()
                    }
                    result(retProducts)
                    break;
                case let .failure(error):
                    self.sendError(result, error)
                    break;
                }
            });
        
    }
    
    
    public func purchaseProduct(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = MapArgumentReader(call.arguments as? [String: Any])
        let productId = args.string("productId")!;
        let customerId = args.string("customerID")!;
        
        CBPurchase.shared.retrieveProducts(
            withProductID: [productId],
            completion: { chargebeeResult in
                switch chargebeeResult {
                case let .success(products):
                    let product = products.first!;
                    CBPurchase.shared.purchaseProduct(
                        product: product,
                        customerId: customerId) { chargebeeResult in
                            switch chargebeeResult {
                            case .success(let subscription):
                                result([
                                    "status": subscription.status,
                                    "subscriptionId": subscription.subscriptionId as Any,
                                ]);
                            case .failure(let error):
                                self.sendError(result, error)
                                break;
                            }
                        }
                    break;
                case let .failure(error):
                    self.sendError(result, error)
                    break;
                }
            });
    }
    
    private func sendError(_ result: @escaping FlutterResult, _ error: Error) {
        result(FlutterError.init(code: "chargebee-error", message: error.localizedDescription, details: nil))
    }
}

class MapArgumentReader {
    let args: [String: Any]?
    
    init(_ args: [String: Any]?) {
        self.args = args
    }
    
    func string(_ key: String) -> String? {
        return args?[key] as? String
    }
    
    func int(_ key: String) -> Int? {
        return (args?[key] as? NSNumber)?.intValue
    }
    
    func bool(_ key: String) -> Bool? {
        return (args?[key] as? NSNumber)?.boolValue
    }
    
    func stringArray(_ key: String) -> [String]? {
        return args?[key] as? [String]
    }
    
    func intArray(_ key: String) -> [Int]? {
        return args?[key] as? [Int]
    }
}


extension SKProduct {
    func toDictionary()->[String:Any?]  {
        var subscriptionPeriod: [String: Any?]? = nil;
        
        if(self.subscriptionPeriod != nil) {
            let unit = self.subscriptionPeriod!.unit;
            var unitString: String? = nil;
            switch (unit) {
            case PeriodUnit.day:
                unitString = "day";
                break;
            case PeriodUnit.week:
                unitString = "week";
                break;
            case PeriodUnit.month:
                unitString = "month";
                break;
            case PeriodUnit.year:
                unitString = "year";
                break;
            default:
                unitString = nil;
            }
            
            subscriptionPeriod = [
                "unit": unitString,
                "numberOfUnits": self.subscriptionPeriod!.numberOfUnits,
            ];
        }
        
        let product = [
            "localizedDescription": self.localizedDescription,
            "contentVersion": self.contentVersion,
            "downloadContentVersion": self.downloadContentVersion,
            "localizedTitle": self.localizedTitle,
            "productIdentifier": self.productIdentifier,
            "debugDescription": self.debugDescription,
            "description": self.description,
            "price": self.price.doubleValue,
            "isDownloadable": self.isDownloadable,
            "priceLocale": self.priceLocale.identifier,
            "subscriptionPeriod": subscriptionPeriod,
        ] as [String : Any?];
        return product;
    }
}
