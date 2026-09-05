import 'package:get/get.dart';
import 'package:post_mobile_application/modules/settings/controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController(apiService: Get.find()));
  }
}
