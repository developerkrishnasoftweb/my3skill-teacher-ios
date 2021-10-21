import 'dart:convert';

SubCategoriesModel subCategoriesModelResponseFromJson(String str) =>
    SubCategoriesModel.fromJson(json.decode(str));

class SubCategoriesModel {
  String status;
  String message;
  List<Subcategory> subcategory;

  SubCategoriesModel({this.status, this.message, this.subcategory});

  SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['subcategory'] != null) {
      subcategory = new List<Subcategory>();
      json['subcategory'].forEach((v) {
        subcategory.add(new Subcategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.subcategory != null) {
      data['subcategory'] = this.subcategory.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subcategory {
  String id;
  String categoryId;
  String subcategory;
  String image;
  String status;
  String inserted;
  String insertedBy;
  String modifiedBy;
  String modified;

  Subcategory(
      {this.id,
        this.categoryId,
        this.subcategory,
        this.image,
        this.status,
        this.inserted,
        this.insertedBy,
        this.modifiedBy,
        this.modified});

  Subcategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategory = json['subcategory'];
    image = json['image'];
    status = json['status'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modifiedBy = json['modified_by'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['subcategory'] = this.subcategory;
    data['image'] = this.image;
    data['status'] = this.status;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified_by'] = this.modifiedBy;
    data['modified'] = this.modified;
    return data;
  }
}
