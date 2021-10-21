import 'dart:convert';

TopicsModel topicsModelResponseFromJson(String str) =>
    TopicsModel.fromJson(json.decode(str));

class TopicsModel {
  String status;
  String message;
  List<Topics> topics;

  TopicsModel({this.status, this.message, this.topics});

  TopicsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['topics'] != null) {
      topics = new List<Topics>();
      json['topics'].forEach((v) {
        topics.add(new Topics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.topics != null) {
      data['topics'] = this.topics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Topics {
  String id;
  String categoryId;
  String subcategoryId;
  String topic;
  String status;
  String logo;
  String insertedBy;
  String inserted;
  String modified;
  String modifiedBy;

  Topics(
      {this.id,
        this.categoryId,
        this.subcategoryId,
        this.topic,
        this.status,
        this.logo,
        this.insertedBy,
        this.inserted,
        this.modified,
        this.modifiedBy});

  Topics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    topic = json['topic'];
    status = json['status'];
    logo = json['logo'];
    insertedBy = json['inserted_by'];
    inserted = json['inserted'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['topic'] = this.topic;
    data['status'] = this.status;
    data['logo'] = this.logo;
    data['inserted_by'] = this.insertedBy;
    data['inserted'] = this.inserted;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    return data;
  }
}
