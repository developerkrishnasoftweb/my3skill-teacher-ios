import 'chat_message_m.dart';

class ChatListModel {
  List<StudentModel> student;
  String status;
  String message;

  ChatListModel({this.student, this.status, this.message});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    if (json['student'] != null) {
      student = new List<StudentModel>();
      json['student'].forEach((v) {
        student.add(new StudentModel.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.student != null) {
      data['student'] = this.student.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class StudentModel {
  String id;
  String name;
  String mobile;
  String image;
  String studentId;
  String teacherId;
  String updated;

  List<Chats> chatsList = [];

  StudentModel(
      {this.id,
        this.name,
        this.mobile,
        this.image,
        this.studentId,
        this.teacherId,
        this.updated});

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    image = json['image'];
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['updated'] = this.updated;
    return data;
  }
}
