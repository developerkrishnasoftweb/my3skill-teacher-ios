import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:my3skill_teacher_ios/add_course/models/language_m.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/chat/chat_list_model.dart';
import 'package:my3skill_teacher_ios/chat/chat_message_m.dart';
import 'package:my3skill_teacher_ios/chat/chat_message_model.dart';
import 'package:my3skill_teacher_ios/course_list/course_list_model.dart';
import 'package:my3skill_teacher_ios/extramodels/category_model.dart';
import 'package:my3skill_teacher_ios/extramodels/subcategories_model.dart';
import 'package:my3skill_teacher_ios/extramodels/topics_model.dart';
import 'package:my3skill_teacher_ios/forgot_password/common_model.dart';
import 'package:my3skill_teacher_ios/login/login_model.dart';
import 'package:my3skill_teacher_ios/login/otp_model.dart';
import 'package:my3skill_teacher_ios/payouts/payout_m.dart';
import 'package:my3skill_teacher_ios/questions/get_questions_model.dart';
import 'package:my3skill_teacher_ios/resources/models/resources_model.dart';
import 'package:my3skill_teacher_ios/sections/models/models.dart';
import 'package:my3skill_teacher_ios/students/students_m.dart';
import 'package:my3skill_teacher_ios/subtitles/subtitle_model.dart';
import 'package:my3skill_teacher_ios/support/pay_config_m.dart';
import 'package:my3skill_teacher_ios/support/support_m.dart';
import 'package:my3skill_teacher_ios/support/ticket_status_m.dart';
import 'package:my3skill_teacher_ios/videos/videos_list_model.dart';
import 'package:my3skill_teacher_ios/wallet/wallet_model.dart';

