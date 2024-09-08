import 'flutter_aaos_car_property_platform_interface.dart';

class FlutterAaosCarProperty {
  Future<String?> getPlatformVersion() {
    return FlutterAaosCarPropertyPlatform.instance.getPlatformVersion();
  }

  Future<String?> initializeCarManager() {
    return FlutterAaosCarPropertyPlatform.instance.initializeCarManager();
  }

  Future<dynamic> getCarProperty(int propertyId, int areaId) {
    return FlutterAaosCarPropertyPlatform.instance
        .getCarProperty(propertyId, areaId);
  }

  Future<String?> setCarProperty(int propertyId, int areaId, dynamic value) {
    return FlutterAaosCarPropertyPlatform.instance
        .setCarProperty(propertyId, areaId, value);
  }
}
