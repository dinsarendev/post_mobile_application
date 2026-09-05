class PostCategoryRequest {
  PostCategoryRequest({
      this.name,
      this.imageUrl,
      this.status,});

  PostCategoryRequest.fromJson(dynamic json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
    status = json['status'];
  }
  String? name;
  String? imageUrl;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['imageUrl'] = imageUrl;
    map['status'] = status;
    return map;
  }

}
