import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centralized, color-coded snackbars so success/error/warning feedback
/// looks consistent everywhere in the app.
class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String title = "Success"}) {
    _show(title, message, color: Colors.green, icon: Icons.check_circle);
  }

  static void error(String message, {String title = "Error"}) {
    _show(title, message, color: Colors.redAccent, icon: Icons.error);
  }

  static void warning(String message, {String title = "Warning"}) {
    _show(title, message, color: Colors.orange, icon: Icons.warning_amber_rounded);
  }

  static void _show(
    String title,
    String message, {
    required Color color,
    required IconData icon,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      icon: Icon(icon, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }
}
