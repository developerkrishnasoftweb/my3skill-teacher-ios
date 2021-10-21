class StudentsM {
  List<Students> students;
  String status;
  String message;

  StudentsM({this.students, this.status, this.message});

  StudentsM.fromJson(Map<String, dynamic> json) {
    if (json['students'] != null) {
      students = new List<Students>();
      json['students'].forEach((v) {
        students.add(new Students.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.students != null) {
      data['students'] = this.students.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Students {
  String id;
  String name;
  String email;
  String mobile;
  String password;
  String image;
  String registered;
  String lastLogin;
  String registeredIp;
  String headline;
  String website;
  String twitter;
  String facebook;
  String balance;
  String deviceType;
  String status;
  String token;
  String notify;
  String dob;
  String imageUrl;
  String address;
  String gender;
  String premium;

  Students(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.password,
        this.image,
        this.registered,
        this.lastLogin,
        this.registeredIp,
        this.headline,
        this.website,
        this.twitter,
        this.facebook,
        this.balance,
        this.deviceType,
        this.status,
        this.token,
        this.notify,
        this.dob,
        this.imageUrl,
        this.address,
        this.gender,
        this.premium});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    image = json['image'];
    registered = json['registered'];
    lastLogin = json['last_login'];
    registeredIp = json['registered_ip'];
    headline = json['headline'];
    website = json['website'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    balance = json['balance'];
    deviceType = json['device_type'];
    status = json['status'];
    token = json['token'];
    notify = json['notify'];
    dob = json['dob'];
    imageUrl = json['image_url'];
    address = json['address'];
    gender = json['gender'];
    premium = json['premium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['image'] = this.image;
    data['registered'] = this.registered;
    data['last_login'] = this.lastLogin;
    data['registered_ip'] = this.registeredIp;
    data['headline'] = this.headline;
    data['website'] = this.website;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['balance'] = this.balance;
    data['device_type'] = this.deviceType;
    data['status'] = this.status;
    data['token'] = this.token;
    data['notify'] = this.notify;
    data['dob'] = this.dob;
    data['image_url'] = this.imageUrl;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['premium'] = this.premium;
    return data;
  }
}
