import 'package:post_mobile_application/core/models/auth/login/User.dart';

class RegisterResponse {
  RegisterResponse({
      this.code,
      this.message,
      this.messageKh,
      this.data,});

  RegisterResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    messageKh = json['messageKh'];
    data = json['data'] != null ? User.fromJson(json['data']) : null;
  }
  String? code;
  String? message;
  String? messageKh;
  User? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['messageKh'] = messageKh;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}
