import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_aaos_car_property_platform_interface.dart';

/// An implementation of [FlutterAaosCarPropertyPlatform] that uses method channels.
class MethodChannelFlutterAaosCarProperty
    extends FlutterAaosCarPropertyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_aaos_car_property');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> initializeCarManager() async {
    final result =
        await methodChannel.invokeMethod<String>('initializeCarManager');
    return result;
  }

  @override
  Future<dynamic> getCarProperty(int propertyId, int areaId) async {
    final result = await methodChannel.invokeMethod<dynamic>(
      'getCarProperty',
      <String, dynamic>{
        'propertyId': propertyId,
        'areaId': areaId,
      },
    );
    return result;
  }

  @override
  Future<String?> setCarProperty(
      int propertyId, int areaId, dynamic value) async {
    final result = await methodChannel.invokeMethod<String>(
      'setCarProperty',
      <String, dynamic>{
        'propertyId': propertyId,
        'areaId': areaId,
        'value': value,
      },
    );
    return result;
  }
}
