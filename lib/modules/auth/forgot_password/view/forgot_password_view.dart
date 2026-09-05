import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/auth/forgot_password/controller/forgot_password_controller.dart';
import 'package:post_mobile_application/widgets/button_custom_widget.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

import '../../../../widgets/header_title_custom_widget.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  IconData _iconForStep(int step) {
    switch (step) {
      case 0:
        return Icons.phone_android_outlined;
      case 1:
        return Icons.sms_outlined;
      default:
        return Icons.lock_reset_rounded;
    }
  }

  String _titleForStep(int step) {
    switch (step) {
      case 0:
        return "Forgot Password";
      case 1:
        return "Verify OTP";
      default:
        return "Reset Password";
    }
  }

  String _subtitleForStep(int step) {
    switch (step) {
      case 0:
        return "Enter your phone number to receive an OTP";
      case 1:
        return "Enter the OTP sent to your phone";
      default:
        return "Enter your new password";
    }
  }

  Widget _buildStepIndicator(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? Colors.cyan : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.cyan),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => controller.onBackPressed(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AutofillGroup(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildStepIndicator(controller.step.value),
                    const SizedBox(height: 24),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _iconForStep(controller.step.value),
                        color: Colors.cyan,
                        size: 44,
                      ),
                    ),
                    const SizedBox(height: 24),
                    HeaderTitleCustomWidget(title: _titleForStep(controller.step.value)),
                    const SizedBox(height: 8),
                    Text(
                      _subtitleForStep(controller.step.value),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    if (controller.step.value == 0) ...[
                      InputFormCustom(
                        controller: controller.phoneNumberController.value,
                        labelText: "Phone Number",
                        hintText: "Phone Number",
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        autofillHints: const [AutofillHints.telephoneNumber],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => controller.onSendOtp(),
                      ),
                      const SizedBox(height: 32),
                      ButtonCustomWidget(
                        onClick: () => controller.onSendOtp(),
                        loading: controller.loading.value,
                        title: "Send OTP",
                      ),
                    ] else if (controller.step.value == 1) ...[
                      InputFormCustom(
                        controller: controller.otpController.value,
                        labelText: "OTP",
                        hintText: "OTP",
                        prefixIcon: Icons.sms_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        maxLength: 6,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => controller.onVerifyOtp(),
                      ),
                      const SizedBox(height: 32),
                      ButtonCustomWidget(
                        onClick: () => controller.onVerifyOtp(),
                        loading: controller.loading.value,
                        title: "Verify OTP",
                      ),
                    ] else ...[
                      InputFormCustom(
                        controller: controller.newPasswordController.value,
                        labelText: "New Password",
                        hintText: "New Password",
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                      InputFormCustom(
                        controller: controller.confirmNewPasswordController.value,
                        labelText: "Confirm New Password",
                        hintText: "Confirm New Password",
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => controller.onResetPassword(),
                      ),
                      const SizedBox(height: 32),
                      ButtonCustomWidget(
                        onClick: () => controller.onResetPassword(),
                        loading: controller.loading.value,
                        title: "Reset Password",
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
