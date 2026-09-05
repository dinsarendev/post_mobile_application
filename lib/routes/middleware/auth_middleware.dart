import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';

/// Guards routes that require the user to be logged in, redirecting to
/// the login screen whenever no access token is stored.
class AuthMiddleware extends GetMiddleware {
  AuthMiddleware() : super(priority: 1);

  @override
  RouteSettings? redirect(String? route) {
    var isLoggedIn = AccessTokenStorage.getAccessToken().isNotEmpty;
    return isLoggedIn ? null : const RouteSettings(name: AppRouteName.login);
  }
}
