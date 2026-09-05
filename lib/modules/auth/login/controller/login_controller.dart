import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginRequest.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';

class LoginController extends GetxController{
  final ApiService apiService;
  LoginController({required this.apiService});

  var usernameController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var usernameError = Rx<String?>(null);
  var passwordError = Rx<String?>(null);
  var loading = false.obs;

  clearUsernameError() => usernameError.value = null;
  clearPasswordError() => passwordError.value = null;

  onLogin() async {
    var username = usernameController.value.text.trim();
    var password = passwordController.value.text.trim();
    usernameError.value = username.isEmpty ? "Please enter your username" : null;
    passwordError.value = password.isEmpty ? "Please enter your password" : null;
    if (usernameError.value != null || passwordError.value != null) {
      return;
    }
    loading.value = true;
    var response = await apiService.login(
      LoginRequest(
        phoneNumber: username,
        password: password
      )
    );
    loading.value = false;
    if(response.accessToken != null) {
      AccessTokenStorage.setAccessToken(response.accessToken??"");
      AccessTokenStorage.setRefreshToken(response.refreshToken??"");
      if (response.user?.id != null) {
        AccessTokenStorage.setUserId(response.user!.id!);
      }
      AppSnackbar.success("Login Successfully");
      Get.offNamed(AppRouteName.home);
    }else{
      AppSnackbar.error("Your username and password are incorrect");
    }
  }
}
