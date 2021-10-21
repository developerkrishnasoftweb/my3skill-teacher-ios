class Validator {
  static bool validateText(String name) {
    if (name == '') {
      return false;
    }
    return true;
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool validatePassword(String value) {
    return value.isNotEmpty && value.length >= 6;
  }

  static bool phoneValidator(String phone) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,15}$)';
    RegExp regExp = new RegExp(pattern);
    if (phone.length == 0) {
      return false;
    } else if (!regExp.hasMatch(phone)) {
      return false;
    }
    return true;
  }
}
