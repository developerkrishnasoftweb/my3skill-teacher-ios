// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static _notInlinedMessages(_) => <String, Function>{
        "termsAndConditions": MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "enterAssociateEmail": MessageLookupByLibrary.simpleMessage(
            "Enter the email associated with your account and we will \nsend you a link to reset password"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "forgotPassword2": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "loginGoogle": MessageLookupByLibrary.simpleMessage("Login with Google"),
        "loginFacebook": MessageLookupByLibrary.simpleMessage("Login with Facebook"),
        "alreadyRegistered": MessageLookupByLibrary.simpleMessage("Already registered?"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "and": MessageLookupByLibrary.simpleMessage("and"),
        "tAndC": MessageLookupByLibrary.simpleMessage("T&C"),
        "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
        "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "emailMe": MessageLookupByLibrary.simpleMessage("Email me deal and recommendation"),
        "signUpGoogle": MessageLookupByLibrary.simpleMessage("Sign up Google"),
        "signUpFacebook": MessageLookupByLibrary.simpleMessage("Sign up Facebook"),
        "validEmail": MessageLookupByLibrary.simpleMessage("Please enter valid email"),
        "validFullname": MessageLookupByLibrary.simpleMessage("Please enter valid full name"),
        "validPassword": MessageLookupByLibrary.simpleMessage("Please enter valid password"),
        "validPhone": MessageLookupByLibrary.simpleMessage("Please enter valid phone number"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),

        "courseList": MessageLookupByLibrary.simpleMessage("Course List"),
        "notification": MessageLookupByLibrary.simpleMessage("Notifications"),
        "messages": MessageLookupByLibrary.simpleMessage("Messages"),
        "wallet": MessageLookupByLibrary.simpleMessage("M-Wallet"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "videoList": MessageLookupByLibrary.simpleMessage("Video List"),
        "sections": MessageLookupByLibrary.simpleMessage("Sections"),
        "resource": MessageLookupByLibrary.simpleMessage("RESOURCE"),
        "subtitle": MessageLookupByLibrary.simpleMessage("SUBTITLE"),
        "resourceList": MessageLookupByLibrary.simpleMessage("Resources List"),
        "subtitleList": MessageLookupByLibrary.simpleMessage("Subtitles List"),
        "noCourses": MessageLookupByLibrary.simpleMessage("No courses added."),
        "noVideos": MessageLookupByLibrary.simpleMessage("No videos added."),
        "noResources": MessageLookupByLibrary.simpleMessage("No resources added."),
        "noSubtitles": MessageLookupByLibrary.simpleMessage("No subtitles added."),
        "or": MessageLookupByLibrary.simpleMessage(" Or "),

        //addvideo
        "addVideo": MessageLookupByLibrary.simpleMessage("Add Video"),
        "courseTitle": MessageLookupByLibrary.simpleMessage("Course Title"),
        "courseDescription": MessageLookupByLibrary.simpleMessage("Description of the Course"),
        "coursePrice": MessageLookupByLibrary.simpleMessage("Course Price"),
        "discountedPrice": MessageLookupByLibrary.simpleMessage("Discounted Price"),
        "courseImage": MessageLookupByLibrary.simpleMessage("Course Image"),
        "uploadImage": MessageLookupByLibrary.simpleMessage("Upload Image"),
        "uploadSubtitle": MessageLookupByLibrary.simpleMessage("Upload Subtitle"),
        "promotionalVideo": MessageLookupByLibrary.simpleMessage("Promotional Video"),
        "uploadVideo": MessageLookupByLibrary.simpleMessage("Upload Video"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),

        //addresource
        "addResource": MessageLookupByLibrary.simpleMessage("Add resource"),
        "videoResource": MessageLookupByLibrary.simpleMessage("Video resource"),

        //addsubtitles
        "addSubtitles": MessageLookupByLibrary.simpleMessage("Add subtitles"),
        "requirements": MessageLookupByLibrary.simpleMessage("Requirements"),
        "courseIncludes": MessageLookupByLibrary.simpleMessage("Course Includes"),
        "subtitlesSmall": MessageLookupByLibrary.simpleMessage("Subtitles"),
        "videoSubtitles": MessageLookupByLibrary.simpleMessage("Video subtitle"),

        //AddCourse
        "addCourse": MessageLookupByLibrary.simpleMessage("Add Course"),
        "updateCourse": MessageLookupByLibrary.simpleMessage("Update Course"),
        "courseSubtitle": MessageLookupByLibrary.simpleMessage("Short Details"),
        "basicInfo": MessageLookupByLibrary.simpleMessage("Basic info"),
        "selectLanguage": MessageLookupByLibrary.simpleMessage("Select Language"),
        "selectLevel": MessageLookupByLibrary.simpleMessage("Select level"),
        "chooseCategory": MessageLookupByLibrary.simpleMessage("Select Category"),
        "chooseSubCategory": MessageLookupByLibrary.simpleMessage("Select Subcategory"),
        "chooseTopic": MessageLookupByLibrary.simpleMessage("Select Child Category"),
        "whatLearn": MessageLookupByLibrary.simpleMessage("What will you learn?"),
        "completionDays": MessageLookupByLibrary.simpleMessage("Course completion days"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "courseTitleError": MessageLookupByLibrary.simpleMessage("Please enter the video title"),
        "coursePositionError": MessageLookupByLibrary.simpleMessage("Please enter the video position"),
        "courseSubTitleError":
            MessageLookupByLibrary.simpleMessage("Please enter short description"),
        "courseDescError": MessageLookupByLibrary.simpleMessage("Please enter course description"),
        "whatLearnError":
            MessageLookupByLibrary.simpleMessage("Please enter the things that student will learn"),
        "coursePriceError": MessageLookupByLibrary.simpleMessage("Please enter the course price"),
        "courseDaysError":
            MessageLookupByLibrary.simpleMessage("Please enter the course days to complete"),
        "resourceTitleError":
            MessageLookupByLibrary.simpleMessage("Please enter the resource title"),
        "subTitleError": MessageLookupByLibrary.simpleMessage("Please enter the subtitle name"),

        //updateprofile
        "updateProfile": MessageLookupByLibrary.simpleMessage("Update Profile"),
        "teacherName": MessageLookupByLibrary.simpleMessage("Teacher Name"),
        "tagLine": MessageLookupByLibrary.simpleMessage("Tag-line"),
        "description": MessageLookupByLibrary.simpleMessage("Description"),
        "tags": MessageLookupByLibrary.simpleMessage("Tags"),
        "twitterUrl": MessageLookupByLibrary.simpleMessage("Twitter url"),
        "facebookUrl": MessageLookupByLibrary.simpleMessage("Facebook url"),
        "linkedInUrl": MessageLookupByLibrary.simpleMessage("LinkedIn url"),
        "youtubeUrl": MessageLookupByLibrary.simpleMessage("Youtube url"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),

        //choose language
        "chooseLanguage": MessageLookupByLibrary.simpleMessage("Choose a language"),

        //wallet
        "walletBalance": MessageLookupByLibrary.simpleMessage("M-Wallet Balance"),
        "noTransaction": MessageLookupByLibrary.simpleMessage("No Transaction"),
        "withdrawMoney": MessageLookupByLibrary.simpleMessage("Withdraw Money"),
        "depositMoney": MessageLookupByLibrary.simpleMessage("Deposit Money"),
        "closingBalance": MessageLookupByLibrary.simpleMessage("Closing balance"),

        //extra on 15/06
        "questions": MessageLookupByLibrary.simpleMessage("QUESTIONS"),
        "questionsList": MessageLookupByLibrary.simpleMessage("Questions List"),
        "noQuestions": MessageLookupByLibrary.simpleMessage("No Questions Asked"),
        "addAnswer": MessageLookupByLibrary.simpleMessage("Add answer"),
        "questionAnswer": MessageLookupByLibrary.simpleMessage("Question Answer"),
        "question": MessageLookupByLibrary.simpleMessage("Question"),
        "answer": MessageLookupByLibrary.simpleMessage("Answer"),
        "validAnswer": MessageLookupByLibrary.simpleMessage("Please enter the answer"),

        "chats": MessageLookupByLibrary.simpleMessage("Chats"),
        "noChats": MessageLookupByLibrary.simpleMessage("No chats yet."),
        "enter_message": MessageLookupByLibrary.simpleMessage("Enter a message..."),

        "noCourse": MessageLookupByLibrary.simpleMessage("No courses available."),
      };
}
