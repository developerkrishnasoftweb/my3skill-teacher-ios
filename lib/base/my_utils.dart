import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String formatDateMMM(String inputtedDate) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat("dd MMM yyyy");
      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in parsing date ---> $e");
      return null;
    }
  }

  static String formatTimeHH(String inputtedDate) {
    try {
      var inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      var date1 = inputFormat.parse(inputtedDate);

      var outputFormat = DateFormat("hh:mm a");
      return outputFormat.format(date1);
    } on Exception catch (e) {
      print("Error in parsing date ---> $e");
      return null;
    }
  }

  static String getMaritalStatus(String number) {
    switch (number) {
      case "0":
        return "Single";
      case "1":
        return "Married";
      default:
        return "Single";
    }
  }

  static String getGender(String number) {
    switch (number) {
      case "0":
        return "Male";
      case "1":
        return "Female";
      default:
        return "Select Gender";
    }
  }

  static String getBloodGroup(String number) {
    switch (number) {
      case "0":
        return "Male";
      case "1":
        return "Female";
      case "2":
        return "Others";
      case "3":
        return "Others";
      case "4":
        return "Others";
      case "5":
        return "Others";
      default:
        return "Select Gender";
    }
  }

  static Future<void> launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static String getCurrencySymbol(String currency) {
    switch (currency) {
      case "INR":
        return "₹";
        break;
      case "USD":
        return "\$";
        break;
      case "CNY":
        return "¥";
        break;
      default:
        return "₹";
        break;
    }
  }
}
