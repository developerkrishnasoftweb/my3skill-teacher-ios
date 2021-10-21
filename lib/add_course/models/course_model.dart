import 'dart:io';

class CourseModel {
  final String title,
      short,
      long,
      language,
      courseLevel,
      category,
      subCategory,
      childCategory,
      learn,
      price,
      requirement,
      includes,
      discountPrice,
      courseTeacherId;

  File image, video;

  CourseModel({
    this.title,
    this.requirement,
    this.includes,
    this.short,
    this.long,
    this.language,
    this.courseLevel,
    this.category,
    this.subCategory,
    this.childCategory,
    this.learn,
    this.price,
    this.discountPrice,
    this.courseTeacherId,
    this.image,
    this.video,
  });
}
