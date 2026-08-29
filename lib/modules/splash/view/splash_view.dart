import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/modules/splash/controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return  Obx((){
      return  Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: controller.loading.value == false
              ? Text("")
              : CircularProgressIndicator(color: Colors.white),
        ),
      );
    });

  }
}
