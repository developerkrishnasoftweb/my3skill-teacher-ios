import 'dart:convert';

ChatResponseModel chatResponseModelFromJson(String str) =>
    ChatResponseModel.fromJson(json.decode(str));

class ChatResponseModel {
  String studentId;
  String teacherId;
  String type;
  String sentBy;
  String date;
  String time;
  String clickAction;
  String status;
  int id;
  String message;
  String file;

  ChatResponseModel({this.studentId,
    this.teacherId,
    this.type,
    this.sentBy,
    this.date,
    this.time,
    this.clickAction,
    this.status,
    this.id,
    this.file,
    this.message});

  ChatResponseModel.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    type = json['type'];
    sentBy = json['sent_by'];
    date = json['date'];
    time = json['time'];
    clickAction = json['click_action'];
    status = json['status'];
    id = json['id'];
    message = json['message'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['type'] = this.type;
    data['sent_by'] = this.sentBy;
    data['date'] = this.date;
    data['time'] = this.time;
    data['click_action'] = this.clickAction;
    data['status'] = this.status;
    data['id'] = this.id;
    data['message'] = this.message;
    data['file'] = this.file;
    return data;
  }
}
