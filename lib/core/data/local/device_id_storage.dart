import 'dart:math';

import 'package:get_storage/get_storage.dart';

class DeviceIdStorage {
  static final _storage = GetStorage();
  static const String _deviceId = "DEVICE_ID";

  static String getDeviceId() {
    var id = _storage.read(_deviceId);
    if (id == null || id == "") {
      id = _generateDeviceId();
      _storage.write(_deviceId, id);
    }
    return id;
  }

  static String _generateDeviceId() {
    var random = Random();
    var value = List.generate(
      16,
      (_) => random.nextInt(16).toRadixString(16),
    ).join();
    return "device-$value";
  }
}
