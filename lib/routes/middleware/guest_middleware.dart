import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';

/// Guards routes meant only for logged-out users (login, register,
/// forgot password), redirecting an already-authenticated user to home.
class GuestMiddleware extends GetMiddleware {
  GuestMiddleware() : super(priority: 1);

  @override
  RouteSettings? redirect(String? route) {
    var isLoggedIn = AccessTokenStorage.getAccessToken().isNotEmpty;
    return isLoggedIn ? const RouteSettings(name: AppRouteName.home) : null;
  }
}
