import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pacer/Src/Domain/Controllers/AdsController.dart';
import 'package:pacer/Src/Domain/Controllers/GoalController.dart';
import 'package:pacer/Src/Domain/DataHandlers/PreferencesData.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:pedometer/pedometer.dart';
import '../../Utils/Functions.dart';
import '../DataHandlers/StepsDatahandler.dart';
import '../Model/DayDataModel.dart';
import 'TrackController.dart';

enum TrackingEnum { tracking, paused, nottracking }

class HomeController extends GetxController {
  Stream<PedestrianStatus>? pedestrianStatusStream;
  late Stream<StepCount> stepCountStream;
  RxBool islocationenabled = true.obs;
  final stepDataManager = StepDataManager();
  List<MonthlyStepData> stepDataList = [];
  RxBool isloading = false.obs;
  GoalController goalcont = Get.put(GoalController());
  Rx<TrackingEnum> trackingenumval = Rx<TrackingEnum>(TrackingEnum.nottracking);
  RxInt currentpage = 2.obs;
  RxInt steps = 0.obs;
  RxInt tracksteps = 0.obs;
  RxDouble distance = 0.0.obs;
  RxDouble trackdistance = 0.0.obs;
  // RxBool istracking = true.obs;
  RxInt todaystepgoal = 0.obs;
  RxDouble calories = 0.0.obs;
  RxDouble trackcalories = 0.0.obs;
  RxDouble duration = 0.0.obs;
  RxDouble percentageAchieved = 0.0.obs;
  RxString pedestraintext = getStatusText("stopped").obs;

  AdsController adsController = Get.put(AdsController());

  increment() => currentpage.value++;
  decrement() => currentpage.value--;
  changetrackenum(TrackingEnum enu) => trackingenumval.value = enu;
  swipe(int i) {
    currentpage.value = i;

    if (i == 0 || i == 1 || i == 3 || i == 4) {
      if (evenclick % 2 == 0) {
        if (adsController.consentstatus == true) {
          adsController.showperformanceintad();
        }
      }
      evenclick += 1;
    } else if (i == 2) {
      if (oddclick % 2 != 0) {
        if (adsController.consentstatus == true) {
          adsController.showperformanceintad();
        }
      }
      oddclick += 1;
    }
  }

  Rx<Duration> storedDuration = const Duration(seconds: 0, minutes: 0).obs;
  Rx<Duration> trackstoredDuration = const Duration(seconds: 0, minutes: 0).obs;

  @override
  void onInit() {
    super.onInit();

    getPrefsData();
    Future.delayed(const Duration(seconds: 1), () {
      initPlatformState();
      // loadAndDisplayData();
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (trackingenumval.value == TrackingEnum.tracking) {
        trackstoredDuration.value += const Duration(seconds: 1);
        AppSharedPreferences.savetrackStoredDuration(trackstoredDuration.value);
      }
      storedDuration.value += const Duration(seconds: 1);
      AppSharedPreferences.saveStoredDuration(storedDuration.value);
    });
  }

