import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Utils/Functions.dart';
import '../Model/ChartDataModel.dart';
import '../Model/DayDataModel.dart';

class GoalController extends GetxController {
  RxDouble maxheight = 150.0.obs;
  RxInt selectedIndex = 0.obs;
  RxList<String> days = ["M", "T", "W", "T", "F", "S", "S"].obs;
  final tooltip = TooltipBehavior(
    enable: true,
    header: 'Day',
  );
  List<List<TextEditingController>> controllers = [];

  RxList<ChartDataModel> goaldatalist = <ChartDataModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateControllers();
    goaldatalist.value = [];
    goaldatalist.value = [
      ChartDataModel('Mon', 0),
      ChartDataModel('Tue', 0),
      ChartDataModel('Wed', 0),
      ChartDataModel('Thu', 0),
      ChartDataModel('Fri', 0),
      ChartDataModel("Sat", 0),
      ChartDataModel("Sun", 0)
    ];
  }

  change(int newIndex) {
    selectedIndex.value = newIndex;
  }

  void generateControllers() {
    for (int i = 0; i < 7; i++) {
      controllers.add(List.generate(3, (_) => TextEditingController()));
    }
    for (int i = 0; i < 7; i++) {
      controllers[i][0].text = "0.0";
      controllers[i][1].text = "0";
      controllers[i][2].text = "0.0";
    }
  }

  getcurrentweekgoal(List<MonthlyStepData> stepDataList) {
    goaldatalist.value = [];
    goaldatalist.value = [
      ChartDataModel('Mon', 0),
      ChartDataModel('Tue', 0),
      ChartDataModel('Wed', 0),
      ChartDataModel('Thu', 0),
      ChartDataModel('Fri', 0),
      ChartDataModel("Sat", 0),
      ChartDataModel("Sun", 0)
    ];
    var currentWeekData = currentweekdata(stepDataList);
    dlog("curent week", currentWeekData.weekStartDate);
    for (int i = 0; i < currentWeekData.dailySteps.length; i++) {
      final dailyStepData = currentWeekData.dailySteps[i];

      if (dailyStepData.dayName == "Monday") {
        goaldatalist[0].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[0][0].text = dailyStepData.caloriesgoal.toString();
        controllers[0][1].text = dailyStepData.stepgoal.toString();
        controllers[0][2].text = dailyStepData.distancegoal.toString();
      } else if (dailyStepData.dayName == "Tuesday") {
        goaldatalist[1].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[1][0].text = dailyStepData.caloriesgoal.toString();
        controllers[1][1].text = dailyStepData.stepgoal.toString();
        controllers[1][2].text = dailyStepData.distancegoal.toString();
      } else if (dailyStepData.dayName == "Wednesday") {
        goaldatalist[2].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[2][0].text = dailyStepData.caloriesgoal.toString();
        controllers[2][1].text = dailyStepData.stepgoal.toString();
        controllers[2][2].text = dailyStepData.distancegoal.toString();
      } else if (dailyStepData.dayName == "Thursday") {
        goaldatalist[3].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[3][0].text = dailyStepData.caloriesgoal.toString();
        controllers[3][1].text = dailyStepData.stepgoal.toString();
        controllers[3][2].text = dailyStepData.distancegoal.toString();
      } else if (dailyStepData.dayName == "Friday") {
        goaldatalist[4].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[4][0].text = dailyStepData.caloriesgoal.toString();
        controllers[4][1].text = dailyStepData.stepgoal.toString();
        controllers[4][2].text = dailyStepData.distancegoal.toString();
      } else if (dailyStepData.dayName == "Saturday") {
        goaldatalist[5].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[5][0].text = dailyStepData.caloriesgoal.toString();
        controllers[5][1].text = dailyStepData.stepgoal.toString();
        controllers[5][2].text = dailyStepData.distancegoal.toString();
      } else if (dailyStepData.dayName == "Sunday") {
        goaldatalist[6].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[6][0].text = dailyStepData.caloriesgoal.toString();
        controllers[6][1].text = dailyStepData.stepgoal.toString();
        controllers[6][2].text = dailyStepData.distancegoal.toString();
      } else {
        goaldatalist[i].y = double.parse(dailyStepData.stepgoal.toString());
        controllers[i][0].text = dailyStepData.caloriesgoal.toString();
        controllers[i][1].text = dailyStepData.stepgoal.toString();
        controllers[i][2].text = dailyStepData.distancegoal.toString();
      }

      maxheight.value = max(maxheight.value, dailyStepData.stepgoal.toDouble());
    }

    maxheight.value = maxheight.value + 50;
    // dlog("max height", maxheight);
  }

/////
  ///
  ///
  ///
  ///
  ///
  WeeklyStepData currentweekdata(List<MonthlyStepData> stepDataList) {
    WeeklyStepData currentWeekData = WeeklyStepData(
        weekStartDate: currentweekstartdate(),
        weekEndDate: currentweekenddate(),
        weekEndDay: currentweekendday(),
        weekStartDay: currentweekstartday(),
        dailySteps: []);
    if (stepDataList.isNotEmpty) {
      final dt = DateTime.now();
      final currentDate = DateTime(dt.year, dt.month, dt.day);
      currentWeekData = stepDataList[currentDate.month - 1].weeklySteps[
          currentWeekIndex(
              stepDataList[currentDate.month - 1].weeklySteps, currentDate)];
    }
    return currentWeekData;
  }
}
