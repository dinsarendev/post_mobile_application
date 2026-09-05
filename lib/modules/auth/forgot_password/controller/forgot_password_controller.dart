import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/data/local/device_id_storage.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ForgotPasswordRequest.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ResetPasswordRequest.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/VerifyForgotPasswordOtpRequest.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final ApiService apiService;
  ForgotPasswordController({required this.apiService});

  var step = 0.obs;
  var loading = false.obs;

  var phoneNumberController = TextEditingController().obs;
  var otpController = TextEditingController().obs;
  var newPasswordController = TextEditingController().obs;
  var confirmNewPasswordController = TextEditingController().obs;

  onBackPressed() {
    if (step.value > 0) {
      step.value -= 1;
    } else {
      Get.back();
    }
  }

  onSendOtp() async {
    var phoneNumber = phoneNumberController.value.text.trim();
    if (phoneNumber.isEmpty) {
      AppSnackbar.error("Please enter your phone number");
      return;
    }
    loading.value = true;
    var response = await apiService.forgotPassword(
      ForgotPasswordRequest(
        phoneNumber: phoneNumber,
        deviceId: DeviceIdStorage.getDeviceId(),
      ),
    );
    loading.value = false;
    if (response.success!) {
      AppSnackbar.success(response.message ?? "OTP sent successfully");
      step.value = 1;
    } else {
      AppSnackbar.error(response.message ?? "Unable to send OTP");
    }
  }

  onVerifyOtp() async {
    var phoneNumber = phoneNumberController.value.text.trim();
    var otp = otpController.value.text.trim();
    if (otp.isEmpty) {
      AppSnackbar.error("Please enter the OTP");
      return;
    }
    loading.value = true;
    var response = await apiService.verifyForgotPasswordOtp(
      VerifyForgotPasswordOtpRequest(
        phoneNumber: phoneNumber,
        deviceId: DeviceIdStorage.getDeviceId(),
        otp: otp,
      ),
    );
    loading.value = false;
    if (response.success!) {
      step.value = 2;
    } else {
      AppSnackbar.error(response.message ?? "Invalid OTP");
    }
  }

  onResetPassword() async {
    var phoneNumber = phoneNumberController.value.text.trim();
    var otp = otpController.value.text.trim();
    var newPassword = newPasswordController.value.text.trim();
    var confirmNewPassword = confirmNewPasswordController.value.text.trim();
    if (newPassword.isEmpty) {
      AppSnackbar.error("Please enter your new password");
      return;
    }
    if (newPassword != confirmNewPassword) {
      AppSnackbar.error("Password and confirm password do not match");
      return;
    }
    loading.value = true;
    var response = await apiService.resetPassword(
      ResetPasswordRequest(
        phoneNumber: phoneNumber,
        otp: otp,
        oldPassword: "",
        password: newPassword,
        confirmPassword: confirmNewPassword,
      ),
    );
    loading.value = false;
    if (response.success!) {
      AppSnackbar.success("Password reset successfully");
      Get.offNamed(AppRouteName.login);
    } else {
      AppSnackbar.error(response.message ?? "Unable to reset password");
    }
  }
}
