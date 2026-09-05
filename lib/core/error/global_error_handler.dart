import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Last line of defense for exceptions that no local try/catch handled:
/// Flutter framework errors (build/layout/paint) and uncaught async errors
/// (an unawaited Future rejecting, a Timer callback throwing, etc.).
///
/// [init] must run inside the same [runZonedGuarded] zone that later calls
/// `runApp`, so it is called from `main()` before `runApp`.
class GlobalErrorHandler {
  GlobalErrorHandler._();

  static void init() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _handle(details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      _handle(error, stack);
      return true;
    };
  }

  /// Entry point for [runZonedGuarded]'s error callback.
  static void reportError(Object error, StackTrace stack) => _handle(error, stack);

  static void _handle(Object error, StackTrace? stack) {
    debugPrint("Unhandled error: $error\n$stack");
    _showMessage(_friendlyMessage(error));
  }

  static void _showMessage(String message) {
    try {
      if (Get.context == null) return;
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      Get.snackbar("Error", message);
    } catch (_) {
      // Overlay not ready yet (e.g. error happened before the first frame).
    }
  }

  static String _friendlyMessage(Object error) {
    if (error is SocketException) {
      return "Please check your internet connection and try again.";
    }
    if (error is TimeoutException) {
      return "The request took too long to respond. Please try again.";
    }
    if (error is FormatException) {
      return "We received an unexpected response from the server.";
    }
    return "Something went wrong. Please try again.";
  }
}
