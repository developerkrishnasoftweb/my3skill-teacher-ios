class PaymentConfigM {
  String id;
  String deviceLimit;
  String watchLimit;
  String title;
  String logo;
  String contact;
  String email;
  String copyright;
  String address;
  String favicon;
  String featureAmount;
  String metaDescription;
  String metaKeywords;
  String analyticKey;
  String sender;
  String fromEmail;
  String hostName;
  String password;
  String senderEmail;
  String icon;
  String currency;
  String teacherIncome;
  String adminIncome;
  String zoomEmail;
  String jwtToken;
  String courseHeading;
  String courseSubheading;
  String studentRedeem;
  String teacherRedeem;
  String premiumFeature;
  String premiumAmount;
  String premiumLimit;
  String facebookAppId;
  String facebookSecretKey;
  String googleClientId;
  String googleSecretKey;
  String preloader;
  String premiumTeacherFeature;
  String premiumTeacherAmount;
  String uploadLimit;
  String uploadLimitFeature;
  String videoSizeLimit;
  Payment payment;

  PaymentConfigM(
      {this.id,
        this.deviceLimit,
        this.watchLimit,
        this.title,
        this.logo,
        this.contact,
        this.email,
        this.copyright,
        this.address,
        this.favicon,
        this.featureAmount,
        this.metaDescription,
        this.metaKeywords,
        this.analyticKey,
        this.sender,
        this.fromEmail,
        this.hostName,
        this.password,
        this.senderEmail,
        this.icon,
        this.currency,
        this.teacherIncome,
        this.adminIncome,
        this.zoomEmail,
        this.jwtToken,
        this.courseHeading,
        this.courseSubheading,
        this.studentRedeem,
        this.teacherRedeem,
        this.premiumFeature,
        this.premiumAmount,
        this.premiumLimit,
        this.facebookAppId,
        this.facebookSecretKey,
        this.googleClientId,
        this.googleSecretKey,
        this.preloader,
        this.premiumTeacherFeature,
        this.premiumTeacherAmount,
        this.uploadLimit,
        this.uploadLimitFeature,
        this.videoSizeLimit,
        this.payment});

  PaymentConfigM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceLimit = json['device_limit'];
    watchLimit = json['watch_limit'];
    title = json['title'];
    logo = json['logo'];
    contact = json['contact'];
    email = json['email'];
    copyright = json['copyright'];
    address = json['address'];
    favicon = json['favicon'];
    featureAmount = json['feature_amount'];
    metaDescription = json['meta_description'];
    metaKeywords = json['meta_keywords'];
    analyticKey = json['analytic_key'];
    sender = json['sender'];
    fromEmail = json['from_email'];
    hostName = json['host_name'];
    password = json['password'];
    senderEmail = json['sender_email'];
    icon = json['icon'];
    currency = json['currency'];
    teacherIncome = json['teacher_income'];
    adminIncome = json['admin_income'];
    zoomEmail = json['zoom_email'];
    jwtToken = json['jwt_token'];
    courseHeading = json['course_heading'];
    courseSubheading = json['course_subheading'];
    studentRedeem = json['student_redeem'];
    teacherRedeem = json['teacher_redeem'];
    premiumFeature = json['premium_feature'];
    premiumAmount = json['premium_amount'];
    premiumLimit = json['premium_limit'];
    facebookAppId = json['facebook_app_id'];
    facebookSecretKey = json['facebook_secret_key'];
    googleClientId = json['google_client_id'];
    googleSecretKey = json['google_secret_key'];
    preloader = json['preloader'];
    premiumTeacherFeature = json['premium_teacher_feature'];
    premiumTeacherAmount = json['premium_teacher_amount'];
    uploadLimit = json['upload_limit'];
    uploadLimitFeature = json['upload_limit_feature'];
    videoSizeLimit = json['video_size_limit'];
    payment =
    json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['device_limit'] = this.deviceLimit;
    data['watch_limit'] = this.watchLimit;
    data['title'] = this.title;
    data['logo'] = this.logo;
    data['contact'] = this.contact;
    data['email'] = this.email;
    data['copyright'] = this.copyright;
    data['address'] = this.address;
    data['favicon'] = this.favicon;
    data['feature_amount'] = this.featureAmount;
    data['meta_description'] = this.metaDescription;
    data['meta_keywords'] = this.metaKeywords;
    data['analytic_key'] = this.analyticKey;
    data['sender'] = this.sender;
    data['from_email'] = this.fromEmail;
    data['host_name'] = this.hostName;
    data['password'] = this.password;
    data['sender_email'] = this.senderEmail;
    data['icon'] = this.icon;
    data['currency'] = this.currency;
    data['teacher_income'] = this.teacherIncome;
    data['admin_income'] = this.adminIncome;
    data['zoom_email'] = this.zoomEmail;
    data['jwt_token'] = this.jwtToken;
    data['course_heading'] = this.courseHeading;
    data['course_subheading'] = this.courseSubheading;
    data['student_redeem'] = this.studentRedeem;
    data['teacher_redeem'] = this.teacherRedeem;
    data['premium_feature'] = this.premiumFeature;
    data['premium_amount'] = this.premiumAmount;
    data['premium_limit'] = this.premiumLimit;
    data['facebook_app_id'] = this.facebookAppId;
    data['facebook_secret_key'] = this.facebookSecretKey;
    data['google_client_id'] = this.googleClientId;
    data['google_secret_key'] = this.googleSecretKey;
    data['preloader'] = this.preloader;
    data['premium_teacher_feature'] = this.premiumTeacherFeature;
    data['premium_teacher_amount'] = this.premiumTeacherAmount;
    data['upload_limit'] = this.uploadLimit;
    data['upload_limit_feature'] = this.uploadLimitFeature;
    data['video_size_limit'] = this.videoSizeLimit;
    if (this.payment != null) {
      data['payment'] = this.payment.toJson();
    }
    return data;
  }
}

class Payment {
  String id;
  String stripeStatus;
  String stripeKey;
  String stripeSecretKey;
  String razorStatus;
  String razorKeyId;
  String razorSecretKey;

  Payment(
      {this.id,
        this.stripeStatus,
        this.stripeKey,
        this.stripeSecretKey,
        this.razorStatus,
        this.razorKeyId,
        this.razorSecretKey});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stripeStatus = json['stripe_status'];
    stripeKey = json['stripe_key'];
    stripeSecretKey = json['stripe_secret_key'];
    razorStatus = json['razor_status'];
    razorKeyId = json['razor_key_id'];
    razorSecretKey = json['razor_secret_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stripe_status'] = this.stripeStatus;
    data['stripe_key'] = this.stripeKey;
    data['stripe_secret_key'] = this.stripeSecretKey;
    data['razor_status'] = this.razorStatus;
    data['razor_key_id'] = this.razorKeyId;
    data['razor_secret_key'] = this.razorSecretKey;
    return data;
  }
}
