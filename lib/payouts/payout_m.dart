class PayoutM {
  List<Payment> payment;
  String status;
  String message;

  PayoutM({this.payment, this.status, this.message});

  PayoutM.fromJson(Map<String, dynamic> json) {
    if (json['payment'] != null) {
      payment = new List<Payment>();
      json['payment'].forEach((v) {
        payment.add(new Payment.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.payment != null) {
      data['payment'] = this.payment.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Payment {
  String course;
  String teacher;
  String id;
  String courseId;
  String teacherId;
  String amount;
  String date;
  String time;
  String status;
  String payAmount;
  int yourIncome;
  int adminIncome;

  Payment(
      {this.course,
        this.teacher,
        this.id,
        this.courseId,
        this.teacherId,
        this.amount,
        this.date,
        this.time,
        this.status,
        this.payAmount,
        this.yourIncome,
        this.adminIncome});

  Payment.fromJson(Map<String, dynamic> json) {
    course = json['course'];
    teacher = json['teacher'];
    id = json['id'];
    courseId = json['course_id'];
    teacherId = json['teacher_id'];
    amount = json['amount'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    payAmount = json['pay_amount'];
    yourIncome = json['your_income'];
    adminIncome = json['admin_income'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course'] = this.course;
    data['teacher'] = this.teacher;
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['teacher_id'] = this.teacherId;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['time'] = this.time;
    data['status'] = this.status;
    data['pay_amount'] = this.payAmount;
    data['your_income'] = this.yourIncome;
    data['admin_income'] = this.adminIncome;
    return data;
  }
}
