import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/wallet/wallet_model.dart';

class WalletProvider extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  Future<WalletModel> getTeacherWallet() async {
    if (await isNetworkConnected()) {
      setLoading(true);

      var response = await ApiData.getWallet();

      setLoading(false);

      if (response != null && response.status == Constants.TRUE) {
        return response;
      } else {
        showToast(response!=null && response.message!=null ? response.message : Constants.SOMETHING_WENT_WRONG);
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }

    return null;
  }

  setLoading(value) {
    _loading = value;
    notifyListeners();
  }
}
