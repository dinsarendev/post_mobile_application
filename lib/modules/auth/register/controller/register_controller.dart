import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/models/auth/register/RegisterRequest.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';

class RegisterController extends GetxController{
  final ApiService apiService;
  RegisterController({required this.apiService});

  var usernameController = TextEditingController().obs;
  var firstNameController = TextEditingController().obs;
  var lastNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneNumberController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  var loading = false.obs;

  var usernameError = Rx<String?>(null);
  var phoneNumberError = Rx<String?>(null);
  var emailError = Rx<String?>(null);
  var passwordError = Rx<String?>(null);
  var confirmPasswordError = Rx<String?>(null);

  clearUsernameError() => usernameError.value = null;
  clearPhoneNumberError() => phoneNumberError.value = null;
  clearEmailError() => emailError.value = null;
  clearPasswordError() => passwordError.value = null;
  clearConfirmPasswordError() => confirmPasswordError.value = null;

  onRegister() async {
    var username = usernameController.value.text.trim();
    var firstName = firstNameController.value.text.trim();
    var lastName = lastNameController.value.text.trim();
    var email = emailController.value.text.trim();
    var phoneNumber = phoneNumberController.value.text.trim();
    var password = passwordController.value.text.trim();
    var confirmPassword = confirmPasswordController.value.text.trim();

    usernameError.value = username.isEmpty ? "Please enter your username" : null;
    phoneNumberError.value = phoneNumber.isEmpty ? "Please enter your phone number" : null;
    emailError.value = (email.isNotEmpty && !GetUtils.isEmail(email))
        ? "Please enter a valid email"
        : null;
    passwordError.value = password.isEmpty ? "Please enter your password" : null;
    confirmPasswordError.value = confirmPassword.isEmpty
        ? "Please confirm your password"
        : confirmPassword != password
            ? "Password and confirm password do not match"
            : null;

    if ([
      usernameError.value,
      phoneNumberError.value,
      emailError.value,
      passwordError.value,
      confirmPasswordError.value,
    ].any((error) => error != null)) {
      return;
    }

    loading.value = true;
    var response = await apiService.register(
      RegisterRequest(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        confirmPassword: confirmPassword,
        role: "USER",
        profile: "",
      )
    );
    loading.value = false;
    if(response.data != null) {
      AppSnackbar.success("Register Successfully");
      Get.offNamed(AppRouteName.login);
    }else{
      AppSnackbar.error(response.message ?? "Register failed");
    }
  }
}
