class WalletModel {
  String currency;
  String balance;
  List<Transaction> transaction;
  String status;
  String message;

  WalletModel(
      {this.currency,
        this.balance,
        this.transaction,
        this.status,
        this.message});

  WalletModel.fromJson(Map<String, dynamic> json) {
    currency = json['currency'];
    balance = json['balance'];
    if (json['transaction'] != null) {
      transaction = new List<Transaction>();
      json['transaction'].forEach((v) {
        transaction.add(new Transaction.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = this.currency;
    data['balance'] = this.balance;
    if (this.transaction != null) {
      data['transaction'] = this.transaction.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Transaction {
  String id;
  String studentId;
  String teacherId;
  String type;
  String amount;
  String transDate;
  String paymentNo;

  Transaction(
      {this.id,
        this.studentId,
        this.teacherId,
        this.type,
        this.amount,
        this.transDate,
        this.paymentNo});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    teacherId = json['teacher_id'];
    type = json['type'];
    amount = json['amount'];
    transDate = json['trans_date'];
    paymentNo = json['payment_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['teacher_id'] = this.teacherId;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['trans_date'] = this.transDate;
    data['payment_no'] = this.paymentNo;
    return data;
  }
}
