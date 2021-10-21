class GetQuestionsModel {
  List<QuestionsData> questions;
  String status;
  String message;

  GetQuestionsModel({this.questions, this.status, this.message});

  GetQuestionsModel.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = new List<QuestionsData>();
      json['questions'].forEach((v) {
        questions.add(new QuestionsData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.questions != null) {
      data['questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class QuestionsData {
  String id;
  String studentId;
  String videoId;
  String question;
  String answer;
  String replied;
  String status;
  String asked;
  String answered;

  QuestionsData(
      {this.id,
        this.studentId,
        this.videoId,
        this.question,
        this.answer,
        this.replied,
        this.status,
        this.asked,
        this.answered});

  QuestionsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    videoId = json['video_id'];
    question = json['question'];
    answer = json['answer'];
    replied = json['replied'];
    status = json['status'];
    asked = json['asked'];
    answered = json['answered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['video_id'] = this.videoId;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['replied'] = this.replied;
    data['status'] = this.status;
    data['asked'] = this.asked;
    data['answered'] = this.answered;
    return data;
  }
}
