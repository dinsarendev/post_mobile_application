class UpdateProfileRequest {
  UpdateProfileRequest({
      this.id,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,});

  UpdateProfileRequest.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['email'] = email;
    map['phoneNumber'] = phoneNumber;
    return map;
  }

}
