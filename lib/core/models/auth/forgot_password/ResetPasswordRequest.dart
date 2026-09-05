class ResetPasswordRequest {
  ResetPasswordRequest({
      this.phoneNumber,
      this.otp,
      this.oldPassword,
      this.password,
      this.confirmPassword,});

  ResetPasswordRequest.fromJson(dynamic json) {
    phoneNumber = json['phoneNumber'];
    otp = json['otp'];
    oldPassword = json['oldPassword'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }
  String? phoneNumber;
  String? otp;
  String? oldPassword;
  String? password;
  String? confirmPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phoneNumber'] = phoneNumber;
    map['otp'] = otp;
    map['oldPassword'] = oldPassword;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    return map;
  }

}
