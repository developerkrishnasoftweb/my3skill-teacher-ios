class CommonModel<T> {
  String status;
  String message;
  String cid;
  String type;
  T data;

  CommonModel({this.cid, this.status, this.message, this.type, this.data});

  CommonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cid = json['cid'];
    type = json['type'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['cid'] = this.cid;
    data['type'] = this.type;
    data['data'] = this.data;
    return data;
  }
}
