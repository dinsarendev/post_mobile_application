class VerifyForgotPasswordOtpRequest {
  VerifyForgotPasswordOtpRequest({
      this.phoneNumber,
      this.deviceId,
      this.otp,});

  VerifyForgotPasswordOtpRequest.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    deviceId = json['deviceId'];
    otp = json['otp'];
  }
  String? phoneNumber;
  String? deviceId;
  String? otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['deviceId'] = deviceId;
    map['otp'] = otp;
    return map;
  }

}
