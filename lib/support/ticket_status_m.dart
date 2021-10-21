class TicketStatusM {
  String status;
  Detail detail;
  List<Messages> messages;
  String message;

  TicketStatusM({this.status, this.detail, this.messages, this.message});

  TicketStatusM.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    detail =
    json['detail'] != null ? new Detail.fromJson(json['detail']) : null;
    if (json['messages'] != null) {
      messages = new List<Messages>();
      json['messages'].forEach((v) {
        messages.add(new Messages.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.detail != null) {
      data['detail'] = this.detail.toJson();
    }
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Detail {
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

  Detail(
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

  Detail.fromJson(Map<String, dynamic> json) {
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

class Messages {
  String id;
  String supportId;
  String added;
  String message;

  Messages({this.id, this.supportId, this.added, this.message});

  Messages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supportId = json['support_id'];
    added = json['added'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['support_id'] = this.supportId;
    data['added'] = this.added;
    data['message'] = this.message;
    return data;
  }
}
