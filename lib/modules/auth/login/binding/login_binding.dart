import 'package:get/get.dart';
import 'package:post_mobile_application/modules/auth/login/controller/login_controller.dart';

class LoginBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=> LoginController());
  }

}