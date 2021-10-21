class ApiUrls {
  //Base url
  static const String BASE_URL = 'https://www.my3skills.com/services';

  //Images url
  static const String IMAGE_URL = 'https://www.my3skills.com/';

  //Login
  static const String LOGIN = '$BASE_URL/login_teacher';

  //Logout
  static const String LOGOUT = '$BASE_URL/logout_teacher';

  //Register
  static const String REGISTER = '$BASE_URL/register_teacher';

  //Forget Password
  static const String FORGET_PASSWORD = '$BASE_URL/forget_password_teacher';

  //Courses list
  static const String COURSES_LIST = '$BASE_URL/get_course_teacher';

  //Categories
  static const String CATEGORIES = '$BASE_URL/get_categories';

  //Sub Categories
  static const String SUB_CATEGORIES = '$BASE_URL/get_subcategories';

  //Topics
  static const String TOPICS = '$BASE_URL/get_topics';

  //Add Course
  static const String ADD_COURSE = '$BASE_URL/add_course';

  // Edit Course
  static const String UPDATE_COURSE = '$BASE_URL/update_course';

  // Delete Course
  static const String DELETE_COURSE = '$BASE_URL/delete_course';

  //Videos List
  static const String VIDEOS = '$BASE_URL/get_course_videos';

  // Course section
  static const String COURSE_SECTION = '$BASE_URL/get_course_sections';

  //Resources List
  static const String RESOURCES = '$BASE_URL/get_resource';

  //Subtitles List
  static const String SUBTITLES = '$BASE_URL/get_subtitle';

  //Add Subtitles
  static const String ADD_SUBTITLES = '$BASE_URL/add_subtitle';

  //Add Resources
  static const String ADD_RESOURCES = '$BASE_URL/add_resource';

  //Add Sections
  static const String ADD_SECTION = '$BASE_URL/add_section';

  //Update Sections
  static const String UPDATE_SECTION = '$BASE_URL/update_section';

  //Delete Sections
  static const String DELETE_SECTION = '$BASE_URL/delete_section';

  //Add Video
  static const String ADD_VIDEO = '$BASE_URL/add_course_video';

  //Social login
  static const String SOCIAL_LOGIN = '$BASE_URL/social_login_teacher';

  //Wallet
  static const String WALLET = '$BASE_URL/get_teacher_wallet/';

  //Update Profile
  static const String UPDATE_PROFILE = '$BASE_URL/profile_teacher';

  //Get Questions
  static const String GET_QUESTIONS = '$BASE_URL/get_questions';

  //Reply Questions
  static const String REPLY_QUESTIONS = '$BASE_URL/reply_question';

  //Chat
  static const String SEND_MESSAGE = '$BASE_URL/send_message';
  static const String RECEIVE_MESSAGE = '$BASE_URL/get_recent_messages';
  static const String ALL_MESSAGE = '$BASE_URL/get_messages';
  static const String CHAT_LIST = '$BASE_URL/get_chat_list';
  static const String FORGOT_PASSWORD = '$BASE_URL/forget_teacher_password';

  static const String GET_PROFILE = '$BASE_URL/get_teacher_profile';
  static const String EDIT_PROFILE = '$BASE_URL/profile_teacher';

  //Topics
  static const String LANGUAGES = '$BASE_URL/get_languages';

  static const String ADD_DEVICE = '$BASE_URL/confirm_teacher_login';
  static const String SEND_OTP = '$BASE_URL/check_mobile_teacher';

  static const String STUDENTS = '$BASE_URL/get_enrolled_student';
  static const String PENDING = '$BASE_URL/teacher_pending_payouts';
  static const String COMPLETED = '$BASE_URL/teacher_completed_payouts';

  static const String GET_TEACHER_STUDENT = '$BASE_URL/get_teacher_student';
  static const String GET_COURSE_STUDENT = '$BASE_URL/search_course_student';

  static const String SUBMIT_SUPPORT = '$BASE_URL/submit_contact';
  static const String CHECK_TICKET_STATUS = '$BASE_URL/check_ticket_status';

  static const String PAYMENT_CONFIG = '$BASE_URL/get_configuration';
}
