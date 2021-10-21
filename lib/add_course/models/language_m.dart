class CourseLangM {
  List<Languages> languages;
  String status;
  String message;

  CourseLangM({this.languages, this.status, this.message});

  CourseLangM.fromJson(Map<String, dynamic> json) {
    if (json['languages'] != null) {
      languages = new List<Languages>();
      json['languages'].forEach((v) { languages.add(new Languages.fromJson(v)); });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.languages != null) {
      data['languages'] = this.languages.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Languages {
  String id;
  String title;
  String code;
  String status;
  String defaults;

  Languages({this.id, this.title, this.code, this.status, this.defaults});

Languages.fromJson(Map<String, dynamic> json) {
id = json['id'];
title = json['title'];
code = json['code'];
status = json['status'];
defaults = json['default'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['title'] = this.title;
  data['code'] = this.code;
  data['status'] = this.status;
  data['default'] = this.defaults;
  return data;
}
}
