import 'Content.dart';

class PostDetailResponse {
  PostDetailResponse({
      this.code,
      this.message,
      this.messageKh,
      this.data,});

  PostDetailResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    messageKh = json['messageKh'];
    data = json['data'] != null ? Content.fromJson(json['data']) : null;
  }
  String? code;
  String? message;
  String? messageKh;
  Content? data;

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
