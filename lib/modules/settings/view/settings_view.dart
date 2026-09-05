import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/settings/controller/settings_controller.dart';
import 'package:post_mobile_application/widgets/appbar_custom_widget.dart';
import 'package:post_mobile_application/widgets/button_custom_widget.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppbarCustomWidget(title: "Settings"),
        body: SafeArea(
          child: controller.profileLoading.value
              ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Profile"),
                        InputFormCustom(
                          controller: controller.usernameController,
                          labelText: "Username",
                          hintText: "Username",
                          prefixIcon: Icons.person_outline,
                        ),
                        InputFormCustom(
                          controller: controller.firstNameController,
                          labelText: "First Name",
                          hintText: "First name",
                        ),
                        InputFormCustom(
                          controller: controller.lastNameController,
                          labelText: "Last Name",
                          hintText: "Last name",
                        ),
                        InputFormCustom(
                          controller: controller.emailController,
                          labelText: "Email",
                          hintText: "Email address",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                        ),
                        InputFormCustom(
                          controller: controller.phoneNumberController,
                          labelText: "Phone Number",
                          hintText: "Phone number",
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 8),
                        ButtonCustomWidget(
                          onClick: controller.profileSaving.value ? null : controller.updateProfile,
                          loading: controller.profileSaving.value,
                          title: "Save Profile",
                        ),
                        const SizedBox(height: 32),
                        _sectionTitle("Change Password"),
                        InputFormCustom(
                          controller: controller.oldPasswordController,
                          labelText: "Current Password",
                          hintText: "Current password",
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        InputFormCustom(
                          controller: controller.newPasswordController,
                          labelText: "New Password",
                          hintText: "New password",
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        InputFormCustom(
                          controller: controller.confirmPasswordController,
                          labelText: "Confirm New Password",
                          hintText: "Confirm new password",
                          isPassword: true,
                          prefixIcon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 8),
                        ButtonCustomWidget(
                          onClick: controller.passwordSaving.value ? null : controller.changePassword,
                          loading: controller.passwordSaving.value,
                          title: "Change Password",
                        ),
                        const SizedBox(height: 32),
                        _sectionTitle("Preferences"),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SwitchListTile(
                            value: controller.isDarkMode.value,
                            onChanged: controller.toggleDarkMode,
                            activeThumbColor: Colors.cyan,
                            title: const Text("Dark Mode"),
                            secondary: const Icon(Icons.dark_mode_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
