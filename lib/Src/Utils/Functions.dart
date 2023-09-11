import 'dart:convert';
import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pacer/Src/Domain/Model/PlaceModel.dart';
import 'package:pacer/Src/Domain/Model/TrackModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:ui' as ui;
import '../../main.dart';
import '../Data/PlacesJson.dart';
import '../Domain/Model/DayDataModel.dart';
import 'Constants.dart';

// Function to check and request location permission
Future<bool> checkAndRequestPermissions() async {
  // Check if location permission is already granted
  var locationStatus = await Permission.location.status;

  // Check if physical activity permission is already granted
  var activityStatus = await Permission.activityRecognition.status;

  if (locationStatus.isGranted && activityStatus.isGranted) {
    // Permissions are already granted
    return true;
  } else if (locationStatus.isPermanentlyDenied) {
    // Location permission is permanently denied on this device
    openAppSettings();
    return false;
  } else if (activityStatus.isPermanentlyDenied) {
    // Location permission is permanently denied on this device
    openAppSettings();
    return false;
  } else {
    // Request location and physical activity permissions
    var locationRequest = await Permission.location.request();
    var activityRequest = await Permission.activityRecognition.request();

    if (locationRequest.isGranted && activityRequest.isGranted) {
      // Permissions granted
      return true;
    } else {
      // Permissions denied

      Future.delayed(const Duration(seconds: 2), () {
        Get.closeAllSnackbars();
        openAppSettings();
      });

      return false;
    }
  }
}

Widget getIconBasedOnStatus(String status, double height) {
  return AnimatedContainer(
      duration: const Duration(seconds: 1),
      height: height * .05,
      width: height * .05,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == "walking"
            ? AppColors.colorAccent
            : status == "running"
                ? AppColors.colorAccent
                : const Color.fromARGB(255, 16, 45, 73),
      ),
      child: Icon(
        status == "walking"
            ? Icons.directions_walk
            : status == "running"
                ? Icons.directions_run
                : Icons.person,
        size: 30,
        color: AppColors.white,
      ));
}

String getStatusText(String status) {
  return status == "walking"
      ? AppStrings.walking
      : status == "running"
          ? AppStrings.running
          : AppStrings.staticPosition;
}

String getMonthName(int month) {
  List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return monthNames[month - 1];
}

int getCurrentWeek() {
  int weekStart = DateTime.now().weekday;
  int weekIndex = ((DateTime.now().day + weekStart - 2) ~/ 7);
  return weekIndex;
}

String getDayOfWeek() {
  DateTime now = DateTime.now();
  return DateFormat('EEEE').format(now);
}

//debug log

dlog(String? title, var value) {
  d.log("${title ?? ""} : ${value.toString()}");
}

//return currentweek data
currentWeekIndex(List<WeeklyStepData> weeklySteps, DateTime currentDate) {
  int currentweekindex = 0;
  for (int i = 0; i < weeklySteps.length; i++) {
    DateTime weekstartdate = DateTime.parse(weeklySteps[i].weekStartDate);
    DateTime weekEndDate = DateTime.parse(weeklySteps[i].weekEndDate);

    dlog("weekstartdate", weekstartdate);
    dlog("currentdate", currentDate);

    dlog("========weekenddate", weekEndDate);

    if (weekstartdate.isAtSameMomentAs(currentDate) ||
        weekEndDate.isAtSameMomentAs(currentDate)) {
      currentweekindex = i;
      break;
    } else if (currentDate.isAfter(weekstartdate) &&
        currentDate.isBefore(weekEndDate)) {
      currentweekindex = i;
      break;
    } else if (weekstartdate.isBefore(currentDate)) {
      dlog("currentDate is before weekdate", "");
    }
  }

  dlog("currentweekindex", currentweekindex);
  return currentweekindex;
}

final DateTime currentDate = DateTime.now();

final currentdate =
    DateTime(currentDate.year, currentDate.month, currentDate.day);
