import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:post_mobile_application/constants/api_constant.dart';
import 'package:post_mobile_application/constants/url_constant.dart';
import 'package:post_mobile_application/core/api/api_service.dart';
import 'package:post_mobile_application/core/error/global_error_handler.dart';
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

  /// Runs [request] with a connection timeout and translates connection
  /// failures / server errors (5xx) into a user-facing message.
  ///
  /// Returns `null` when the request timed out, could not reach the server,
  /// or the server responded with an error (status >= 500), so callers can
  /// fall back to their existing "no response" handling.
  Future<httpClient.Response?> _sendRequest(
    Future<httpClient.Response> Function() request,
  ) async {
    try {
      var response = await request().timeout(ApiConstants.connectionTimeout);
      if (response.statusCode >= 500) {
        Get.snackbar(
          "Server Error",
          "The server encountered an error. Please try again later.",
        );
        return null;
      }
      return response;
    } on TimeoutException {
      Get.snackbar(
        "Connection Timeout",
        "The request took too long to respond. Please check your connection and try again.",
      );
      return null;
    } on SocketException {
      Get.snackbar(
        "No Internet Connection",
        "Please check your internet connection and try again.",
      );
      return null;
    } on httpClient.ClientException {
      Get.snackbar(
        "Connection Error",
        "Unable to reach the server. Please try again.",
      );
      return null;
    } catch (e, stack) {
      GlobalErrorHandler.reportError(e, stack);
      return null;
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest req) async {
    LoginResponse loginResponse = LoginResponse();
    var url = Uri.parse(UrlConstants.loginPath);
    var response = await _sendRequest(
      () => httpClient.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: headers,
      ),
    );
    if (response != null && response.statusCode == 200) {
      loginResponse = LoginResponse.fromJson(jsonDecode(response.body));
    }
    return loginResponse;
  }

  @override
  Future<RegisterResponse> register(RegisterRequest req) async {
    RegisterResponse registerResponse = RegisterResponse();
    var url = Uri.parse(UrlConstants.registerPath);
    var response = await _sendRequest(
      () => httpClient.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: headers,
      ),
    );
    if (response != null && response.statusCode == 200) {
      registerResponse = RegisterResponse.fromJson(jsonDecode(response.body));
    }
    return registerResponse;
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest req) async {
    var url = Uri.parse(UrlConstants.forgotPasswordPath);
    var response = await _sendRequest(
      () => httpClient.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: headers,
      ),
    );
    if (response == null) {
      return ForgotPasswordResponse(success: false);
    }
    var result = ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    result.success = response.statusCode == 200;
    return result;
  }

  @override
  Future<ForgotPasswordResponse> verifyForgotPasswordOtp(
    VerifyForgotPasswordOtpRequest req,
  ) async {
    var url = Uri.parse(UrlConstants.forgotPasswordVerifyPath);
    var response = await _sendRequest(
      () => httpClient.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: headers,
      ),
    );
    if (response == null) {
      return ForgotPasswordResponse(success: false);
    }
    var result = ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    result.success = response.statusCode == 200;
    return result;
  }

  @override
  Future<ForgotPasswordResponse> resetPassword(ResetPasswordRequest req) async {
    var url = Uri.parse(UrlConstants.forgotPasswordFinishPath);
    var response = await _sendRequest(
      () => httpClient.post(
        url,
        body: jsonEncode(req.toJson()),
        headers: headers,
      ),
    );
    if (response == null) {
      return ForgotPasswordResponse(success: false);
    }
    var result = ForgotPasswordResponse.fromJson(jsonDecode(response.body));
    result.success = response.statusCode == 200;
    return result;
  }

  @override
  Future<bool> refreshToken() async {
    LoginResponse loginResponse = LoginResponse();
    var url = Uri.parse(UrlConstants.refreshTokenPath);
    var response = await _sendRequest(
      () => httpClient.post(
        url,
        body: jsonEncode(
          RefreshTokenRequest(
            refreshToken: "${AccessTokenStorage.getRefreshToken()}",
          ).toJson(),
        ),
        headers: headers,
      ),
    );
    if (response != null && response.statusCode == 200) {
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
    var response = await _sendRequest(
      () => httpClient.get(Uri.parse(url), headers: headers),
    );
    if (response == null) {
      return null;
    }
    if (response.statusCode == 200) {
      return response.body;
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        // Retry
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await _sendRequest(
          () => httpClient.get(Uri.parse(url), headers: headers),
        );
        if (retryResponse != null && retryResponse.statusCode == 200) {
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
    var response = await _sendRequest(
      () => httpClient.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      ),
    );
    if (response == null) {
      return null;
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await _sendRequest(
          () => httpClient.post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          ),
        );
        if (retryResponse != null &&
            (retryResponse.statusCode == 200 || retryResponse.statusCode == 201)) {
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
    var response = await _sendRequest(
      () => httpClient.put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers,
      ),
    );
    if (response == null) {
      return null;
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await _sendRequest(
          () => httpClient.put(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          ),
        );
        if (retryResponse != null && retryResponse.statusCode == 200) {
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
    var response = await _sendRequest(
      () => httpClient.delete(Uri.parse(url), headers: headers),
    );
    if (response == null) {
      return false;
    }
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        headers["Authorization"] =
            "Bearer ${AccessTokenStorage.getAccessToken()}";
        var retryResponse = await _sendRequest(
          () => httpClient.delete(Uri.parse(url), headers: headers),
        );
        return retryResponse != null &&
            (retryResponse.statusCode == 200 || retryResponse.statusCode == 204);
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return false;
  }

  @override
  Future<String?> uploadImage({required List<int> bytes, required String filename}) async {
    var url = Uri.parse(UrlConstants.imageUploadPath);
    var response = await _sendRequest(() async {
      var request = httpClient.MultipartRequest('POST', url);
      request.headers["Authorization"] =
          "Bearer ${AccessTokenStorage.getAccessToken()}";
      request.files.add(httpClient.MultipartFile.fromBytes('File', bytes, filename: filename));
      var streamedResponse = await request.send();
      return httpClient.Response.fromStream(streamedResponse);
    });
    if (response == null) {
      return null;
    }
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    if (response.statusCode == 401) {
      if (await refreshToken() == true) {
        var retryResponse = await _sendRequest(() async {
          var retryRequest = httpClient.MultipartRequest('POST', url);
          retryRequest.headers["Authorization"] =
              "Bearer ${AccessTokenStorage.getAccessToken()}";
          retryRequest.files.add(httpClient.MultipartFile.fromBytes('File', bytes, filename: filename));
          var retryStreamed = await retryRequest.send();
          return httpClient.Response.fromStream(retryStreamed);
        });
        if (retryResponse != null && retryResponse.statusCode == 200) {
          return jsonDecode(retryResponse.body)['data'];
        }
      } else {
        Get.offNamed(AppRouteName.splash);
      }
    }
    return null;
  }
}
