class ForgotPasswordRequest {
  ForgotPasswordRequest({
      this.phoneNumber,
      this.deviceId,});

  ForgotPasswordRequest.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    deviceId = json['deviceId'];
  }
  String? phoneNumber;
  String? deviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['deviceId'] = deviceId;
    return map;
  }

}
