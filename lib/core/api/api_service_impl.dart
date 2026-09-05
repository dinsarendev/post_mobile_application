import 'dart:convert';

import 'package:get/get.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/data/local/access_token_storage.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginRequest.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginResponse.dart';
import 'package:http/http.dart' as httpClient;
import 'package:post_mobile_application/core/models/auth/login/RefreshTokenRequest.dart';
import 'package:post_mobile_application/core/models/auth/register/RegisterRequest.dart';
import 'package:post_mobile_application/core/models/auth/register/RegisterResponse.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ForgotPasswordRequest.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ForgotPasswordResponse.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ResetPasswordRequest.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/VerifyForgotPasswordOtpRequest.dart';
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
  Future<RegisterResponse> register(RegisterRequest req) async {
    RegisterResponse registerResponse = RegisterResponse();
    var url = Uri.parse(UrlConstants.registerPath);
    var response = await httpClient.post(
      url,
      body: jsonEncode(req.toJson()),
      headers: headers,
    );
    if (response.statusCode == 200) {
      registerResponse = RegisterResponse.fromJson(jsonDecode(response.body));
    }
    return registerResponse;
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest req) async {
    var url = Uri.parse(UrlConstants.forgotPasswordPath);
    var response = await httpClient.post(
      url,
      body: jsonEncode(req.toJson()),
      headers: headers,
    );
    var result = ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    result.success = response.statusCode == 200;
    return result;
  }

  @override
  Future<ForgotPasswordResponse> verifyForgotPasswordOtp(
    VerifyForgotPasswordOtpRequest req,
  ) async {
    var url = Uri.parse(UrlConstants.forgotPasswordVerifyPath);
    var response = await httpClient.post(
      url,
      body: jsonEncode(req.toJson()),
      headers: headers,
    );
    var result = ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    result.success = response.statusCode == 200;
    return result;
  }

  @override
  Future<ForgotPasswordResponse> resetPassword(ResetPasswordRequest req) async {
    var url = Uri.parse(UrlConstants.forgotPasswordFinishPath);
    var response = await httpClient.post(
      url,
      body: jsonEncode(req.toJson()),
      headers: headers,
    );
    var result = ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    result.success = response.statusCode == 200;
    return result;
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
    headers["Authorization"] = "Bearer ${AccessTokenStorage.getAccessToken()}";
    var response = await httpClient.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        // Retry
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await httpClient.get(
          Uri.parse(url),
          headers: headers,
        );
        if (retryResponse.statusCode == 200) {
          return retryResponse.body;
        }
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return null;
  }

  @override
  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    headers["Authorization"] = "Bearer ${AccessTokenStorage.getAccessToken()}";
    var response = await httpClient.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await httpClient.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
          return jsonDecode(retryResponse.body);
        }
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return null;
  }

  @override
  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    headers["Authorization"] = "Bearer ${AccessTokenStorage.getAccessToken()}";
    var response = await httpClient.put(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await httpClient.put(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (retryResponse.statusCode == 200) {
          return jsonDecode(retryResponse.body);
        }
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return null;
  }

  @override
  Future<bool> delete(String url) async {
    headers["Authorization"] = "Bearer ${AccessTokenStorage.getAccessToken()}";
    var response = await httpClient.delete(Uri.parse(url), headers: headers);
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await httpClient.delete(
          Uri.parse(url),
          headers: headers,
        );
        return retryResponse.statusCode == 200 || retryResponse.statusCode == 204;
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return false;
  }

  @override
  Future<String?> uploadImage({required List<int> bytes, required String filename}) async {
    var url = Uri.parse(UrlConstants.imageUploadPath);
    var request = httpClient.MultipartRequest('POST', url);
    request.headers["Authorization"] = "Bearer ${AccessTokenStorage.getAccessToken()}";
    request.files.add(httpClient.MultipartFile.fromBytes('File', bytes, filename: filename));
    var streamedResponse = await request.send();
    var response = await httpClient.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        var retryRequest = httpClient.MultipartRequest('POST', url);
        retryRequest.headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        retryRequest.files.add(httpClient.MultipartFile.fromBytes('File', bytes, filename: filename));
        var retryStreamed = await retryRequest.send();
        var retryResponse = await httpClient.Response.fromStream(retryStreamed);
        if (retryResponse.statusCode == 200) {
          return jsonDecode(retryResponse.body)['data'];
        }
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return null;
  }
}
