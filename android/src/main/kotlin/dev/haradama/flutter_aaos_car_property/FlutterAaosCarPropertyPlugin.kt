package dev.haradama.flutter_aaos_car_property

import android.car.Car
import android.car.hardware.property.CarPropertyManager
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterAaosCarPropertyPlugin: FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private var carPropertyManager: CarPropertyManager? = null
    private lateinit var car: Car
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_aaos_car_property")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "initializeCarManager" -> {
                initializeCarManager()
                result.success("Car Manager Initialized")
            }
            "getCarProperty" -> {
                val propertyId = call.argument<Int>("propertyId")
                val areaId = call.argument<Int>("areaId")
                if (propertyId != null && areaId != null) {
                    val value = getCarProperty(propertyId, areaId)
                    result.success(value)
                } else {
                    result.error("INVALID_ARGUMENTS", "PropertyId and AreaId are required", null)
                }
            }
            "setCarProperty" -> {
                val propertyId = call.argument<Int>("propertyId")
                val areaId = call.argument<Int>("areaId")
                val value = call.argument<Any>("value")
                if (propertyId != null && areaId != null && value != null) {
                    result.success(setCarProperty(propertyId, areaId, value))
                } else {
                    result.error("INVALID_ARGUMENTS", "PropertyId, AreaId, and Value are required", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initializeCarManager() {
        car = Car.createCar(context, null, Car.CAR_WAIT_TIMEOUT_DO_NOT_WAIT) { car, ready ->
            if (ready) {
                carPropertyManager = car.getCarManager(Car.PROPERTY_SERVICE) as CarPropertyManager
            }
        }
    }

    private fun getCarProperty(propertyId: Int, areaId: Int): Any? {
        return try {
            if (carPropertyManager?.isPropertyAvailable(propertyId, areaId) != true) {
                return "Property not available for propertyId: $propertyId, areaId: $areaId"
            }

            val config = carPropertyManager?.getCarPropertyConfig(propertyId)
            config?.let {
                when (it.propertyType) {
                    Boolean::class.javaPrimitiveType, java.lang.Boolean::class.java -> {
                        carPropertyManager?.getBooleanProperty(propertyId, areaId)
                    }
                    Int::class.javaPrimitiveType, Integer::class.java -> {
                        carPropertyManager?.getIntProperty(propertyId, areaId)
                    }
                    Float::class.javaPrimitiveType, java.lang.Float::class.java -> {
                        carPropertyManager?.getFloatProperty(propertyId, areaId)
                    }
                    else -> {
                        "Unsupported property type: ${it.propertyType}"
                    }
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun setCarProperty(propertyId: Int, areaId: Int, value: Any): String {
        return try {
            if (carPropertyManager?.isPropertyAvailable(propertyId, areaId) != true) {
                return "Property not available for propertyId: $propertyId, areaId: $areaId"
            }

            val config = carPropertyManager?.getCarPropertyConfig(propertyId)
            config?.let {
                when (it.propertyType) {
                    Boolean::class.javaPrimitiveType, java.lang.Boolean::class.java -> {
                        if (value is Boolean) {
                            carPropertyManager?.setBooleanProperty(propertyId, areaId, value)
                            "Property set successfully"
                        } else {
                            "Invalid value type. Expected Boolean."
                        }
                    }
                    Int::class.javaPrimitiveType, Integer::class.java -> {
                        if (value is Int) {
                            carPropertyManager?.setIntProperty(propertyId, areaId, value)
                            "Property set successfully"
                        } else {
                            "Invalid value type. Expected Int."
                        }
                    }
                    Float::class.javaPrimitiveType, java.lang.Float::class.java -> {
                        if (value is Float) {
                            carPropertyManager?.setFloatProperty(propertyId, areaId, value)
                            "Property set successfully"
                        } else {
                            "Invalid value type. Expected Float."
                        }
                    }
                    else -> {
                        "Unsupported property type: ${it.propertyType}"
                    }
                }
            } ?: "Property configuration not found"
        } catch (e: Exception) {
            e.printStackTrace()
            "Failed to set property. ${e.message}"
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
