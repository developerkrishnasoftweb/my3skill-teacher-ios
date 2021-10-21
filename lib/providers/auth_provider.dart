import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/forgot_password/common_model.dart';
import 'package:my3skill_teacher_ios/login/login_model.dart';
import 'package:my3skill_teacher_ios/login/otp_model.dart';
import 'package:my3skill_teacher_ios/login/social_login_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._user);

  bool _isBusy = false;

  bool get isBusy => _isBusy;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FacebookLogin facebookSignIn = FacebookLogin();

  AuthModel _user;

  AuthModel get user => _user;

  Future<AuthModel> loginUser(Map map) async {
    if (await isNetworkConnected()) {
      setBusy(true);

      var token = await _firebaseMessaging.getToken();

      map.putIfAbsent("token", () => token);

      var response = await ApiData.getLogin(map);

      _user = response;

      setUser(_user);

      setBusy(false);

      if (response != null && response.response == Constants.TRUE) {
        Constants.sharedPreferences.setBool(Constants.USER_LOGGED_IN, true);
        Constants.sharedPreferences.setString(Constants.USER_ID, response.id.toString());
        Constants.userId = response.id.toString();
        Constants.sharedPreferences.setString(Constants.USER_NAME, response.name ?? '');
        Constants.userName = response.name ?? '';
        Constants.sharedPreferences.setString(Constants.USER_EMAIL, response.email ?? '');
        Constants.userEmail = response.email ?? '';
        Constants.sharedPreferences.setString(Constants.USER_PASSWORD, response.password ?? '');
        Constants.userPassword = response.password ?? '';
        Constants.sharedPreferences.setString(Constants.USER_IMAGE, response.image ?? '');
        Constants.userImage = response.image ?? '';
        Constants.sharedPreferences.setString(Constants.USER_MOBILE, response.mobile ?? '');
        Constants.userMobile = response.mobile ?? '';

        return response;
      } else {
        showToast(response.message ?? Constants.SOMETHING_WENT_WRONG);
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  Future<UserModel> signInWithGoogle() async {
    if (await isNetworkConnected()) {
      setBusy(true);

      try {
        final googleUser = await _googleSignIn.signIn();

        if (googleUser != null) {
          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          final authResult = await _firebaseAuth.signInWithCredential(credential);

          var user = UserModel(
            uid: authResult.user.uid,
            email: authResult.user.email,
            displayName: authResult.user.displayName,
            photoUrl: authResult.user.photoURL,
            phoneNumber: authResult.user.phoneNumber,
          );

          await _googleSignIn.disconnect().then((value) => showLog("Google signed out successfully."));
          setBusy(false);
          return user;
        } else {
          setBusy(false);
          showToast("Cancelled");
        }
      } on Exception catch (e) {
        setBusy(false);
        showToast("Cancelled");
        return null;
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  Future<UserModel> signInWithFacebook() async {
    if (await isNetworkConnected()) {
      setBusy(true);
      final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          // showLog('''
          //  Logged in!

          //  Token: ${accessToken.token}
          //  User id: ${accessToken.userId}
          //  Expires: ${accessToken.expires}
          //  Permissions: ${accessToken.permissions}
          //  Declined permissions: ${accessToken.declinedPermissions}
          //  ''');

          final graphResponse = await http
              .get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${accessToken.token}'));
          final fbProfile = SocialUser.fromJson(jsonDecode(graphResponse.body));

          if (fbProfile != null) {
            print(fbProfile);
            facebookSignIn.logOut().then((value) => showLog("Facebook signed out successfully."));

            var user = UserModel(
              uid: fbProfile.id,
              email: fbProfile.email,
              displayName: fbProfile.name,
              photoUrl: fbProfile.picture.data.url,
            );

            showLog("device token ===>> ${await _firebaseMessaging.getToken()}");

            setBusy(false);

            return user;
          } else {
            showToast(Constants.SOMETHING_WENT_WRONG);
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          setBusy(false);
          showLog('Login cancelled by the user.');
          showToast("Cancelled");
          break;
        case FacebookLoginStatus.error:
          showLog('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          setBusy(false);
          showToast("${result.errorMessage}");
          break;
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  Future<AuthModel> registerUser(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      setBusy(true);
      var token = await _firebaseMessaging.getToken();

      map.putIfAbsent("token", () => token);
      var response = await ApiData.getRegistration(map);

      setBusy(false);

      return response;

      // if (response != null && response.response == Constants.TRUE) {
      //   // setUser(response);
      //   // sharedPref.setBool(Constants.USER_LOGGED_IN, true);
      //   // sharedPref.setString(Constants.USER_ID, response.id.toString());
      //   // Constants.userId = response.id.toString();
      //   // sharedPref.setString(Constants.USER_NAME, response.name ?? '');
      //   // Constants.userName = response.name ?? '';
      //   // sharedPref.setString(Constants.USER_EMAIL, response.email ?? '');
      //   // Constants.userEmail = response.email ?? '';
      //   // sharedPref.setString(Constants.USER_PASSWORD, response.password ?? '');
      //   // Constants.userPassword = response.password ?? '';
      //   // sharedPref.setString(Constants.USER_IMAGE, response.image ?? '');
      //   // Constants.userImage = response.image ?? '';
      //   // sharedPref.setString(Constants.USER_MOBILE, response.mobile ?? '');
      //   // Constants.userMobile = response.mobile ?? '';
      //
      //   return response;
      // } else {
      //   showToast(response != null ? response.message : Constants.SOMETHING_WENT_WRONG);
      // }
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  Future<AuthModel> socialLogin(Map map) async {
    if (await isNetworkConnected()) {
      setBusy(true);
      var response = await ApiData.socialLogin(map);

      _user = response;

      showLog("response in provider ===>> ${response.toJson()}");

      setBusy(false);

      if (response != null && response.status == Constants.TRUE) {
        sharedPref.setBool(Constants.USER_LOGGED_IN, true);
        sharedPref.setString(Constants.USER_ID, response.id.toString());
        Constants.userId = response.id.toString();
        sharedPref.setString(Constants.USER_NAME, response.name ?? '');
        Constants.userName = response.name ?? '';
        sharedPref.setString(Constants.USER_EMAIL, response.email ?? '');
        Constants.userEmail = response.email ?? '';
        sharedPref.setString(Constants.USER_IMAGE, response.image ?? '');
        Constants.userImage = response.image ?? '';
        sharedPref.setString(Constants.USER_MOBILE, response.mobile ?? '');
        Constants.userMobile = response.mobile ?? '';
        return response;
      } else {
        showToast(response.message ?? Constants.SOMETHING_WENT_WRONG);
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  Future<AuthModel> getUserProfile() async {
    if (await isNetworkConnected()) {
      setBusy(true);
      var response = await ApiData.getUserProfile();
      if (response != null) {
        setUser(response);
      }
      setBusy(false);
      return response;
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  Future<AuthModel> updateUserProfile(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      setBusy(true);

      var response = await ApiData.updateUserProfile(map);

      sharedPref.setString(Constants.TEACHER, jsonEncode(response));

      _user = response;

      setBusy(false);

      showToast(response.message ?? Constants.SOMETHING_WENT_WRONG);
      return response;
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  Future<CommonModel> logout() async {
    if (await isNetworkConnected()) {
      setBusy(true);

      var response = await ApiData.logout();

      setBusy(false);
      return response;
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  Future<OTPModel> sendOTP(String mobileNo) async {
    if (await isNetworkConnected()) {
      var response = await ApiData.sendOTP(mobileNo);
      return response;
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  Future<CommonModel> addDevice(Map map) async {
    if (await isNetworkConnected()) {
      var response = await ApiData.addDevice(map);
      return response;
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  getDeviceToken() async {
    return await _firebaseMessaging.getToken();
  }

  setBusy(value) {
    _isBusy = value;
    notifyListeners();
  }

  setUser(value) {
    _user = value;
    sharedPref.setString(Constants.TEACHER, jsonEncode(_user));
    sharedPref.setString(Constants.USER_ID, _user.id.toString());
    Constants.userId = _user.id.toString();
    sharedPref.setString(Constants.USER_NAME, _user.name ?? '');
    Constants.userName = _user.name ?? '';
    sharedPref.setString(Constants.USER_EMAIL, _user.email ?? '');
    Constants.userEmail = _user.email ?? '';
    sharedPref.setString(Constants.USER_IMAGE, _user.image ?? '');
    Constants.userImage = _user.image ?? '';
    sharedPref.setString(Constants.USER_MOBILE, _user.mobile ?? '');
    Constants.userMobile = _user.mobile ?? '';
  }
}
