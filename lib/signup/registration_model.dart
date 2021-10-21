import 'dart:convert';

RegistrationResponseModel registrationResponseFromJson(String str) =>
    RegistrationResponseModel.fromJson(json.decode(str));

class RegistrationResponseModel {
  String name;
  String email;
  String mobile;
  String password;
  String deviceType;
  String registeredIp;
  String token;
  String balance;
  String registered;
  String lastLogin;
  String image;
  String id;
  String response;
  String message;

  RegistrationResponseModel({
    this.name,
    this.email,
    this.mobile,
    this.password,
    this.deviceType,
    this.registeredIp,
    this.token,
    this.balance,
    this.registered,
    this.lastLogin,
    this.image,
    this.id,
    this.response,
    this.message,
  });

  RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    deviceType = json['device_type'];
    registeredIp = json['registered_ip'];
    token = json['token'];
    balance = json['balance'].toString();
    registered = json['registered'];
    lastLogin = json['last_login'];
    image = json['image'];
    id = json['id'].toString();
    response = json['response'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['device_type'] = this.deviceType;
    data['registered_ip'] = this.registeredIp;
    data['token'] = this.token;
    data['balance'] = this.balance;
    data['registered'] = this.registered;
    data['last_login'] = this.lastLogin;
    data['image'] = this.image;
    data['id'] = this.id;
    data['response'] = this.response;
    data['message'] = this.message;
    return data;
  }
}
