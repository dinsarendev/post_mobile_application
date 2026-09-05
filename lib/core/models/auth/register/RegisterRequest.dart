class RegisterRequest {
  RegisterRequest({
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.password,
      this.confirmPassword,
      this.role,
      this.profile,});

  RegisterRequest.fromJson(dynamic json) {
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    role = json['role'];
    profile = json['profile'];
  }
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? confirmPassword;
  String? role;
  String? profile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    map['password'] = password;
    map['confirmPassword'] = confirmPassword;
    map['role'] = role;
    map['profile'] = profile;
    return map;
  }

}
