import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pacer/Src/Utils/Functions.dart';
import '../Model/ChartDataModel.dart';
import '../Model/DayDataModel.dart';

class HistoryController extends GetxController {
  RxDouble maxheight = 150.0.obs;
  RxDouble caloriesburnt = 0.0.obs;

  RxInt stepstaken = 0.obs;
  RxDouble distancecovered = 0.0.obs;
  RxDouble averagecaloriesburnt = 0.0.obs;
  RxString historytype = "Weekly".obs;
  List historytypelist = ['daily'.tr, 'weekly'.tr, 'monthly'.tr, 'yearly'.tr];
  RxString currentyear = ''.obs;

  WeeklyStepData currentWeekData = WeeklyStepData(
      weekStartDate: currentweekstartdate(),
      weekEndDate: currentweekenddate(),
      weekEndDay: currentweekendday(),
      weekStartDay: currentweekstartday(),
      dailySteps: []);

  MonthlyStepData currentmonthlydata =
      MonthlyStepData(month: "", weeklySteps: []);

  RxString currentmonth = "".obs;
  RxString weekstartdate = "".obs;
  RxInt currentmonthindex = 0.obs;
  RxInt selectedmonthindex = 0.obs;
  RxString weekenddate = "".obs;
  RxList<ChartDataModel> datax = <ChartDataModel>[].obs;
  RxList<ChartDataModel> datay = <ChartDataModel>[].obs;
  RxInt currentweekindex = 0.obs;
  RxInt selectedweekindex = 0.obs;
  RxInt iconindex = 0.obs;

  RxInt historytypeindex = 1.obs;

  List icons = [
    'assets/images/fire.png',
    "assets/images/foot_steps.PNG",
    'assets/images/distance_roadview.PNG'
  ];
  changehistorytype(int hindex) => historytypeindex.value = hindex;

  changehistoryicon(int index) => iconindex.value = index;

  chnageselectedweekindex(int i) => selectedweekindex.value = i;

  changeselectedmonthindex(int i) => selectedmonthindex = i.obs;

  changeyear(String value) => currentyear.value = value;

  @override
  void onInit() {
    super.onInit();
    datax.value = [];
    datay.value = [];
  }

  ///////weekly history data
  ///============================================================================
  ///=============================================================================
  WeeklyStepData currentweekdata(
      List<MonthlyStepData> stepDataList, int weekindex) {
    datax.value = [];
    datay.value = [];
    maxheight.value = 5;
    if (stepDataList.isNotEmpty) {
      var dt = DateTime.now();

      final currentDate = DateTime(dt.year, dt.month, dt.day);

      currentWeekData =
          stepDataList[currentDate.month - 1].weeklySteps[weekindex];
    }
    double cal = 0.0;
    int step = 0;
    double distance = 0.0;
    for (int i = 0; i < currentWeekData.dailySteps.length; i++) {
      final dayName = currentWeekData.dailySteps[i].dayName;
      ////max
      maxheight.value = max(
          maxheight.value,
          iconindex.value == 0
              ? currentWeekData.dailySteps[i].calories
              : iconindex.value == 1
                  ? double.parse(currentWeekData.dailySteps[i].steps.toString())
                  : currentWeekData.dailySteps[i].distance);
      maxheight.value = max(
          maxheight.value,
          iconindex.value == 0
              ? currentWeekData.dailySteps[i].caloriesgoal
              : iconindex.value == 1
                  ? double.parse(
                      currentWeekData.dailySteps[i].stepgoal.toString())
                  : currentWeekData.dailySteps[i].distancegoal);

      ///////////////////////////////////////////max
      datax.add(ChartDataModel(
          dayName.substring(0, 3),
          iconindex.value == 0
              ? currentWeekData.dailySteps[i].calories
              : iconindex.value == 1
                  ? double.parse(currentWeekData.dailySteps[i].steps.toString())
                  : currentWeekData.dailySteps[i].distance));
      datay.add(ChartDataModel(
          dayName.substring(0, 3),
          iconindex.value == 0
              ? currentWeekData.dailySteps[i].caloriesgoal
              : iconindex.value == 1
                  ? double.parse(
                      currentWeekData.dailySteps[i].stepgoal.toString())
                  : currentWeekData.dailySteps[i].distancegoal));
      cal = cal + currentWeekData.dailySteps[i].calories;
      step = step + currentWeekData.dailySteps[i].steps;
      distance = distance + currentWeekData.dailySteps[i].distance;
    }

    maxheight.value = maxheight.value + 10;
    caloriesburnt.value = double.parse(cal.toStringAsFixed(2));
    stepstaken.value = step;
    distancecovered.value = double.parse(distance.toStringAsFixed(2));
    averagecaloriesburnt.value = double.parse(
        (caloriesburnt.value / currentWeekData.dailySteps.length)
            .toStringAsFixed(2));
    return currentWeekData;
  }

  ///////monthly history data
  ///============================================================================
  ///=============================================================================
  ///
  ///

