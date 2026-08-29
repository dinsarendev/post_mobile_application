import 'package:get/get.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';

class SplashController extends GetxController {
  var loading = false.obs;
  _checkToken() async {
    loading.value = true;
    await Future.delayed(Duration(seconds: 3));
    loading.value = false;
    if (AccessTokenStorage.getAccessToken() != "") {
      Get.offNamed(AppRouteName.home);
    } else {
      Get.offNamed(AppRouteName.login);
    }
  }
  @override
  void onInit() {
   _checkToken();
    super.onInit();
  }
}