final int currentWeekday = currentDate.weekday;
final DateTime weekStart =
    currentDate.subtract(Duration(days: currentWeekday - 1));
final DateTime weekEnd = weekStart.add(const Duration(days: 6));
final DateTime nextWeekStart = weekEnd.add(const Duration(days: 1));

currentweekstartdate() {
  return DateFormat('yyyy-MM-dd').format(weekStart);
}

currentweekenddate() {
  return DateFormat('yyyy-MM-dd').format(weekEnd);
}

currentweekstartday() {
  return DateFormat('EEEE').format(weekStart);
}

currentweekendday() {
  return DateFormat('EEEE').format(weekEnd);
}

///////////
///
///

getplacename(String name) {
  return "assets/Places/$name.png";
}

geticonfromcategory(String cat) {
  for (var item in placesjson) {
    if (item.name == cat) {
      return item.icon;
    }
  }
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

saveplacesinfile(var jsonData) async {
  List<dynamic> encodedList =
      jsonData.map((item) => json.encode(item)).toList();

  var path = "${directory!.path}/Json/Places.json";

  if (await Directory("${directory!.path}/Json").exists()) {
  } else {
    await Directory("${directory!.path}/Json").create();
  }

  if (await File(path).exists()) {
    File(path).delete();
  }

  File(path).create();
  File(path).writeAsStringSync(json.encode(encodedList));
}

Future getdatafromfile() async {
  List output = [];

  var path = "${directory!.path}/Json/Places.json";
  if (await File(path).exists()) {
    String fileContents = File(path).readAsStringSync();
    List<dynamic> decodedList = json.decode(fileContents);
    List<dynamic> myList =
        decodedList.map((item) => json.decode(item)).toList();
    dlog("", myList.length);
    output = myList;
  }

  return output.map((placejson) => PlaceModel.fromJson(placejson)).toList();
}

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = (duration.inMinutes % 60);

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

Future<void> saveTrackInFile(
    List<TrackModel> jsonData, String trackfilename) async {
  List<Map<String, dynamic>> encodedList =
      jsonData.map((item) => item.toJson()).toList();

  var path = "${directory!.path}/Tracks/$trackfilename.json";

  if (await Directory("${directory!.path}/Tracks").exists()) {
    // Directory already exists
  } else {
    await Directory("${directory!.path}/Tracks").create();
  }

  if (await File(path).exists()) {
    await File(path).delete();
  }

  await File(path).create();
  await File(path).writeAsString(json.encode(encodedList));
}

checkInternet() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

Future<Placemark> getlocfromlatlng(double lat, double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  Placemark placemark = placemarks[0];

  return placemark;
}

Future<List<File>> loadFilesFromFolder() async {
  String folderPath = '${directory!.path}/Tracks';
  Directory folder = Directory(folderPath);
  if (await folder.exists()) {
    List<File> files = [];
    await for (FileSystemEntity entity in folder.list()) {
      if (entity is File) {
        files.add(entity);
      }
    }
    return files;
  } else {
    return [];
  }
}

Future<List<TrackModel>> getTrackfromFile(String path) async {
  List<TrackModel> output = [];

  if (await File(path).exists()) {
    String fileContents = await File(path).readAsString();
    List<dynamic> decodedList = json.decode(fileContents);

    for (int i = 0; i < decodedList.length; i++) {
      output.add(TrackModel.fromJson(decodedList[i]));
    }

    return output;
  }

  return output;
}

Future<double> calculateDistance(double startLatitude, double startLongitude,
    double endLatitude, double endLongitude) async {
  double distanceInMeters = Geolocator.distanceBetween(
      startLatitude, startLongitude, endLatitude, endLongitude);
  double distanceInKm = distanceInMeters / 1000; // Convert to kilometers
  return distanceInKm;
}

Future<double> calculateDirection(double startLatitude, double startLongitude,
    double endLatitude, double endLongitude) async {
  double direction = Geolocator.bearingBetween(
      startLatitude, startLongitude, endLatitude, endLongitude);
  return direction;
}

class ScaleSize {
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2.5}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
