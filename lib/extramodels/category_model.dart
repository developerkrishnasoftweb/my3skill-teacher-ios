import 'dart:convert';

CategoriesModel categoriesResponseFromJson(String str) =>
    CategoriesModel.fromJson(json.decode(str));

class CategoriesModel {
  List<Category> category;

  CategoriesModel({this.category});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = new List<Category>();
      json['category'].forEach((v) {
        category.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.category != null) {
      data['category'] = this.category.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String id;
  String category;
  String image;
  String status;
  String inserted;
  String insertedBy;
  String modified;
  String modifiedBy;

  Category(
      {this.id,
        this.category,
        this.image,
        this.status,
        this.inserted,
        this.insertedBy,
        this.modified,
        this.modifiedBy});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    image = json['image'];
    status = json['status'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['image'] = this.image;
    data['status'] = this.status;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
