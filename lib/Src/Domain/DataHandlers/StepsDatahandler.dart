import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:pacer/Src/Utils/Functions.dart';

import '../../../main.dart';
import '../Model/DayDataModel.dart';

class StepDataManager {
  final String dataFileName = '${DateTime.now().year}.json';

  Future<String> getDataFilePath(String name) async {
    var path = "${directory!.path}/Json/$name";
    return path;
  }

  Future<void> saveStepData(List<MonthlyStepData> stepDataList) async {
    final dataPath = await getDataFilePath(dataFileName);
    final jsonData =
        stepDataList.map((monthlyData) => monthlyData.toJson()).toList();
    final jsonString = jsonEncode(jsonData);
    final file = File(dataPath);
    file.createSync();
    await file.writeAsString(jsonString);
  }

  static void createFile() async {
    // Get the directory where you want to create the file
    // This might need to be replaced with the appropriate directory retrieval method

    // Specify the subdirectories you want to create
    List<String> subdirectories = ['Json', 'Tracks'];

    // Create the subdirectories if they don't exist
    for (String subdirectory in subdirectories) {
      Directory subDirectory = Directory('${directory!.path}/$subdirectory');
      if (!subDirectory.existsSync()) {
        subDirectory.createSync();
      }
    }
  }

  Future<List<MonthlyStepData>> loadStepData() async {
    final dataPath = await getDataFilePath(dataFileName);
    final file = File(dataPath);

    if (await file.exists()) {
      try {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as List<dynamic>;
        return jsonData
            .map((monthlyDataJson) => MonthlyStepData.fromJson(monthlyDataJson))
            .toList();
      } catch (e) {
        return [];
      }
    } else {
      // File doesn't exist, generate and save data
      final stepDataList = generateYearData();
      await saveStepData(stepDataList);
      return stepDataList;
    }
  }

  Future<List<MonthlyStepData>> getSpecificMonthData(String name) async {
    final dataPath = await getDataFilePath(name);
    final file = File(dataPath);
    if (await file.exists()) {
      try {
        final jsonString = await file.readAsString();
        final jsonData = jsonDecode(jsonString) as List<dynamic>;
        return jsonData
            .map((monthlyDataJson) => MonthlyStepData.fromJson(monthlyDataJson))
            .toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }
}

// Function to generate yearly step data
List<MonthlyStepData> generateYearData() {
  final currentDate = DateTime.now();
  final currentYear = currentDate.year;
  final data = <MonthlyStepData>[];

  for (int month = 1; month <= 12; month++) {
    final monthName = DateTime(currentYear, month).toString().split(' ')[0];
    final weeks = generateWeekData(currentYear, month);
    data.add(MonthlyStepData(month: monthName, weeklySteps: weeks));
  }

  return data;
}

List<WeeklyStepData> generateWeekData(int year, int month) {
  final weeks = <WeeklyStepData>[];
  final firstDayOfMonth = DateTime(year, month, 1);
  dlog("firstDayOfMonth", firstDayOfMonth);
  // final daysInMonth = DateTime(year, month + 1, 0).day;

  DateTime weekStart = firstDayOfMonth;
  while (weekStart.month == month) {
    // Calculate the date for the end of the current week (Sunday)
    var sunday = weekStart.add(Duration(days: 7 - weekStart.weekday));

    // Check if the week's end is beyond the current month
    if (sunday.month != month) {
      sunday = DateTime(month == 12 ? weekStart.year + 1 : weekStart.year,
              month == 12 ? 1 : month + 1, 1)
          .subtract(const Duration(days: 1));
    }

    final formattedWeekStart = DateFormat('yyyy-MM-dd').format(weekStart);
    final formattedWeekEnd = DateFormat('yyyy-MM-dd').format(sunday);

    final weekStartDayName = DateFormat('EEEE').format(weekStart);
    final weekEndDayName = DateFormat('EEEE').format(sunday);

    final dailySteps = generateDailyStepData(weekStart, sunday);

    weeks.add(WeeklyStepData(
      weekStartDate: formattedWeekStart,
      weekStartDay: weekStartDayName,
      weekEndDate: formattedWeekEnd,
      weekEndDay: weekEndDayName,
      dailySteps: dailySteps,
    ));

    weekStart =
        sunday.add(const Duration(days: 1)); // Start the next week from Monday
  }

  return weeks;
}

List<StepData> generateDailyStepData(DateTime startDate, DateTime endDate) {
  final days = <StepData>[];
  for (DateTime date = startDate;
      date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
      date = date.add(const Duration(days: 1))) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final dayName = DateFormat('EEEE').format(date); // Get the day name

    days.add(StepData(
        date: formattedDate,
        dayName: dayName, // Store the day name
        steps: 0,
        stepgoal: 0,
        calories: 0,
        distance: 0,
        caloriesgoal: 0,
        distancegoal: 0));
  }
  return days;
}
