class SupportM {
  String id;
  String name;
  String email;
  String mobile;
  String message;
  String attachment;
  String inserted;
  String status;
  String closed;
  String remark;
  String ticketNo;

  SupportM(
      {this.id,
        this.name,
        this.email,
        this.mobile,
        this.message,
        this.attachment,
        this.inserted,
        this.status,
        this.closed,
        this.remark,
        this.ticketNo});

  SupportM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    message = json['message'];
    attachment = json['attachment'];
    inserted = json['inserted'];
    status = json['status'];
    closed = json['closed'];
    remark = json['remark'];
    ticketNo = json['ticket_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['inserted'] = this.inserted;
    data['status'] = this.status;
    data['closed'] = this.closed;
    data['remark'] = this.remark;
    data['ticket_no'] = this.ticketNo;
    return data;
  }
}
