import 'PostCategory.dart';

class PostCategoryListResponse {
  PostCategoryListResponse({
      this.code,
      this.message,
      this.messageKh,
      this.data,});

  PostCategoryListResponse.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    messageKh = json['messageKh'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PostCategory.fromJson(v));
      });
    }
  }
  String? code;
  String? message;
  String? messageKh;
  List<PostCategory>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    map['messageKh'] = messageKh;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
