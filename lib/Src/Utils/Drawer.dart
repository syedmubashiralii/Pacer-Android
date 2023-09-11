// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Domain/Controllers/AdsController.dart';
import '../Domain/Controllers/BackupController.dart';
import '../Domain/Controllers/HomeController.dart';
import '../Presentation/UI/Track/TrackList.dart';
import 'Dialogs.dart';
import 'Functions.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  final BackupController backupController = Get.put(BackupController());
  final HomeController homecontroller = Get.find();
  final AdsController adsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 16, 44, 86),
              Color.fromARGB(255, 16, 44, 86),
              AppColors.backgroundcolor
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    'appName'.tr,
                    style: AppTextStyles.appnametextstyle,
                    textAlign: TextAlign.center,
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                  Text(
                    'slogan'.tr,
                    style: AppTextStyles.appslogantextstyle,
                    textAlign: TextAlign.center,
                    textScaleFactor: ScaleSize.textScaleFactor(context),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              color: AppColors.primarySlightLight,
              thickness: 1.5,
            ),
            const SizedBox(
              height: 20,
            ),
            DrawerItem(
              icon: Icons.track_changes,
              iconname: "loadtrack".tr,
              ontap: () {
                Get.to(() => const TrackListScreen());
              },
            ),
            DrawerItem(
              icon: Icons.backup,
              iconname: "backup".tr,
              ontap: () async {
                User? user = await backupController.signInWithGoogle();
                if (user != null) {
                  loadingDialog(text: "");

                  await backupController.storeDatainFirebase(user);

                  Future.delayed(const Duration(seconds: 1), () {
                    Get.back();
                    Get.snackbar(
                        AppStrings.appName, "Backup Created Successfully",
                        backgroundColor: Colors.green, colorText: Colors.white);
                  });
                }
                // dlog("Backup", "Backup");
              },
            ),
            DrawerItem(
              icon: Icons.restore,
              iconname: "restore".tr,
              ontap: () async {
                User? user = await backupController.signInWithGoogle();
                if (user != null) {
                  loadingDialog(text: "");
                  await backupController.getDatafromFirebase(user);
                  if (adsController.consentstatus == true) {
                    adsController.islandingpagebannerloaded.value = false;
                  }

                  Future.delayed(const Duration(seconds: 2), () {
                    Get.back();
                  });
                }

                // dlog("Restore", "Restore");
              },
            ),
            DrawerItem(
              icon: Icons.apps,
              iconname: "moreapps".tr,
              ontap: () {
                if (Platform.isAndroid) {
                  launchurl(Uri.parse(
                      "https://play.google.com/store/apps/dev?id=7229798272352696433&hl=en&gl=US"));
                } else {
                  launchurl(Uri.parse(
                      "https://apps.apple.com/gb/developer/ashraf-masood/id1638116619"));
                }
              },
            ),
            Visibility(
              visible: Platform.isAndroid,
              child: DrawerItem(
                icon: Icons.share,
                iconname: "shareapp".tr,
                ontap: () {
                  if (Platform.isAndroid) {
                    Share.share(
                      'Check Out this amazing fitnes App https://play.google.com/store/apps/details?id=charisma.motiondetectorpedometer.steptrackercounter&hl=en&gl=US',
                    );
                  } else {}
                },
              ),
            ),
            DrawerItem(
              icon: Icons.chat,
              iconname: "feedback".tr,
              ontap: () {
                if (Platform.isAndroid) {
                  launchurl(Uri.parse(
                      "mailto:chrismaapps@gmail.com?subject=Feedback for Pacer &body="));
                } else if (Platform.isIOS) {
                  launchurl(Uri.parse(
                      "mailto:skhastech@gmail.com?subject=Feedback for Pacer &body="));
                }
              },
            ),
            Visibility(
              visible: Platform.isAndroid,
              child: DrawerItem(
                icon: Icons.thumb_up,
                iconname: "likeus".tr,
                ontap: () {
                  if (Platform.isAndroid) {
                    launchurl(
                      Uri.parse(
                          "https://play.google.com/store/apps/details?id=charisma.motiondetectorpedometer.steptrackercounter&hl=en&gl=US"),
                    );
                  } else {}
                },
              ),
            ),
            DrawerItem(
              icon: Icons.privacy_tip,
              iconname: "privacypolicy".tr,
              ontap: () {
                if (Platform.isAndroid) {
                  launchurl(Uri.parse(
                      "https://sites.google.com/view/pacer-step-tracker/home"));
                } else {
                  launchurl(Uri.parse(
                      "https://sites.google.com/view/pacer-ios/home"));
                }
              },
            ),
            DrawerItem(
              icon: Icons.help,
              iconname: "help".tr,
              ontap: () {
                if (Platform.isIOS) {
                } else {
                  showhelpDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> launchurl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    Get.snackbar("Pacer", "No app found to launch url");
  }
}

class DrawerItem extends StatelessWidget {
  String iconname;
  IconData icon;
  VoidCallback ontap;
  DrawerItem(
      {super.key,
      required this.iconname,
      required this.icon,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppColors.white,
        ),
        title: Text(
          textScaleFactor: ScaleSize.textScaleFactor(context),
          iconname,
          style: const TextStyle(
            color: AppColors.white,
          ),
        ),
        onTap: ontap,
      ),
    );
  }
}
