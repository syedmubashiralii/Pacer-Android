import 'package:pacer/Src/Utils/Constants.dart';
import 'package:pacer/Src/Utils/Functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {
  static SharedPreferences? appSharedPreferences;

  static Future initializepref() async {
    appSharedPreferences = await SharedPreferences.getInstance();
  }

  static void setCurrentDate(String currentDate) {
    appSharedPreferences!.setString(AppStrings.currentDateKey, currentDate);
  }

  static void setsteps(int steps) {
    appSharedPreferences!.setInt(AppStrings.steps, steps);
  }

  static Future getsteps() async {
    int? stepscount = appSharedPreferences!.getInt(AppStrings.steps);
    dlog("stepscount from prefs", stepscount);
    if (stepscount != null) {
      return stepscount;
    } else {
      stepscount = 0;
    }

    return stepscount;
  }

  static void settracksteps(int tracksteps) {
    appSharedPreferences!.setInt(AppStrings.tracksteps, tracksteps);
  }

  static gettracksteps() {
    int? trackstepscount = appSharedPreferences!.getInt(AppStrings.tracksteps);
    dlog("stepscount from prefs", trackstepscount);
    if (trackstepscount != null) {
      return trackstepscount;
    } else {
      trackstepscount = 0;
    }

    return trackstepscount;
  }

  static Future<void> saveStoredDuration(Duration storedDuration) async {
    await appSharedPreferences!
        .setInt(AppStrings.storedduration, storedDuration.inSeconds);
  }

  static Future<void> savetrackStoredDuration(Duration storedDuration) async {
    await appSharedPreferences!
        .setInt(AppStrings.trackstoredduration, storedDuration.inSeconds);
  }

  static Future<int?> loadStoredDuration() async {
    int seconds = appSharedPreferences!.getInt(
          AppStrings.storedduration,
        ) ??
        0;
    return seconds;
  }

  static Future<int?> loadtrackStoredDuration() async {
    int seconds = appSharedPreferences!.getInt(
          AppStrings.trackstoredduration,
        ) ??
        0;
    return seconds;
  }

  static void settrackname(String name) {
    appSharedPreferences!.setString(AppStrings.trackNameKey, name);
  }

  static String gettrackname() {
    String? trackname =
        appSharedPreferences!.getString(AppStrings.trackNameKey);
    return trackname ?? "";
  }

  ///
  static void settrackstate(String trackstate) {
    appSharedPreferences!.setString(AppStrings.trackstateKey, trackstate);
  }

  static String gettrackstate() {
    String? trackstate = appSharedPreferences!.getString(
      AppStrings.trackstateKey,
    );
    return trackstate ?? "";
  }

  static  addlanguage(String lang) async {
    appSharedPreferences!.setString(AppStrings.localelang, lang);
  }
}
