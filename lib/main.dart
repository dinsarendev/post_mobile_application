import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:post_mobile_application/binding/initail_binding.dart';
import 'package:post_mobile_application/core/error/global_error_handler.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/routes/app_routes.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    GlobalErrorHandler.init();
    await GetStorage.init();
    runApp(const MyApp());
  }, GlobalErrorHandler.reportError);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouteName.splash,
      getPages: AppRoutes.getAllRoutes(),
      title: 'Post Mobile Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
    );
  }
}
