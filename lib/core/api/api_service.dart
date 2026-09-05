import 'package:post_mobile_application/core/models/auth/forgot_password/ForgotPasswordRequest.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ForgotPasswordResponse.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/ResetPasswordRequest.dart';
import 'package:post_mobile_application/core/models/auth/forgot_password/VerifyForgotPasswordOtpRequest.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginRequest.dart';
import 'package:post_mobile_application/core/models/auth/login/LoginResponse.dart';
import 'package:post_mobile_application/core/models/auth/register/RegisterRequest.dart';
import 'package:post_mobile_application/core/models/auth/register/RegisterResponse.dart';

abstract class ApiService {
  Future<LoginResponse> login(LoginRequest req);
  Future<RegisterResponse> register(RegisterRequest req);
  Future<ForgotPasswordResponse> forgotPassword(ForgotPasswordRequest req);
  Future<ForgotPasswordResponse> verifyForgotPasswordOtp(VerifyForgotPasswordOtpRequest req);
  Future<ForgotPasswordResponse> resetPassword(ResetPasswordRequest req);
  Future<bool> refreshToken();
  Future<dynamic> get(String url);
  Future<dynamic> post(String url, Map<String, dynamic> body);
  Future<dynamic> put(String url, Map<String, dynamic> body);
  Future<bool> delete(String url);
  Future<String?> uploadImage({required List<int> bytes, required String filename});
}