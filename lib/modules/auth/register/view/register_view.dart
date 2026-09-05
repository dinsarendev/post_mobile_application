import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/auth/register/controller/register_controller.dart';
import 'package:post_mobile_application/widgets/button_custom_widget.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

import '../../../../widgets/header_title_custom_widget.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 35, horizontal: 24),
              child: AutofillGroup(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_add_alt_1_rounded, color: Colors.cyan, size: 44),
                    ),
                    SizedBox(height: 24),
                    HeaderTitleCustomWidget(
                      title: "Create Account",
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Sign up to get started",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 32),
                    InputFormCustom(
                      controller: controller.usernameController.value,
                      labelText: "Username",
                      hintText: "Username",
                      prefixIcon: Icons.person_outline,
                      errorText: controller.usernameError.value,
                      onChanged: (_) => controller.clearUsernameError(),
                      autofillHints: const [AutofillHints.newUsername],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    InputFormCustom(
                      controller: controller.firstNameController.value,
                      labelText: "First Name",
                      hintText: "First Name",
                      prefixIcon: Icons.badge_outlined,
                      autofillHints: const [AutofillHints.givenName],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    InputFormCustom(
                      controller: controller.lastNameController.value,
                      labelText: "Last Name",
                      hintText: "Last Name",
                      prefixIcon: Icons.badge_outlined,
                      autofillHints: const [AutofillHints.familyName],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    InputFormCustom(
                      controller: controller.emailController.value,
                      labelText: "Email",
                      hintText: "Email",
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      errorText: controller.emailError.value,
                      onChanged: (_) => controller.clearEmailError(),
                      autofillHints: const [AutofillHints.email],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    InputFormCustom(
                      controller: controller.phoneNumberController.value,
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      errorText: controller.phoneNumberError.value,
                      onChanged: (_) => controller.clearPhoneNumberError(),
                      autofillHints: const [AutofillHints.telephoneNumber],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    InputFormCustom(
                      controller: controller.passwordController.value,
                      labelText: "Password",
                      hintText: "Password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      errorText: controller.passwordError.value,
                      onChanged: (_) => controller.clearPasswordError(),
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    ),
                    InputFormCustom(
                      controller: controller.confirmPasswordController.value,
                      labelText: "Confirm Password",
                      hintText: "Confirm Password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      errorText: controller.confirmPasswordError.value,
                      onChanged: (_) => controller.clearConfirmPasswordError(),
                      autofillHints: const [AutofillHints.newPassword],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.onRegister(),
                    ),
                    SizedBox(height: 32),
                    ButtonCustomWidget(
                      onClick: (){
                        controller.onRegister();
                      },
                      loading: controller.loading.value,
                      title: "Register",
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
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
