import 'dart:convert';

SubtitleListModel subtitleListModelFromJson(String str) =>
    SubtitleListModel.fromJson(json.decode(str));

class SubtitleListModel {
  List<SubtitleData> subtitle;
  String status;
  String message;

  SubtitleListModel({this.subtitle, this.status, this.message});

  SubtitleListModel.fromJson(Map<String, dynamic> json) {
    if (json['subtitle'] != null) {
      subtitle = new List<SubtitleData>();
      json['subtitle'].forEach((v) {
        subtitle.add(new SubtitleData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subtitle != null) {
      data['subtitle'] = this.subtitle.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class SubtitleData {
  String id;
  String videoId;
  String title;
  String file;
  String inserted;
  String insertedBy;
  String modified;
  String modifiedBy;
  String status;

  SubtitleData(
      {this.id,
        this.videoId,
        this.title,
        this.file,
        this.inserted,
        this.insertedBy,
        this.modified,
        this.modifiedBy,
        this.status});

  SubtitleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoId = json['video_id'];
    title = json['title'];
    file = json['file'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['file'] = this.file;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['status'] = this.status;
    return data;
  }
}
