class ChangePasswordRequest {
  ChangePasswordRequest({
      this.oldPassword,
      this.password,
      this.confirmPassword,});

  ChangePasswordRequest.fromJson(dynamic json) {
    oldPassword = json['oldPassword'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }
  String? oldPassword;
  String? password;
  String? confirmPassword;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['oldPassword'] = oldPassword;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    return map;
  }

}
