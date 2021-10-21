import 'package:my3skill_teacher_ios/videos/videos_list_model.dart';

class CourseSections {
  String id;
  String courseId;
  String title;
  String status;
  String position;
  List<VideosData> videos;

  CourseSections(
      {this.id,
      this.courseId,
      this.title,
      this.status,
      this.videos = const []});

  CourseSections.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    courseId = json['course_id']?.toString();
    title = json['title']?.toString();
    status = json['status']?.toString();
    position = json['position']?.toString();
    if (json['videos'] != null) {
      videos = <VideosData>[];
      json['videos'].forEach((v) {
        videos.add(new VideosData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['status'] = this.status;
    data['position'] = this.position;
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
