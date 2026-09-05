class UpdatePostRequest {
  UpdatePostRequest({
      this.title,
      this.description,
      this.image,
      this.categoryId,});

  UpdatePostRequest.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    categoryId = json['categoryId'];
  }
  String? title;
  String? description;
  String? image;
  int? categoryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['categoryId'] = categoryId;
    return map;
  }

}
