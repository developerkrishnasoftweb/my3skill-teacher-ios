import 'dart:convert';

GetCoursesModel coursesModelResponseFromJson(String str) =>
    GetCoursesModel.fromJson(json.decode(str));

class GetCoursesModel {
  List<CourseData> course;
  String status;
  String message;

  GetCoursesModel({this.course, this.status, this.message});

  GetCoursesModel.fromJson(Map<String, dynamic> json) {
    if (json['course'] != null) {
      course = new List<CourseData>();
      json['course'].forEach((v) {
        course.add(new CourseData.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.course != null) {
      data['course'] = this.course.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class CourseData {
  String id;
  String categoryId;
  String subcategoryId;
  String topicId;
  String course;
  String image;
  String preview;
  String price;
  String short;
  String long;
  String whatLearn;
  String requirement;
  String includes;
  String dayToComplete;
  String status;
  String inserted;
  String insertedBy;
  String modified;
  String modifiedBy;
  var rating;
  String sellerType;
  String teacherId;
  String oldAmount;
  String featured;
  String languageId;
  String totalRating;

  CourseData(
      {this.id,
      this.categoryId,
      this.subcategoryId,
      this.topicId,
      this.course,
      this.image,
      this.preview,
      this.price,
      this.short,
      this.long,
      this.whatLearn,
      this.requirement,
      this.includes,
      this.dayToComplete,
      this.status,
      this.inserted,
      this.insertedBy,
      this.modified,
      this.modifiedBy,
      this.rating,
      this.sellerType,
      this.featured,
      this.languageId,
      this.oldAmount,
      this.teacherId,
      this.totalRating});

  CourseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    subcategoryId = json['subcategory_id'];
    topicId = json['topic_id'];
    course = json['course'];
    image = json['image'];
    preview = json['preview'];
    price = json['price'];
    short = json['short'];
    long = json['long'];
    whatLearn = json['what_learn'];
    requirement = json['requirement'];
    includes = json['includes'];
    dayToComplete = json['day_to_complete'];
    status = json['status'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    rating = json['rating'];
    sellerType = json['seller_type'];
    teacherId = json['teacher_id']?.toString();
    oldAmount = json['old_amt']?.toString();
    featured = json['featured']?.toString();
    languageId = json['language_id']?.toString();
    totalRating = json['total_rating']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subcategoryId;
    data['topic_id'] = this.topicId;
    data['course'] = this.course;
    data['image'] = this.image;
    data['preview'] = this.preview;
    data['price'] = this.price;
    data['short'] = this.short;
    data['long'] = this.long;
    data['what_learn'] = this.whatLearn;
    data['requirement'] = this.requirement;
    data['includes'] = this.includes;
    data['day_to_complete'] = this.dayToComplete;
    data['status'] = this.status;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['rating'] = this.rating;
    data['seller_type'] = this.sellerType;
    data['teacher_id'] = this.teacherId;
    data['old_amt'] = this.oldAmount;
    data['featured'] = this.featured;
    data['language_id'] = this.languageId;
    data['total_rating'] = this.totalRating;
    return data;
  }
}
