package com.dieringe.flutter_chargebee

import androidx.annotation.NonNull
import com.chargebee.android.Chargebee
import com.chargebee.android.billingservice.CBCallback
import com.chargebee.android.billingservice.CBPurchase
import com.chargebee.android.exceptions.CBException
import com.chargebee.android.exceptions.CBProductIDResult
import com.chargebee.android.models.CBProduct
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterChargebeePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    // We need to keep track of the activity because purchaseProduct() needs it.
    // To get an activity reference, we implement ActivityAware and override the respective functions.
    private var activity: FlutterActivity? = null

    private lateinit var binaryMessenger: BinaryMessenger

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        binaryMessenger = flutterPluginBinding.binaryMessenger
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity

        channel = MethodChannel(binaryMessenger, "flutter_chargebee")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity as FlutterActivity
    }

    override fun onDetachedFromActivity() {
        this.activity = null
    }

    // This is the main entry point into the plugin. Every call from Dart code comes in here
    // and is handled by the individual functions.
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "configure" -> configure(call, result)
            "retrieveProductIDs" -> retrieveProductIDs(call, result)
            "retrieveProducts" -> retrieveProducts(call, result)
            "purchaseProduct" -> purchaseProduct(call, result)

            else -> result.notImplemented()
        }
    }


    private fun configure(@NonNull call: MethodCall, @NonNull result: Result) {
        Chargebee.configure(
            site = call.argument<String>("site")!!,
            publishableApiKey = call.argument<String>("apiKey")!!,
            sdkKey = call.argument<String>("androidSdkKey")!!,
            packageName = call.argument<String>("packageName")!!
        )

        result.success(null)
    }

    private fun retrieveProductIDs(@NonNull call: MethodCall, @NonNull result: Result) {
        val limit = call.argument<Int>("limit")!!

        // First array element is considered the limit, so we pass it here.
        // Documentation is sparse on this, but it works.
        CBPurchase.retrieveProductIDs(arrayOf(limit.toString())) {
            when (it) {
                is CBProductIDResult.ProductIds -> {
                    val array = it.IDs.toTypedArray().toList()
                    result.success(array)
                }
                is CBProductIDResult.Error -> {
                    sendError(result, it.exp)
                }
            }
        }
    }

    private fun retrieveProducts(@NonNull call: MethodCall, @NonNull result: Result) {
        CBPurchase.retrieveProducts(
            this.activity!!,
            call.argument<ArrayList<String>>("productIds")!!,
            object : CBCallback.ListProductsCallback<ArrayList<CBProduct>> {
                override fun onSuccess(productIDs: ArrayList<CBProduct>) {
                    val products = productIDs.toList().map { details ->
                        mapOf(
                            "productId" to details.productId,
                            "productPrice" to details.productPrice,
                            "productTitle" to details.productTitle,
                            "subStatus" to details.subStatus,

                            // For now the easiest way is to just pass the json string.
                            // If these details are ever needed, we can parse it into a map.
                            "skuDetails" to details.skuDetails.originalJson,
                        )
                    }

                    result.success(products)
                }

                override fun onError(error: CBException) {
                    sendError(result, error)
                }
            }
        )
    }

    private fun purchaseProduct(@NonNull call: MethodCall, @NonNull result: Result) {
        val customerID = call.argument<String>("customerID")!!

        CBPurchase.retrieveProducts(
            this.activity!!, arrayListOf(call.argument<String>("productId")!!),
            object : CBCallback.ListProductsCallback<ArrayList<CBProduct>> {
                override fun onSuccess(productIDs: ArrayList<CBProduct>) {
                    // Error: no products found
                    if (productIDs.size == 0) {
                        result.error(
                            "no_products_found",
                            "No products found. Perhaps the product ID you specified doesn't exist.",
                            null,
                        )
                        return
                    }

                    CBPurchase.purchaseProduct(
                        product = productIDs[0],
                        customerID = customerID,
                        object : CBCallback.PurchaseCallback<String> {
                            override fun onSuccess(subscriptionID: String, status: Boolean) {
                                result.success(
                                    hashMapOf(
                                        "subscriptionId" to subscriptionID,
                                        "status" to status,
                                    )
                                )
                            }

                            override fun onError(error: CBException) {
                                sendError(result, error)
                            }
                        }
                    )
                }

                override fun onError(error: CBException) {
                    sendError(result, error)
                }
            }
        )
    }

    /** Helper method to handle errors from the native sdk in one place. */
    private fun sendError(@NonNull result: Result, error: CBException) {
        result.error(
            error.apiErrorCode ?: "unknown",
            error.message ?: "No error message returned by Chargebee.",
            error
        )
    }
}
