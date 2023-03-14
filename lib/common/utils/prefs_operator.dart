import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/locator.dart';

class PrefsOperator {
  late SharedPreferences sharedPreferences;

  PrefsOperator() {
    sharedPreferences = locator<SharedPreferences>();
  }

  changeIntroState() {
    sharedPreferences.setBool('showIntro', false);
  }

  Future<bool> getShowState() async {
    return sharedPreferences.getBool('showIntro') ?? true;
  }
}
