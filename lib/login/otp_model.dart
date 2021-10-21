class OTPModel {
  Data data;
  int otp;
  String status;
  String message;

  OTPModel({this.data, this.otp, this.status, this.message});

  OTPModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    otp = json['otp'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['otp'] = this.otp;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String id;
  String name;
  String tagline;
  String tags;
  String image;
  String mobile;
  String email;
  String description;
  String inserted;
  String insertedBy;
  String modified;
  String modifiedBy;
  String status;
  String twitter;
  String facebook;
  String linkedin;
  String youtube;
  String balance;
  String deviceType;
  String token;
  String registered;
  String registeredIp;
  String lastLogin;
  String password;
  String verified;
  String dob;
  String gender;
  String resume;

  Data(
      {this.id,
        this.name,
        this.tagline,
        this.tags,
        this.image,
        this.mobile,
        this.email,
        this.description,
        this.inserted,
        this.insertedBy,
        this.modified,
        this.modifiedBy,
        this.status,
        this.twitter,
        this.facebook,
        this.linkedin,
        this.youtube,
        this.balance,
        this.deviceType,
        this.token,
        this.registered,
        this.registeredIp,
        this.lastLogin,
        this.password,
        this.verified,
        this.dob,
        this.gender,
        this.resume});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tagline = json['tagline'];
    tags = json['tags'];
    image = json['image'];
    mobile = json['mobile'];
    email = json['email'];
    description = json['description'];
    inserted = json['inserted'];
    insertedBy = json['inserted_by'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    status = json['status'];
    twitter = json['twitter'];
    facebook = json['facebook'];
    linkedin = json['linkedin'];
    youtube = json['youtube'];
    balance = json['balance'];
    deviceType = json['device_type'];
    token = json['token'];
    registered = json['registered'];
    registeredIp = json['registered_ip'];
    lastLogin = json['last_login'];
    password = json['password'];
    verified = json['verified'];
    dob = json['dob'];
    gender = json['gender'];
    resume = json['resume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['tagline'] = this.tagline;
    data['tags'] = this.tags;
    data['image'] = this.image;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['description'] = this.description;
    data['inserted'] = this.inserted;
    data['inserted_by'] = this.insertedBy;
    data['modified'] = this.modified;
    data['modified_by'] = this.modifiedBy;
    data['status'] = this.status;
    data['twitter'] = this.twitter;
    data['facebook'] = this.facebook;
    data['linkedin'] = this.linkedin;
    data['youtube'] = this.youtube;
    data['balance'] = this.balance;
    data['device_type'] = this.deviceType;
    data['token'] = this.token;
    data['registered'] = this.registered;
    data['registered_ip'] = this.registeredIp;
    data['last_login'] = this.lastLogin;
    data['password'] = this.password;
    data['verified'] = this.verified;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['resume'] = this.resume;
    return data;
  }
}