  montlyhistorydata(List<MonthlyStepData> stepDataList, int selectedmonth) {
    datax.value = [];
    datay.value = [];
    maxheight.value = 5;
    if (stepDataList.isNotEmpty) {
      currentmonthlydata = stepDataList[selectedmonth];
    }
    double cal = 0.0;
    int step = 0;
    double distance = 0.0;
    for (int i = 0; i < currentmonthlydata.weeklySteps.length; i++) {
      List<StepData> weekdata = currentmonthlydata.weeklySteps[i].dailySteps;

      for (int j = 0; j < weekdata.length; j++) {
        ////max
        maxheight.value = max(
            maxheight.value,
            iconindex.value == 0
                ? weekdata[j].calories
                : iconindex.value == 1
                    ? double.parse(weekdata[j].steps.toString())
                    : weekdata[j].distance);
        maxheight.value = max(
            maxheight.value,
            iconindex.value == 0
                ? weekdata[j].caloriesgoal
                : iconindex.value == 1
                    ? double.parse(weekdata[j].stepgoal.toString())
                    : weekdata[j].distancegoal);

        ///////////////////////////////////////////max
        datax.add(ChartDataModel(
            DateFormat('dd').format(DateTime.parse(weekdata[j].date)),
            iconindex.value == 0
                ? weekdata[j].calories
                : iconindex.value == 1
                    ? double.parse(weekdata[j].steps.toString())
                    : weekdata[j].distance));
        datay.add(ChartDataModel(
            DateFormat('dd').format(DateTime.parse(weekdata[j].date)),
            iconindex.value == 0
                ? weekdata[j].caloriesgoal
                : iconindex.value == 1
                    ? double.parse(weekdata[j].stepgoal.toString())
                    : weekdata[j].distancegoal));
        cal = cal + weekdata[j].calories;
        step = step + weekdata[j].steps;
        distance = distance + weekdata[j].distance;
      }
    }
    caloriesburnt.value = double.parse(cal.toStringAsFixed(2));
    stepstaken.value = step;
    distancecovered.value = double.parse(distance.toStringAsFixed(2));
    averagecaloriesburnt.value = double.parse(
        (caloriesburnt.value / currentWeekData.dailySteps.length)
            .toStringAsFixed(2));
    maxheight.value = maxheight.value + 10;
  }

  ///////yearly history data
  ///============================================================================
  ///=============================================================================
  ///
  yearlyHistoryData() {
    if (int.parse(currentyear.value.toString()).isEqual(DateTime.now().year)) {
      dlog("same", "same");
    }
  }

  Map<String, dynamic> calculateYearlyAggregates(
      List<MonthlyStepData> yearlyData) {
    datax.value = [];
    datay.value = [];
    maxheight.value = 5;
    Map<String, dynamic> yearlyAggregates = {};
    double cal = 0.0;
    int step = 0;
    double distance = 0.0;
    for (var monthlyData in yearlyData) {
      String month = monthlyData.month;
      int totalSteps = 0;
      double totalCalories = 0.0;
      double totalDist = 0.0;
      int stepGoal = 0;
      double caloriesGoal = 0.0;
      double distanceGoal = 0.0;

      for (var weeklyData in monthlyData.weeklySteps) {
        for (var dailySteps in weeklyData.dailySteps) {
          totalSteps += dailySteps.steps;
          totalCalories += dailySteps.calories;
          totalDist += dailySteps.distance;
          stepGoal += dailySteps.stepgoal;
          caloriesGoal += dailySteps.caloriesgoal;
        }
      }
      datax.add(ChartDataModel(
          getMonthName(DateTime.parse(month).month).substring(0, 3),
          iconindex.value == 0
              ? totalCalories
              : iconindex.value == 1
                  ? double.parse(totalSteps.toString())
                  : totalDist));
      datay.add(ChartDataModel(
          getMonthName(DateTime.parse(month).month).substring(0, 3),
          iconindex.value == 0
              ? caloriesGoal
              : iconindex.value == 1
                  ? double.parse(stepGoal.toString())
                  : distanceGoal));
      cal = cal + totalCalories;
      step = step + totalSteps;
      distance = distance + totalDist;

      maxheight.value = max(
          maxheight.value,
          iconindex.value == 0
              ? totalCalories
              : iconindex.value == 1
                  ? double.parse(totalSteps.toString())
                  : totalDist);
      maxheight.value = max(
          maxheight.value,
          iconindex.value == 0
              ? caloriesGoal
              : iconindex.value == 1
                  ? double.parse(stepGoal.toString())
                  : distanceGoal);
      caloriesburnt.value = double.parse(cal.toStringAsFixed(2));
      stepstaken.value = step;
      distancecovered.value = double.parse(distance.toStringAsFixed(2));
      averagecaloriesburnt.value = double.parse(
          (caloriesburnt.value / currentWeekData.dailySteps.length)
              .toStringAsFixed(2));
      yearlyAggregates[month] = {
        'totalSteps': totalSteps,
        'totalCalories': totalCalories,
      };
    }

    return yearlyAggregates;
  }
}
