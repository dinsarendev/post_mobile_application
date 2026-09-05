class UpdatePostRequest {
  UpdatePostRequest({
      this.title,
      this.description,
      this.body,
      this.image,
      this.categoryId,
      this.tags,
      this.status,});

  UpdatePostRequest.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
    body = json['body'];
    image = json['image'];
    categoryId = json['categoryId'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    status = json['status'];
  }
  String? title;
  String? description;
  String? body;
  String? image;
  int? categoryId;
  List<String>? tags;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['body'] = body;
    map['image'] = image;
    map['categoryId'] = categoryId;
    map['tags'] = tags;
    map['status'] = status;
    return map;
  }

}