  Future getPrefsData() async {
    ///track prefs
    ///
    final trackstate = AppSharedPreferences.gettrackstate();

    if (trackstate != "") {
      if (trackstate == "tracking") {
        changetrackenum(TrackingEnum.tracking);
        tracksteps.value = AppSharedPreferences.gettracksteps();
        trackdistance.value = double.parse(
            (double.parse(tracksteps.value.toString()) / 1400)
                .toStringAsFixed(2));
        trackcalories.value = double.parse(
            (double.parse(tracksteps.value.toString()) / 25)
                .toStringAsFixed(2));
        int? duration = await AppSharedPreferences.loadtrackStoredDuration();
        trackstoredDuration.value = Duration(seconds: duration ?? 0);
      } else if (trackstate == "paused") {
        changetrackenum(TrackingEnum.paused);
        tracksteps.value = AppSharedPreferences.gettracksteps();
        trackdistance.value = double.parse(
            (double.parse(tracksteps.value.toString()) / 1400)
                .toStringAsFixed(2));
        trackcalories.value = double.parse(
            (double.parse(tracksteps.value.toString()) / 25)
                .toStringAsFixed(2));
        int? duration = await AppSharedPreferences.loadtrackStoredDuration();
        trackstoredDuration.value = Duration(seconds: duration ?? 0);
      } else {
        changetrackenum(TrackingEnum.nottracking);
        AppSharedPreferences.settracksteps(0);
        trackcalories.value = 0.0;
        trackdistance.value = 0.0;
        tracksteps.value = 0;
        trackstoredDuration.value = const Duration(seconds: 0);
      }
    }

    final trackname = AppSharedPreferences.gettrackname();
    if (trackname != "") {
      trackfilename = trackname;
    }

    ///other prefs
    final dateString = AppSharedPreferences.appSharedPreferences!
        .getString(AppStrings.currentDateKey);
    dlog("current date", dateString);
    if (dateString != null) {
      if (DateTime.parse(dateString).isAtSameMomentAs(
          DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now())))) {
        steps.value = await AppSharedPreferences.getsteps();

        int? duration = await AppSharedPreferences.loadStoredDuration();
        storedDuration.value = Duration(seconds: duration ?? 0);
      }
    } else {
      AppSharedPreferences.setCurrentDate(
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
      AppSharedPreferences.setsteps(0);
      AppSharedPreferences.saveStoredDuration(const Duration(seconds: 0));
      steps.value = 0;
      storedDuration.value = const Duration(seconds: 0);
    }
    Future.delayed(const Duration(seconds: 1), () {
      getpercantage();
    });
  }

  /// Handle step count changed
  void onStepCount(StepCount event) {
    if (trackingenumval.value == TrackingEnum.tracking) {
      tracksteps.value = tracksteps.value + 1;
      AppSharedPreferences.settracksteps(tracksteps.value);
      trackdistance.value = double.parse(
          (double.parse(tracksteps.value.toString()) / 1400)
              .toStringAsFixed(2));
      trackcalories.value = double.parse(
          (double.parse(tracksteps.value.toString()) / 25).toStringAsFixed(2));
    }

    todaystepgoal.value = getTodayStepGoal();
    dlog("today step goal", todaystepgoal.toString());
    DateTime timeStamp = event.timeStamp;
    steps.value = steps.value + 1;
    AppSharedPreferences.setCurrentDate(
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
    AppSharedPreferences.setsteps(steps.value);
    getpercantage();
    savestepsdata(steps.value);

    dlog("timeStamp", timeStamp);
  }

  getpercantage() {
    double stepsTaken = double.parse(steps.value.toString());
    double stepGoal = double.parse(todaystepgoal.value.toString());

    double percentage = stepGoal == 0.0 ? 100 : (stepsTaken / stepGoal) * 100;

// Ensure the percentage doesn't exceed 100
    double p = percentage > 100 ? 100 : percentage;

    percentageAchieved.value = p;
    distance.value = double.parse(
        (double.parse(steps.value.toString()) / 1400).toStringAsFixed(2));
    calories.value = double.parse(
        (double.parse(steps.value.toString()) / 25).toStringAsFixed(2));
  }

  /// Handle status changed
  void onPedestrianStatusChanged(PedestrianStatus event) {
    String status = event.status;
    DateTime timeStamp = event.timeStamp;

    dlog("status", status);
    dlog("timeStamp", timeStamp);
    pedestraintext.value = getStatusText(status);
  }

  void onPedestrianStatusError(error) {
    dlog("error=======================================================",
        error.toString());
  }

  void onStepCountError(error) {
    dlog("error=======================================================",
        error.toString());
  }

  Future<void> initPlatformState() async {
    pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    stepCountStream = Pedometer.stepCountStream;

    stepCountStream.listen(onStepCount).onError(onStepCountError);

    pedestrianStatusStream!
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);
  }

  Future<void> loadAndDisplayData() async {
    try {
      stepDataList = await stepDataManager.loadStepData();
      Future.delayed(const Duration(microseconds: 500), () {
        todaystepgoal.value = getTodayStepGoal();
      });
      dlog("todaystepgoal.toString()", todaystepgoal.toString());
    } catch (e) {
      dlog("exception", e);
    }
  }

  updateAndSaveData(List<MonthlyStepData> monthlist) async {
    await stepDataManager.saveStepData(monthlist);
  }

  saveGoalData1() async {
    var dt = DateTime.now();
    var currentDate = DateTime(dt.year, dt.month, dt.day);
    int weekindex = currentWeekIndex(
        stepDataList[currentDate.month - 1].weeklySteps, currentDate);

    int dailystepslength = stepDataList[currentDate.month - 1]
        .weeklySteps[weekindex]
        .dailySteps
        .length;
    for (int i = 0; i < dailystepslength; i++) {
      int indx = 0;

      int contindex = 0;
      String dayname = stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[i]
          .dayName;
      if (dayname == "Monday") {
        contindex = 0;
        indx = i;
      } else if (dayname == "Tuesday") {
        contindex = 1;
        indx = i;
      } else if (dayname == "Wednesday") {
        contindex = 2;
        indx = i;
      } else if (dayname == "Thursday") {
        contindex = 3;
        indx = i;
      } else if (dayname == "Friday") {
        contindex = 4;
        indx = i;
      } else if (dayname == "Saturday") {
        contindex = 5;
        indx = i;
      } else if (dayname == "Sunday") {
        contindex = 6;
        indx = i;
      }

      stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[indx]
          .caloriesgoal = double.parse(goalcont.controllers[contindex][0].text);
      stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[indx]
          .stepgoal = int.parse(goalcont.controllers[contindex][1].text);

      stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[indx]
          .distancegoal = double.parse(goalcont.controllers[contindex][2].text);
    }

    await updateAndSaveData(stepDataList);
    await goalcont.getcurrentweekgoal(stepDataList);

    Get.snackbar("Pacer", "Goal Updated Succesfully",
        backgroundColor: AppColors.backgroundcolor, colorText: AppColors.white);
  }

  saveGoalData() async {
    var dt = DateTime.now();
    var currentDate = DateTime(dt.year, dt.month, dt.day);
    int weekindex = currentWeekIndex(
        stepDataList[currentDate.month - 1].weeklySteps, currentDate);

    int dailystepslength = stepDataList[currentDate.month - 1]
        .weeklySteps[weekindex]
        .dailySteps
        .length;
    for (int i = 0; i < dailystepslength; i++) {
      int indx = 0;
      if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Monday") {
        indx = 0;
      } else if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Tuesday") {
        indx = 1;
      } else if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Wednesday") {
        indx = 2;
      } else if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Thursday") {
        indx = 3;
      } else if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Friday") {
        indx = 4;
      } else if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Saturday") {
        indx = 5;
      } else if (stepDataList[currentDate.month - 1]
              .weeklySteps[weekindex]
              .dailySteps[i]
              .dayName ==
          "Sunday") {
        indx = 6;
      }

      stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[indx]
          .caloriesgoal = double.parse(goalcont.controllers[indx][0].text);
      stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[indx]
          .stepgoal = int.parse(goalcont.controllers[indx][1].text);

      stepDataList[currentDate.month - 1]
          .weeklySteps[weekindex]
          .dailySteps[indx]
          .distancegoal = double.parse(goalcont.controllers[indx][2].text);
    }

    await updateAndSaveData(stepDataList);
    await goalcont.getcurrentweekgoal(stepDataList);

    Get.snackbar("Pacer", "Goal Updated Succesfully",
        backgroundColor: AppColors.backgroundcolor, colorText: AppColors.white);
  }

  void savestepsdata(int step) async {
    if (stepDataList.isNotEmpty) {
      var dt = DateTime.now();
      var currentDate = DateTime(dt.year, dt.month, dt.day);

      // Find the current day's data index in the weeklySteps list
      var weekIndex = currentWeekIndex(
        stepDataList[currentDate.month - 1].weeklySteps,
        currentDate,
      );

      for (int i = 0;
          i <
              stepDataList[currentDate.month - 1]
                  .weeklySteps[weekIndex]
                  .dailySteps
                  .length;
          i++) {
        String date = stepDataList[currentDate.month - 1]
            .weeklySteps[weekIndex]
            .dailySteps[i]
            .date;
        if (DateTime.parse(date).isAtSameMomentAs(currentDate)) {
          // Update the current day's data
          stepDataList[currentDate.month - 1]
              .weeklySteps[weekIndex]
              .dailySteps[i]
              .calories = double.parse((step / 25).toStringAsFixed(2));

          stepDataList[currentDate.month - 1]
              .weeklySteps[weekIndex]
              .dailySteps[i]
              .steps = step;

          stepDataList[currentDate.month - 1]
              .weeklySteps[weekIndex]
              .dailySteps[i]
              .distance = double.parse((step / 1400).toStringAsFixed(2));
        }
      }

      await updateAndSaveData(stepDataList);
    }
  }

  int getTodayStepGoal() {
    if (stepDataList.isNotEmpty) {
      var dt = DateTime.now();
      var currentDate = DateTime(dt.year, dt.month, dt.day);

      // Find the current day's data index in the weeklySteps list
      var weekIndex = currentWeekIndex(
        stepDataList[currentDate.month - 1].weeklySteps,
        currentDate,
      );
      int stepGoal = 0;
      for (int i = 0;
          i <
              stepDataList[currentDate.month - 1]
                  .weeklySteps[weekIndex]
                  .dailySteps
                  .length;
          i++) {
        String date = stepDataList[currentDate.month - 1]
            .weeklySteps[weekIndex]
            .dailySteps[i]
            .date;
        if (DateTime.parse(date).isAtSameMomentAs(currentDate)) {
          stepGoal = stepDataList[currentDate.month - 1]
              .weeklySteps[weekIndex]
              .dailySteps[i]
              .stepgoal;

          steps.value = stepDataList[currentDate.month - 1]
              .weeklySteps[weekIndex]
              .dailySteps[i]
              .steps;
        }
      }

      return stepGoal;
    } else {
      return 0;
    }
  }

  int getTodaySteps() {
    if (stepDataList.isNotEmpty) {
      var dt = DateTime.now();
      var currentDate = DateTime(dt.year, dt.month, dt.day);

      // Find the current day's data index in the weeklySteps list
      var weekIndex = currentWeekIndex(
        stepDataList[currentDate.month - 1].weeklySteps,
        currentDate,
      );

      // Find the current day's index within the dailySteps list
      int dayIndex = currentDate.weekday - 1; // Monday is 1, Sunday is 7

      // Retrieve and return the step goal for the current day
      int stepGoal = stepDataList[currentDate.month - 1]
          .weeklySteps[weekIndex]
          .dailySteps[dayIndex]
          .steps;

      return stepGoal;
    } else {
      return 0;
    }
  }
}
