class StepData {
  final String date;
  String dayName;
  int steps;
  int stepgoal;
  double calories;
  double caloriesgoal;
  double distance;
  double distancegoal;

  StepData(
      {required this.date,
      required this.dayName,
      required this.steps,
      required this.stepgoal,
      required this.calories,
      required this.distance,
      required this.caloriesgoal,
      required this.distancegoal});

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dayName': dayName,
      'steps': steps,
      'stepgoal': stepgoal,
      'calories': calories,
      'distance': distance,
      "caloriesgoal": caloriesgoal,
      "distancegoal": distancegoal
    };
  }

  factory StepData.fromJson(Map<String, dynamic> json) {
    return StepData(
        date: json['date'],
        dayName: json['dayName'],
        steps: json['steps'],
        stepgoal: json['stepgoal'],
        calories: json['calories'],
        distance: json['distance'],
        caloriesgoal: json["caloriesgoal"],
        distancegoal: json["distancegoal"]);
  }
}

class WeeklyStepData {
  final String weekStartDate;
  final String? weekStartDay;
  final String weekEndDate;
  final String? weekEndDay;
  final List<StepData> dailySteps;

  WeeklyStepData({
    required this.weekStartDate,
    this.weekStartDay,
    required this.weekEndDate,
    this.weekEndDay,
    required this.dailySteps,
  });

  Map<String, dynamic> toJson() {
    return {
      'weekStartDate': weekStartDate,
      'weekStartDay': weekStartDay,
      'weekEndDate': weekEndDate,
      'weekEndDay': weekEndDay,
      'dailySteps': dailySteps.map((stepData) => stepData.toJson()).toList(),
    };
  }

  factory WeeklyStepData.fromJson(Map<String, dynamic> json) {
    return WeeklyStepData(
      weekStartDate: json['weekStartDate'],
      weekStartDay: json['weekStartDay'],
      weekEndDate: json['weekEndDate'],
      weekEndDay: json['weekEndDay'],
      dailySteps: (json['dailySteps'] as List<dynamic>)
          .map((stepDataJson) => StepData.fromJson(stepDataJson))
          .toList(),
    );
  }
}

class MonthlyStepData {
  final String month;
  final List<WeeklyStepData> weeklySteps;

  MonthlyStepData({required this.month, required this.weeklySteps});

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'weeklySteps':
          weeklySteps.map((weeklyStepData) => weeklyStepData.toJson()).toList(),
    };
  }

  factory MonthlyStepData.fromJson(Map<String, dynamic> json) {
    return MonthlyStepData(
      month: json['month'],
      weeklySteps: (json['weeklySteps'] as List<dynamic>)
          .map((weeklyStepDataJson) =>
              WeeklyStepData.fromJson(weeklyStepDataJson))
          .toList(),
    );
  }
}
