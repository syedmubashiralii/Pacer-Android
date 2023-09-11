import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pacer/Src/Domain/Controllers/AdsController.dart';
import 'package:pacer/Src/Domain/Controllers/TrackController.dart';
import 'package:pacer/Src/Domain/Controllers/WidgetsController.dart';
import 'package:pacer/Src/Utils/Constants.dart';

import '../../../main.dart';
import '../../Domain/Controllers/HomeController.dart';
import '../../Domain/Controllers/OpenAdController.dart';
import '../../Domain/DataHandlers/PreferencesData.dart';
import '../../Domain/DataHandlers/StepsDatahandler.dart';
import '../../Domain/Services/NotificationService.dart';
import '../../Utils/Functions.dart';
import '../../Utils/LanguagePicker.dart';
import '../../Utils/Widgets.dart';
import 'HomePage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  final HomeController homecontroller = Get.put(HomeController());
  final WidgetsController widgetsController = Get.put(WidgetsController());
  final AdsController adscontroller = Get.put(AdsController());

  final TrackController trackController = Get.put(TrackController());
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appOpenAdManager.loadAd();
    adscontroller.createbannersize();
    adscontroller.createstartint();
    adscontroller.createperformanceint();
    Future.delayed(const Duration(milliseconds: 1200), () {
      adscontroller.createlandingpagebanner();
      adscontroller.createhomepagebanner();
    });
    homecontroller.isloading = true.obs;
    AppSharedPreferences.initializepref();
    StepDataManager.createFile();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.initializelocalnotifications();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        dlog('device token', value);
      }
    });

    homecontroller.loadAndDisplayData();
    Future.delayed(const Duration(seconds: 6), () {
      homecontroller.isloading.value = false;
    });
    if (Platform.isAndroid) {
      adscontroller.initialize_applovin();
    }
  }

  bool isPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: AppColors.backgroundcolor,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
              height: height * .08,
              child: Obx(() {
                return Container(
                  height: adscontroller.islandingpagebannerloaded.value
                      ? height * .08
                      : height * .025,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: adscontroller.islandingpagebannerloaded.value
                      ? AdWidget(ad: adscontroller.landingpagebanner)
                      : const Text("Advertisment"),
                );
              })),
          body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppImages.landingbgimg),
                      fit: BoxFit.fill)),
              child: SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1000),
                  child: _buildbody(homecontroller, adscontroller, context),
                ),
              )),
        ),
      ),
    );
  }
}

Widget _buildbody(
    HomeController homeController, AdsController adscontroller, context) {
  return Column(
    children: [
      const SizedBox(
        height: 15,
      ),
      Opacity(
        opacity: .7,
        child: Container(
          width: double.infinity,
          color: AppColors.colorPrimary,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
          child: Column(
            children: [
              // Text('appName'.tr, style: AppTextStyles.appnametextstyle,),
              // Text('slogan'.tr, style: AppTextStyles.appslogantextstyle),
              Text(
                'appName'.tr,
                style: AppTextStyles.appnametextstyle,
                textScaleFactor: ScaleSize.textScaleFactor(context),
                textAlign: TextAlign.center,
              ),
              Text(
                'slogan'.tr,
                style: AppTextStyles.appslogantextstyle,
                textScaleFactor: ScaleSize.textScaleFactor(context),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => AnimationConfiguration.synchronized(
              //     duration: const Duration(milliseconds: 300),
              //     child: FadeInAnimation(
              //       child: DialogLanguages(
              //         onLanguageSelected: setLanguage,
              //         currentLanguage: currentLanguage,
              //       ),
              //     ),
              //   ),
              // );
              languagepickerdialog(context);
            },
            child: Column(
              children: [
                Opacity(
                  opacity: .7,
                  child: CircleAvatar(
                    radius: 26 * ScaleSize.textScaleFactor(context),
                    backgroundColor: AppColors.colorPrimary,
                    child: Icon(
                      Icons.translate_rounded,
                      color: AppColors.white,
                      size: 28 * ScaleSize.textScaleFactor(context),
                    ),
                  ),
                ),
                // Text(AppStrings.language,
                //     style: AppTextStyles.languagetextstyle),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      const Spacer(),
      Obx(() {
        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: homeController.isloading.value
              ? const CircularProgressIndicator(color: AppColors.colorAccent)
              : SizedBox(
                  height: 40 * ScaleSize.textScaleFactor(context),
                  width: 150 * ScaleSize.textScaleFactor(context),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () async {
                      bool isGranted = await checkAndRequestPermissions();
                      if (isGranted) {
                        adscontroller.showstartintad();
                        analytics.logEvent(
                          name: 'Letgo_button_clicked',
                          parameters: {
                            'languageselected': selectedlanguage,
                            'date': DateTime.now().toString(),
                            'action': 'click'
                          },
                        );
                        Get.to(() => const HomePage(),
                            transition: Transition.fadeIn);
                      } else {
                        Get.snackbar(AppStrings.appName,
                            "Allow Permissions to Proceed to app",
                            colorText: AppColors.white,
                            backgroundColor: Colors.red);
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        color: AppColors.colorAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 100 * ScaleSize.textScaleFactor(context),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  'letsgo'.tr,
                                  style: AppTextStyles.letsgotextstyle,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: 24 * ScaleSize.textScaleFactor(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        );
      }),
      const SizedBox(height: 35),
    ],
  );
}
