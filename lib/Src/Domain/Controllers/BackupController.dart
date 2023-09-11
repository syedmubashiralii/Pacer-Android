import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Functions.dart';
import '../DataHandlers/PreferencesData.dart';
import '../DataHandlers/StepsDatahandler.dart';
import '../Model/DayDataModel.dart';

class BackupController extends GetxController {
  //variables
  FirebaseAuth auth = FirebaseAuth.instance;
  final String users = "users";
  final String id = "id";
  final String url = "url";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxBool isloading = false.obs;
  Dio dio = Dio();

  ///functions
  Future<User?> signInWithGoogle() async {
    // auth.signOut();
    // googleSignIn.signOut();
    User? user;

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            Get.snackbar("Pacer",
                "The account already exists with a different credential.",
                backgroundColor: Colors.red, colorText: AppColors.white);
          } else if (e.code == 'invalid-credential') {
            Get.snackbar("Pacer",
                "Error occurred while accessing credentials. Try again..",
                backgroundColor: Colors.red, colorText: AppColors.white);
          }
        } catch (e) {
          Get.snackbar(
              "Pacer", "Error occurred using Google Sign-In. Try again.",
              backgroundColor: Colors.red, colorText: AppColors.white);
        }
      }
    } catch (e) {
      dlog("Exception", e);
    }

    return user;
  }

  Future storeDatainFirebase(User? user) async {
    if (user != null) {
      if (await checkIfUserDocExists()) {
        String jsonurl = await uploadJSONFile(user.uid);
        firestore.collection(users).doc(user.uid).update({url: jsonurl});
      } else {
        String jsonurl = await uploadJSONFile(user.uid);
        firestore
            .collection(users)
            .doc(user.uid)
            .set({id: user.uid, url: jsonurl});
      }
    }
  }

  Future getDatafromFirebase(User? user) async {
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await UserDoc();
      if (userDoc.exists) {
        String jsonurl = userDoc.data()?[url] ?? '';
        await downloadAndStoreJSONFile(jsonurl);
      } else {
        Get.closeAllSnackbars();
        Get.snackbar("Pacer", "Backup not Found",
            backgroundColor: Colors.red, colorText: AppColors.white);
      }
    }
  }

  Future<String> uploadJSONFile(String uid) async {
    // Get a reference to the storage bucket
    final firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child('json_files');

    final filePath =
        await StepDataManager().getDataFilePath(StepDataManager().dataFileName);

    // Read the JSON file content
    File jsonFile = File(filePath);
    String jsonString = await jsonFile.readAsString();

    // Upload the JSON data as a file
    final firebase_storage.UploadTask uploadTask =
        storageReference.child("$uid.json").putString(jsonString);

    // Wait for the upload to complete and get the download URL
    final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    print("File uploaded. Download URL: $downloadUrl");

    return downloadUrl;
  }

  Future<void> downloadAndStoreJSONFile(String fileUrl) async {
    dlog("url", fileUrl);
    // Fetch the JSON file from the URL
    var response = await dio.get(fileUrl);
    String jsonString = response.data;

    // Get the external storage directory
    final filePath =
        await StepDataManager().getDataFilePath(StepDataManager().dataFileName);

    // Write the JSON data to the external storage
    File jsonFile = File(filePath);
    await jsonFile.writeAsString(jsonString);

    List<MonthlyStepData> stepdatalist = await StepDataManager().loadStepData();
    AppSharedPreferences.setCurrentDate(
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
    AppSharedPreferences.setsteps(getTodaySteps(stepdatalist));

    int getsteps = await AppSharedPreferences.getsteps();
    dlog("getsteps", getsteps);
    Get.closeAllSnackbars();
    Get.snackbar("Pacer", "You Have to restart app after restoring data",
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  Future<bool> checkIfUserDocExists() async {
    await auth.currentUser!.reload();
    final userDoc =
        await firestore.collection(users).doc(auth.currentUser!.uid).get();
    return userDoc.exists;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> UserDoc() async {
    await auth.currentUser!.reload();
    final userDoc =
        await firestore.collection(users).doc(auth.currentUser!.uid).get();
    return userDoc;
  }

  int getTodaySteps(List stepDataList) {
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
      int steps = stepDataList[currentDate.month - 1]
          .weeklySteps[weekIndex]
          .dailySteps[dayIndex]
          .steps;
      dlog("steps", steps);
      return steps;
    } else {
      return 0;
    }
  }
}
