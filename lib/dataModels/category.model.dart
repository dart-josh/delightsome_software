class CategoryModel {
  String? key;
  String category;
  int sort;

  CategoryModel({this.key, required this.category, required this.sort});

  // get model from json
  factory CategoryModel.fromJson(Map json) {
    return CategoryModel(
      key: json['_id'],
      category: json['category'],
      sort: json['sort'],
    );
  }

  // get json from model
  Map toJson() => {
        'id': key,
        'category': category,
        'sort': sort,
      };
}