class ApiData {
  //Login
  static Future<AuthModel> getLogin(Map map) async {
    try {
      print("The response map : $map");
      var response = await http.post(Uri.parse(ApiUrls.LOGIN), body: map);
      print("The response body : ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        AuthModel loginResponseModel =
            AuthModel.fromJson(json.decode(response.body));
        return loginResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Logout
  static Future<CommonModel> logoutUser() async {
//    Map map = {"teacher": Constants.userId, "token": ""};
//
//    var response = await http.post('${ApiUrls.LOGOUT}', body: map);

    try {
      var response = await http.post(Uri.parse('${ApiUrls.LOGOUT}/${Constants.userId}'));
      print("The logout response body : ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(json.decode(response.body));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Register
  static Future<AuthModel> socialLogin(Map registerMap) async {
    try {
      print("the map : $registerMap");
      var response = await http.post(Uri.parse(ApiUrls.SOCIAL_LOGIN), body: registerMap);

      showLog("social response ==>> ${response.body}");

      if (response != null && response.body != null && response.body != '') {
        AuthModel model = AuthModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Forget Password
  static Future<CommonModel> forgetPassword(String email) async {
    try {
      var response = await http.get(Uri.parse('${ApiUrls.FORGET_PASSWORD}/$email'));
      print("The forget password response body : ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(jsonDecode(response.body));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Register
  static Future<AuthModel> getRegistration(
      Map<String, dynamic> registerMap) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(registerMap);

      print("The getRegistration request is : ${formData.toString()}");

      var response = await dio.post(ApiUrls.REGISTER, data: formData);

      print("The getRegistration response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        AuthModel model = AuthModel.fromJson(json.decode(response.data));
        return model;
      }
    } catch (e) {
      print('exception ====>>> $e');
    }
    return null;
  }

  //Course list
  static Future<GetCoursesModel> getCoursesList(String teacherID) async {
    try {
      var response = await http.get(Uri.parse("${ApiUrls.COURSES_LIST}/$teacherID"));
      print(ApiUrls.COURSES_LIST);
      showLog("courses response ==>> ${response.body.toString()}");

      if (response != null && response.body != null && response.body != '') {
        GetCoursesModel coursesModel =
            coursesModelResponseFromJson(response.body);
        return coursesModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Categories
  static Future<CategoriesModel> getCategories() async {
    try {
      var response = await http.get(Uri.parse(ApiUrls.CATEGORIES));

      print("The response is : ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        CategoriesModel categoriesModel =
            categoriesResponseFromJson(response.body);

        return categoriesModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Sub categories
  static Future<SubCategoriesModel> getSubCategories(String categoryId) async {
    try {
      var response =
          await http.post(Uri.parse("${ApiUrls.SUB_CATEGORIES}?category=$categoryId"));

      if (response != null && response.body != null && response.body != '') {
        SubCategoriesModel subCategoriesModel =
            subCategoriesModelResponseFromJson(response.body);
        return subCategoriesModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Topics
  static Future<TopicsModel> getTopics(String subCategoryId) async {
    try {
      var response =
          await http.post(Uri.parse("${ApiUrls.TOPICS}?subcategory=$subCategoryId"));

      if (response != null && response.body != null && response.body != '') {
        TopicsModel topicsModel = topicsModelResponseFromJson(response.body);
        return topicsModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  } //Topics

  static Future<CourseLangM> getLanguages() async {
    try {
      var response = await http.get(Uri.parse(ApiUrls.LANGUAGES));

      if (response != null && response.body != null && response.body != '') {
        CourseLangM model = CourseLangM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Add Course
  static Future<CommonModel> addCourse(Map courseMap) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(courseMap);

      showLog("add course request map ====> $courseMap");
      showLog("add course request form ====> ${formData.fields}");

      var response = await dio.post(ApiUrls.ADD_COURSE, data: formData);

      print("The response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(jsonDecode(response.data));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('addCourse exception ====>>> ${e.toString()}');
    }
    return null;
  }

  // Update course
  static Future<CommonModel> updateCourse(Map courseMap) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(courseMap);

      showLog("add course request map ====> $courseMap");
      showLog("add course request form ====> ${formData.fields}");

      var response = await dio.post(ApiUrls.UPDATE_COURSE, data: formData);

      print("The response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(jsonDecode(response.data));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('addCourse exception ====>>> ${e.toString()}');
    }
    return null;
  }

  // Delete course
  static Future<CommonModel> deleteCourse(String courseId) async {
    try {
      var dio = Dio();
      print("${ApiUrls.DELETE_COURSE}/$courseId");
      var response = await dio.get("${ApiUrls.DELETE_COURSE}/$courseId");

      print("The response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(jsonDecode(response.data));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('addCourse exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Videos List
  static Future<VideosListModel> getVideosList(String courseId) async {
    try {
      // print("The url is : ${ApiUrls.VIDEOS}/$courseId");
      var response = await http.get(Uri.parse("${ApiUrls.VIDEOS}/$courseId"));
      // print("The response is : ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        VideosListModel videosListModel =
            videosListModelFromJson(response.body);
        return videosListModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Course Sections List
  static Future<List<CourseSections>> getCourseSections(String courseId) async {
    try {
      var response = await http.get(Uri.parse("${ApiUrls.COURSE_SECTION}/$courseId"));
      if (response != null && response.body != null && response.body != '') {
        List<CourseSections> courseSections = <CourseSections>[];
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null) {
          if (jsonResponse['section'] != null) {
            jsonResponse['section'].forEach((v) {
              courseSections.add(new CourseSections.fromJson(v));
            });
          }
        }
        return courseSections;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  // Add section
  static Future<CommonModel<CourseSections>> addSection(Map data) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(data);

      var response = await dio.post(ApiUrls.ADD_SECTION, data: formData);
      if (response != null && response.data != null && response.data != '') {
        final jsonResponse = jsonDecode(response.data);
        return CommonModel(
            status: jsonResponse['status'],
            message: jsonResponse['message'],
            data: CourseSections.fromJson(jsonResponse['data']));
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  // Update section
  static Future<CommonModel<CourseSections>> updateSection(Map data) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(data);

      var response = await dio.post(ApiUrls.UPDATE_SECTION, data: formData);
      if (response != null && response.data != null && response.data != '') {
        final jsonResponse = jsonDecode(response.data);
        return CommonModel(
            status: jsonResponse['status'],
            message: jsonResponse['message'],
            data: CourseSections.fromJson(jsonResponse['data']));
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  // Delete section
  static Future<CommonModel> deleteSection(String sectionId) async {
    try {
      var dio = Dio();
      var response = await dio.get('${ApiUrls.DELETE_SECTION}/$sectionId');
      if (response != null && response.data != null && response.data != '') {
        final jsonResponse = jsonDecode(response.data);
        return CommonModel.fromJson(jsonResponse);
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  //Resources List
  static Future<ResourcesListModel> getResourcesList(String videoId) async {
    try {
      var response = await http.get(Uri.parse("${ApiUrls.RESOURCES}/$videoId"));

      if (response != null && response.body != null && response.body != '') {
        ResourcesListModel resourcesListModel =
            resourcesListModelFromJson(response.body);
        return resourcesListModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Subtitles List
  static Future<SubtitleListModel> getSubtitlesList(String videoId) async {
    try {
      print("The params => ${ApiUrls.SUBTITLES}/$videoId");
      var response = await http.get(Uri.parse("${ApiUrls.SUBTITLES}/$videoId"));
      print("The response => ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        SubtitleListModel subtitleListModel =
            subtitleListModelFromJson(response.body);
        return subtitleListModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Add Resources
  static Future<CommonModel> addResources(Map resourceMap) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(resourceMap);

      var response = await dio.post(ApiUrls.ADD_RESOURCES, data: formData);

      print("The add resource response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(jsonDecode(response.data));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  //Add Subtitles
  static Future<CommonModel> addSubtitles(Map subtitlesMap) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(subtitlesMap);

      var response = await dio.post(ApiUrls.ADD_SUBTITLES, data: formData);

      print("The add subtitles response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        CommonModel addCourseResponseModel =
            CommonModel.fromJson(jsonDecode(response.data));

        return addCourseResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  //Subtitles List
  static Future<WalletModel> getWallet() async {
    try {
      var response = await http.get(Uri.parse(ApiUrls.WALLET + Constants.userId));
      print("The response => ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        WalletModel model = WalletModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Add Course
  static Future<CommonModel<VideosData>> addVideo(Map videoMap) async {
    try {
      print("The video request is : $videoMap");

      var dio = Dio();
      FormData formData = FormData.fromMap(videoMap);

      var response = await dio.post(ApiUrls.ADD_VIDEO, data: formData);

      print("The video response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        final jsonData = jsonDecode(response.data);
        CommonModel<VideosData> addCourseResponseModel =
            CommonModel.fromJson(jsonData)
              ..data = VideosData.fromJson(jsonData['video']);

        return addCourseResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  //Update Profile
  static Future<AuthModel> updateProfile(Map<String, dynamic> userMap) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(userMap);

      print("The update profile request is : ${formData.toString()}");

      var response = await dio.post(ApiUrls.UPDATE_PROFILE, data: formData);

      print("The update profile response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        AuthModel authModel = AuthModel.fromJson(json.decode(response.data));

        return authModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  //Get Questions
  static Future<GetQuestionsModel> getQuestions(String videoId) async {
    try {
      var response = await http.get(Uri.parse('${ApiUrls.GET_QUESTIONS}/$videoId'));
      print("The questions response => ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        GetQuestionsModel model =
            GetQuestionsModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  //Reply Questions
  static Future<CommonModel> replyQuestions(Map userMap, String videoId) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(userMap);

      var response =
          await dio.post('${ApiUrls.REPLY_QUESTIONS}/$videoId', data: formData);

      print("The reply questions response is : ${response.data.toString()}");

      if (response != null && response.data != null && response.data != '') {
        CommonModel commonResponseModel =
            CommonModel.fromJson(json.decode(response.data));

        return commonResponseModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }

    return null;
  }

  static Future<ChatResponseModel> sendMessage(Map map) async {
    try {
      print("sendMessage map => $map");
      var dio = Dio();
      FormData formData = FormData.fromMap(map);

      var response = await dio.post(ApiUrls.SEND_MESSAGE, data: formData);
      print("sendMessage response => ${response.data}");
      if (response != null && response.data != null && response.data != '') {
        ChatResponseModel model =
            ChatResponseModel.fromJson(json.decode(response.data));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<ChatMessagesM> getAllMessages(
      String studentId, String messageId) async {
    try {
      var studentId = sharedPref.getString(Constants.USER_ID);

      var url = ApiUrls.ALL_MESSAGE + "/$studentId/$studentId/0";

      showLog("receiveMessage url ====>> $url");

      var response = await http.get(Uri.parse(url));
      print("receiveMessage response => ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        ChatMessagesM model =
            ChatMessagesM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<ChatMessagesM> recentMessage(
      String studentId, String messageId) async {
    try {
      var teacherId = Constants.sharedPreferences.getString(Constants.USER_ID);

      var url;

      if (messageId == null || messageId == "") {
        url = ApiUrls.RECEIVE_MESSAGE + "/$studentId/$teacherId";
      } else {
        url = ApiUrls.RECEIVE_MESSAGE + "/$studentId/$teacherId/$messageId";
      }

      showLog("recentMessage url ====>> $url");

      var response = await http.get(url);

      print("recentMessage response => ${response.body}");

      if (response != null && response.body != null && response.body != '') {
        ChatMessagesM model =
            ChatMessagesM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<ChatListModel> getChatList(String teacherId) async {
    try {
      var url = ApiUrls.CHAT_LIST + "/$teacherId";

      showLog("Chat list url ====>> $url");

      var response = await http.get(Uri.parse(url));
      print("Chat list response => ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        ChatListModel model =
            ChatListModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<CommonModel> sendForgotPasswordLinkToEmail(
      String emailOrMobile) async {
    try {
      Map map = {"username": emailOrMobile};

      print("sendForgotPasswordLinkToEmail map : $map");

      var response = await http.post(Uri.parse(ApiUrls.FORGOT_PASSWORD), body: map);

      print('sendForgotPasswordLinkToEmail response =====>> ${response.body}');

      if (response != null && response.body != null && response.body != '') {
        CommonModel commonModel =
            CommonModel.fromJson(json.decode(response.body));
        return commonModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<AuthModel> updateUserProfile(Map<String, dynamic> map) async {
    try {
      var dio = Dio();
      FormData formData = FormData.fromMap(map);
//      print("The update profile request is : $map");
      var response = await dio.post(ApiUrls.EDIT_PROFILE, data: formData);

//    print('updateUserProfile response ===>> ${response.data}');

      if (response != null && response.data != null && response.data != '') {
        AuthModel model = AuthModel.fromJson(json.decode(response.data));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<CommonModel> logout() async {
    try {
//      print('logout request ===>> $map');

      var response = await http.get(Uri.parse(ApiUrls.LOGOUT + "/${Constants.userId}"));

//      print('logout response ===>> ${response.body}');

      if (response != null && response.body != null && response.body != '') {
        CommonModel commonModel =
            CommonModel.fromJson(json.decode(response.body));
        return commonModel;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<AuthModel> getUserProfile() async {
    try {
      var response =
          await http.get(Uri.parse(ApiUrls.GET_PROFILE + "/${Constants.userId}"));
      print("getUserProfile response => ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        AuthModel model = AuthModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<OTPModel> sendOTP(String mobileNo) async {
    try {
      var url = ApiUrls.SEND_OTP + "/" + mobileNo;

      print('sendOTP request ===>> $url');

      var response = await http.get(Uri.parse(url));

      print('sendOTP response ===>> ${response.body}');

      if (response != null && response.body != null && response.body != '') {
        OTPModel model = OTPModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<CommonModel> addDevice(Map map) async {
    try {
//      showLog("addDevice request ====> $map");

      var response = await http.post(Uri.parse(ApiUrls.ADD_DEVICE), body: map);

//      showLog("addDevice response ====> ${response.body}");

      if (response != null && response.body != null && response.body != '') {
        CommonModel model = CommonModel.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('addDevice exception ====>>> ${e.toString()}');
    }

    return null;
  }

  static Future<StudentsM> getMyStudent(String courseId) async {

    try {

      var response;
      if(courseId == null){
        response = await http.get(Uri.parse(ApiUrls.GET_TEACHER_STUDENT + "/" + Constants.userId));
        showLog("getMyStudent request ====> " + ApiUrls.GET_TEACHER_STUDENT + "/" + Constants.userId);
      }else{
        response = await http.get(Uri.parse(ApiUrls.GET_COURSE_STUDENT + "/" + courseId));
        showLog("getMyStudent request ====> " + ApiUrls.GET_COURSE_STUDENT + "/" + courseId);
      }


      showLog("getMyStudent response ====> ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        StudentsM model = StudentsM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('getMyStudent exception ====>>> ${e.toString()}');
    }

    return null;
  }

  static Future<PayoutM> getPayoutsTypes(String type) async {
    try {
//      showLog("getPayoutsTypes request ====> $map");
      var url = ApiUrls.PENDING + "/" + Constants.userId;
      if (type == "completed") {
        url = ApiUrls.COMPLETED + "/" + Constants.userId;
      }
      var response = await http.get(Uri.parse(url));
//      showLog("getPayoutsTypes response ====> ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        PayoutM model = PayoutM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('getPayoutsTypes exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<SupportM> sendMessageForSupport(Map map) async {
    try {
      showLog("sendMessageForSupport request ====> $map");
      var response = await http.post(Uri.parse(ApiUrls.SUBMIT_SUPPORT), body: map);
      showLog("sendMessageForSupport response ====> ${response.body}");
      if (response != null && response.body != null && response.body != '') {
        SupportM model = SupportM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<TicketStatusM> checkTicketStatus(Map map) async {
    try {
      //    showLog("checkTicketStatus request ====> $map");

      var response = await http.post(Uri.parse(ApiUrls.CHECK_TICKET_STATUS), body: map);

      showLog("checkTicketStatus response ====> ${response.body}");

      if (response != null && response.body != null && response.body != '') {
        TicketStatusM model =
            TicketStatusM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('exception ====>>> ${e.toString()}');
    }
    return null;
  }

  static Future<PaymentConfigM> getConfiguration() async {
    try {
//      print("getConfiguration map : $map");
      var response = await http.post(Uri.parse(ApiUrls.PAYMENT_CONFIG));

      print('getConfiguration response =====>> ${response.body}');

      if (response != null && response.body != null && response.body != '') {
        PaymentConfigM model =
            PaymentConfigM.fromJson(json.decode(response.body));
        return model;
      }
    } catch (e) {
      print('getConfiguration exception ====>>> ${e.toString()}');
    }
    return null;
  }
}
