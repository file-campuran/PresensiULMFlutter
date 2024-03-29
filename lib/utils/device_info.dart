import 'package:device_info/device_info.dart';

enum BuildMode { DEBUG, PROFILE, RELEASE }

class DeviceInfo {
  ///Singleton factory
  static final DeviceInfo _instance = DeviceInfo._internal();

  factory DeviceInfo() {
    return _instance;
  }

  DeviceInfo._internal();

  static BuildMode currentBuildMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return BuildMode.RELEASE;
    }
    var result = BuildMode.PROFILE;

    //Little trick, since assert only runs on DEBUG mode
    assert(() {
      result = BuildMode.DEBUG;
      return true;
    }());
    return result;
  }

  static Future<AndroidDeviceInfo> androidDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.androidInfo;
  }

  static Future<IosDeviceInfo> iosDeviceInfo() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    return plugin.iosInfo;
  }
}
