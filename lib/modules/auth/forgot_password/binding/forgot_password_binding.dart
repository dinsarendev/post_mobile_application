import 'package:get/get.dart';
import 'package:post_mobile_application/modules/auth/forgot_password/controller/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPasswordController(apiService: Get.find()));
  }

}
