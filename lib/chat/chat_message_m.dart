import 'package:audioplayers/audioplayers.dart';

class ChatMessagesM {
  String status;
  String message;
  List<Chats> chats;

  ChatMessagesM({this.status, this.message, this.chats});

  ChatMessagesM.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['chats'] != null) {
      chats = new List<Chats>();
      json['chats'].forEach((v) {
        chats.add(new Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.chats != null) {
      data['chats'] = this.chats.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String id;
  String teacherId;
  String studentId;
  String message;
  String type;
  String date;
  String time;
  String sentBy;
  String file;
  String status;
  Duration position, duration;
  PlayerState playerState = PlayerState.STOPPED;
  AudioPlayer audioPlayer = AudioPlayer();

  Chats({
    this.id,
    this.teacherId,
    this.studentId,
    this.message,
    this.type,
    this.date,
    this.time,
    this.sentBy,
    this.status,
    this.file,
  });

  Chats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teacherId = json['teacher_id'];
    studentId = json['student_id'];
    message = json['message'];
    type = json['type'];
    date = json['date'];
    time = json['time'];
    sentBy = json['sent_by'];
    file = json['file'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teacher_id'] = this.teacherId;
    data['student_id'] = this.studentId;
    data['message'] = this.message;
    data['type'] = this.type;
    data['date'] = this.date;
    data['time'] = this.time;
    data['sent_by'] = this.sentBy;
    data['file'] = this.file;
    data['status'] = this.status;
    return data;
  }
}
