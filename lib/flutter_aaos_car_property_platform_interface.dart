import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_aaos_car_property_method_channel.dart';

abstract class FlutterAaosCarPropertyPlatform extends PlatformInterface {
  /// Constructs a FlutterAaosCarPropertyPlatform.
  FlutterAaosCarPropertyPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAaosCarPropertyPlatform _instance =
      MethodChannelFlutterAaosCarProperty();

  /// The default instance of [FlutterAaosCarPropertyPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAaosCarProperty].
  static FlutterAaosCarPropertyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAaosCarPropertyPlatform] when
  /// they register themselves.
  static set instance(FlutterAaosCarPropertyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Get platform version
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Initialize CarPropertyManager
  Future<String?> initializeCarManager() {
    throw UnimplementedError(
        'initializeCarManager() has not been implemented.');
  }

  /// Get car property with propertyId and areaId
  Future<dynamic> getCarProperty(int propertyId, int areaId) {
    throw UnimplementedError('getCarProperty() has not been implemented.');
  }

  /// Set car property with propertyId, areaId, and value
  Future<String?> setCarProperty(int propertyId, int areaId, dynamic value) {
    throw UnimplementedError('setCarProperty() has not been implemented.');
  }
}
