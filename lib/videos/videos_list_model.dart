import 'dart:convert';

VideosListModel videosListModelFromJson(String str) =>
    VideosListModel.fromJson(json.decode(str));

class VideosListModel {
  List<VideosData> videos;
  String status;
  String message;

  VideosListModel({this.videos, this.status, this.message});

  VideosListModel.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = new List<VideosData>();
      json['videos'].forEach((v) {
        videos.add(new VideosData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class VideosData {
  String id;
  String title;
  String description;
  String thumb;
  String video;
  String courseId;
  String status;
  String inserted;
  String insertedBy;
  String modified;
  String modifiedBy;
  String position;
  List qualities;
  List subtitles;
  List resources;

  VideosData(
      {this.id,
      this.title,
      this.description,
      this.thumb,
      this.video,
      this.courseId,
      this.status,
      this.inserted,
      this.insertedBy,
      this.modified,
      this.modifiedBy,
      this.position,
      this.qualities = const [],
      this.resources = const [],
      this.subtitles = const []});

  VideosData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    thumb = json['thumb'];
    video = json['video'];
    courseId = json['course_id'];
    status = json['status'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    position = json['position'];
    qualities = json['qualities'];
    subtitles = json['subtitles'];
    resources = json['resources'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumb'] = this.thumb;
    data['video'] = this.video;
    data['course_id'] = this.courseId;
    data['status'] = this.status;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['position'] = this.position;
    data['qualities'] = this.qualities;
    data['subtitles'] = this.subtitles;
    data['resources'] = this.resources;
    return data;
  }
}
