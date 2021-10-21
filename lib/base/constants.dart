import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String APP_NAME = 'My3Skill Teacher';
  static String deviceUUID = '';
  static String devicePlatform = '';
  static SharedPreferences sharedPreferences;

  static String USER_TOKEN = '';

  //LOADED USER
  static String userId = "";
  static String userName = "";
  static String userEmail = "";
  static String userPassword = "";
  static String userImage = "";
  static String userMobile = "";

  //USER
  static const String LANGUAGE_CODE = "LanguageCode";
  static const String USER_LOGGED_IN = "UserLoggedInFlag";
  static const String USER_ID = "UserId";
  static const String USER_NAME = "UserName";
  static const String USER_EMAIL = "UserEmail";
  static const String USER_PASSWORD = "UserPassword";
  static const String USER_IMAGE = "UserImage";
  static const String USER_MOBILE = "UserMobile";

  //Login
  static const String EMAIL = 'Email Address';
  static const String PASSWORD = "Password";
  static const String LOGIN = 'Login';
  static const String LOGIN_WITH_FACEBOOK = "Login with facebook";
  static const String LOGIN_WITH_GOOGLE = "Login with Google";
  static const String ALREADY_REGISTERED = 'Already registered? ';
  static const String REGISTER = 'Register';
  static const String OR_TEXT = " Or ";
  static const String PRIVACY_POLICY = 'Privacy Policy';
  static const String TANDC = 'T&C';
  static const String INVALID_EMAIL_ERROR = "Please enter valid email";
  static const String INVALID_PASSWORD = "Please enter valid password";
  static const String FORGOT_PASSWORD = "Forgot password?";

  //Sign up
  static const String FULL_NAME = "Full Name";
  static const String PHONE_NUMBER = "Phone Number";
  static const String SIGN_UP_WITH_GOOGLE = "Sign up with Google";
  static const String SIGN_UP_WITH_FACEBOOK = "Sign up with facebook";
  static const String ENTER_FULL_NAME = "Please enter valid full name";
  static const String ENTER_PHONE_NUMBER = "Please enter valid phone number";

  //Home screen
  static const String HOME = "Home";
  static const String FEATURED = "Featured";
  static const String SEARCH = "Search";
  static const String MY_COURSES = "My Courses";
  static const String WISH_LIST = "Wishlist";
  static const String ACCOUNT = "Account";

  //Api messages
  static const String SOMETHING_WENT_WRONG = "Something went wrong, please try again later";
  static const String SOMETHING_WENT_WRONG_CATEGORIES =
      "Something went wrong while loading categories, please restart the application";
  static const String TRUE = "true";
  static const String FALSE = "false";

  // Details screen
  static const String BUY_NOW = "Buy Now";
  static const String DESCRIPTION = "Description";
  static const String SEE_LESS = "See less...";
  static const String SEE_MORE = "See more...";
  static const String SEE_ALL = "See all";
  static const String WHAT_WILL_LEARN = "What will i learn?";
  static const String BROWSE_CATEGORIES = "Browse categories";
  static const String COURSE_INCLUDES = "This Course Includes";

  static const String STUDENTS_FEEDBACK = "Students feedback";
  static const String STUDENTS_ALSO_VIEWED = "Students also viewed";
  static const String LEARN_FIRST = "What will you learn first?";
  static const String SAVE_FOR_LATER = "Want to save something for later?";
  static const String YOUR_COURSE_GOES = "Your courses will go here.";
  static const String YOUR_WISH_LIST_GOES = "Your wishlist will go here.";

  //Add Course
  static const String COURSE_TITLE = "Course title";
  static const String COURSE_SUB_TITLE = "Course subtitle";
  static const String COURSE_DESC = "Course description";
  static const String COURSE_LEARN = "What is primarily taught in your course?";
  static const String COURSE_PRICE = "Course price";
  static const String COURSE_DAYS = "Course completion days";

  //Add Resources
  static const String RESOURCE_TITLE = "Resource title";
  static const String SUB_TITLE = "Subtitle";

  //ERRORS
  static const String COURSE_TITLE_ERROR = "Please enter the course title";
  static const String COURSE_SUB_TITLE_ERROR = "Please enter the course sub title";
  static const String COURSE_DESC_ERROR = "Please enter the course description";
  static const String LEARN_ERROR = "Please enter the things that student will learn";
  static const String PRICE_ERROR = "Please enter the course price";
  static const String DAYS_ERROR = "Please enter the course days to complete";

  static const String RESOURCE_TITLE_ERROR = "Please enter the resource title";
  static const String SUBTITLES_TITLE_ERROR = "Please enter the subtitle name";

  static const String TEACHER = "TEACHER";

  static const String TERMS_CONDITIONS = "https://www.my3skills.com/web/terms";
  static const String PRIVACY_POLICY_URL = "https://www.my3skills.com/web/privacy";
  static const String HELP_AND_FAQ_URL = "https://www.my3skills.com/web/help";

  static const String NO_INTERNET = "Network not available, please connect to internet to procceed";

  static Future<SharedPreferences> setSharedPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences;
  }

  static void loadUser() {
    if (sharedPref.getString(USER_ID) != '') {
      userId = sharedPref.getString(USER_ID) ?? '';
      userName = sharedPref.getString(USER_NAME) ?? '';
      userEmail = sharedPref.getString(USER_EMAIL) ?? '';
      userPassword = sharedPref.getString(USER_PASSWORD) ?? '';
      userImage = sharedPref.getString(USER_IMAGE) ?? '';
      userMobile = sharedPref.getString(USER_MOBILE) ?? '';
    }
  }

  static void clearUser() {
    userId = '';
    userName = '';
    userEmail = '';
    userPassword = '';
    userImage = '';
    userMobile = '';
    sharedPref.setString(USER_ID, '');
    sharedPref.setString(USER_NAME, '');
    sharedPref.setString(USER_EMAIL, '');
    sharedPref.setString(USER_PASSWORD, '');
    sharedPref.setString(USER_IMAGE, '');
    sharedPref.setString(USER_MOBILE, '');
    sharedPref.setBool(USER_LOGGED_IN, false);
  }
}
