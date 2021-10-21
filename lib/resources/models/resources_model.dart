import 'dart:convert';

ResourcesListModel resourcesListModelFromJson(String str) =>
    ResourcesListModel.fromJson(json.decode(str));

class ResourcesListModel {
  List<ResourcesData> resources;
  String status;
  String message;

  ResourcesListModel({this.resources, this.status, this.message});

  ResourcesListModel.fromJson(Map<String, dynamic> json) {
    if (json['resources'] != null) {
      resources = new List<ResourcesData>();
      json['resources'].forEach((v) {
        resources.add(new ResourcesData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.resources != null) {
      data['resources'] = this.resources.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class ResourcesData {
  String id;
  String courseId;
  String videoId;
  String title;
  String file;
  String status;

  ResourcesData(
      {this.id,
        this.courseId,
        this.videoId,
        this.title,
        this.file,
        this.status});

  ResourcesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    videoId = json['video_id'];
    title = json['title'];
    file = json['file'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['file'] = this.file;
    data['status'] = this.status;
    return data;
  }
}
