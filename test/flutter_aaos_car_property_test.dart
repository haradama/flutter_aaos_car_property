import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aaos_car_property/flutter_aaos_car_property.dart';
import 'package:flutter_aaos_car_property/flutter_aaos_car_property_platform_interface.dart';
import 'package:flutter_aaos_car_property/flutter_aaos_car_property_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAaosCarPropertyPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAaosCarPropertyPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAaosCarPropertyPlatform initialPlatform = FlutterAaosCarPropertyPlatform.instance;

  test('$MethodChannelFlutterAaosCarProperty is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAaosCarProperty>());
  });

  test('getPlatformVersion', () async {
    FlutterAaosCarProperty flutterAaosCarPropertyPlugin = FlutterAaosCarProperty();
    MockFlutterAaosCarPropertyPlatform fakePlatform = MockFlutterAaosCarPropertyPlatform();
    FlutterAaosCarPropertyPlatform.instance = fakePlatform;

    expect(await flutterAaosCarPropertyPlugin.getPlatformVersion(), '42');
  });
}
