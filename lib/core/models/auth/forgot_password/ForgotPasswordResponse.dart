class ForgotPasswordResponse {
  ForgotPasswordResponse({
      this.code,
      this.message,
      this.messageKh,
      this.success = false,});

  ForgotPasswordResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    messageKh = json['messageKh'];
  }
  String? code;
  String? message;
  String? messageKh;
  bool? success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['messageKh'] = messageKh;
    return map;
  }

}
