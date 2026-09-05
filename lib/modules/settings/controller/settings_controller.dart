import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/core/data/local/settings_storage.dart';
import 'package:post_mobile_application/core/models/auth/login/User.dart';
import 'package:post_mobile_application/core/models/user/ChangePasswordRequest.dart';
import 'package:post_mobile_application/core/models/user/UpdateProfileRequest.dart';
import 'package:post_mobile_application/widgets/app_snackbar.dart';

class SettingsController extends GetxController {
  final ApiService apiService;
  SettingsController({required this.apiService});

  int? _userId;

  var profileLoading = false.obs;
  var profileSaving = false.obs;
  var passwordSaving = false.obs;
  var isDarkMode = false.obs;

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    isDarkMode.value = SettingsStorage.getDarkMode();
    loadProfile();
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> loadProfile() async {
    var userId = AccessTokenStorage.getUserId();
    if (userId == null) return;
    _userId = userId;
    profileLoading.value = true;
    var response = await apiService.post(UrlConstants.userByIdPath(userId), {});
    profileLoading.value = false;
    if (response != null && response['data'] != null) {
      var user = User.fromJson(response['data']);
      usernameController.text = user.username ?? "";
      firstNameController.text = user.firstName ?? "";
      lastNameController.text = user.lastName ?? "";
      emailController.text = user.email ?? "";
      phoneNumberController.text = user.phoneNumber ?? "";
    }
  }

  Future<void> updateProfile() async {
    if (_userId == null) return;
    if (usernameController.text.trim().isEmpty) {
      AppSnackbar.error("Please enter your username");
      return;
    }
    profileSaving.value = true;
    var result = await apiService.post(
      UrlConstants.updateProfilePath,
      UpdateProfileRequest(
        id: _userId,
        username: usernameController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim(),
      ).toJson(),
    );
    profileSaving.value = false;
    if (result != null) {
      AppSnackbar.success("Profile updated successfully");
    } else {
      AppSnackbar.error("Failed to update profile");
    }
  }

  Future<void> changePassword() async {
    var oldPassword = oldPasswordController.text.trim();
    var newPassword = newPasswordController.text.trim();
    var confirmPassword = confirmPasswordController.text.trim();
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      AppSnackbar.error("Please fill in all password fields");
      return;
    }
    if (newPassword != confirmPassword) {
      AppSnackbar.error("New password and confirm password do not match");
      return;
    }
    passwordSaving.value = true;
    var result = await apiService.post(
      UrlConstants.changePasswordPath,
      ChangePasswordRequest(
        oldPassword: oldPassword,
        password: newPassword,
        confirmPassword: confirmPassword,
      ).toJson(),
    );
    passwordSaving.value = false;
    if (result != null) {
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
      AppSnackbar.success("Password changed successfully");
    } else {
      AppSnackbar.error("Failed to change password");
    }
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    SettingsStorage.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }
}
