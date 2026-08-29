import 'dart:convert';

import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginRequest.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginResponse.dart';
import 'package:http/http.dart' as httpClient;
import 'package:post_mobile_application/core/models/auth/login/RefreshTokenRequest.dart';
import 'package:post_mobile_application/routes/app_route_name.dart';
import 'package:post_mobile_application/routes/app_routes.dart';

class ApiServiceImpl implements ApiService {
  Map<String, String> headers = {"Content-Type": "application/json"};
  @override
  Future<LoginResponse> login(LoginRequest req) async {
    LoginResponse loginResponse = LoginResponse();
    // header
    // var uri
    var url = Uri.parse(UrlConstants.loginPath);
    // http request
    var response = await httpClient.post(
      url,
      body: jsonEncode(req.toJson()),
      headers: headers,
    );
    // check header response status
    if (response.statusCode == 200) {
      loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
    }
    return loginResponse;
  }

  @override
  Future<bool> refreshToken() async {
    LoginResponse loginResponse = LoginResponse();
    // header
    // var uri
    var url = Uri.parse(UrlConstants.refreshTokenPath);
    // http request
    var response = await httpClient.post(
      url,
      body: jsonEncode(
        RefreshTokenRequest(
          refreshToken: "${AccessTokenStorage.getRefreshToken()}",
        ).toJson(),
      ),
      headers: headers,
    );
    // check header response status
    if (response.statusCode == 200) {
      loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
      AccessTokenStorage.setAccessToken(loginResponse.accessToken ?? "");
      AccessTokenStorage.setRefreshToken(loginResponse.refreshToken ?? "");
      return true;
    }
    return false;
  }

  @override
  Future get(String url) async {
    dynamic responseBody;
    headers["Authorization"] = "Bearer ${AccessTokenStorage.getAccessToken()}";
    var response = await httpClient.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      responseBody = response.body;
    } else if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        // Retry
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await httpClient.get(
          Uri.parse(url),
          headers: headers,
        );
        if (retryResponse.statusCode == 200) {
          responseBody = retryResponse.body;
        }
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    } else {
      return responseBody;
    }
  }
}
