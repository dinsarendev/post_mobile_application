import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/auth/login/controller/login_controller.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/widgets/button_custom_widget.dart';
import 'package:post_mobile_application/widgets/input_form_custom.dart';

import '../../../../widgets/header_title_custom_widget.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                    SizedBox(height: 32),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.cyan.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.article_rounded, color: Colors.cyan, size: 44),
                    ),
                    SizedBox(height: 24),
                    HeaderTitleCustomWidget(
                      title: "Welcome Back",
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Sign in to continue",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 40),
                    InputFormCustom(
                      controller: controller.usernameController.value,
                      labelText: "Username",
                      hintText: "Username",
                      prefixIcon: Icons.person_outline,
                      errorText: controller.usernameError.value,
                      onChanged: (_) => controller.clearUsernameError(),
                      autofillHints: const [AutofillHints.username],
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
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => controller.onLogin(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          Get.toNamed(AppRouteName.forgotPassword);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ButtonCustomWidget(
                      onClick: (){
                        controller.onLogin();
                      },
                      loading: controller.loading.value,
                      title: "Login",
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: (){
                        Get.toNamed(AppRouteName.register);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Register",
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
