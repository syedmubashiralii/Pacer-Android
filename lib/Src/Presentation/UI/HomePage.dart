import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pacer/Src/Domain/Controllers/AdsController.dart';
import 'package:pacer/Src/Domain/Controllers/HomeController.dart';
import 'package:pacer/Src/Domain/Controllers/TrackController.dart';
import 'package:pacer/Src/Domain/DataHandlers/PreferencesData.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:pacer/Src/Utils/Drawer.dart';
import '../../../main.dart';
import '../../Utils/Dialogs.dart';
import '../../Utils/Widgets.dart';
import 'Pages/Goalpage.dart';
import 'Pages/HistoryPage.dart';
import 'Pages/Performancepage.dart';
import 'Pages/Trackpage.dart';
import 'Pages/WidgetsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController homecontroller = Get.put(HomeController());
  final AdsController adscontroller = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    initservice();
  }

  initservice() {
    Future.delayed(const Duration(seconds: 2), () async {
      WidgetsFlutterBinding.ensureInitialized();
    });
  }

  TrackController trackController = Get.find();
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
                  height: adscontroller.ishomepagebannerloaded.value
                      ? height * .08
                      : height * .025,
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: adscontroller.ishomepagebannerloaded.value
                      ? AdWidget(ad: adscontroller.homepagebanner)
                      : const Text("Advertisment"),
                );
              })),
          backgroundColor: AppColors.backgroundcolor,
          body: Obx(() {
            return Scaffold(
              key: _scaffoldKey,
              extendBodyBehindAppBar: false,
              drawer: CustomDrawer(),
              body:
                  //  GestureDetector(
                  //   behavior: HitTestBehavior.translucent,
                  //   onHorizontalDragEnd: (DragEndDetails details) {
                  //     if (details.primaryVelocity! > 0) {
                  //       log("swipe right");
                  //       if (homecontroller.currentpage.value == 0) {
                  //       } else {
                  //         homecontroller.swipe(homecontroller.currentpage.value - 1);
                  //       }
                  //       log(homecontroller.currentpage.value.toString());
                  //       // User swiped Left
                  //     } else if (details.primaryVelocity! < 0) {
                  //       if (homecontroller.currentpage.value == 4) {
                  //       } else {
                  //         homecontroller.swipe(homecontroller.currentpage.value + 1);
                  //       }
                  //       log("swipe left");
                  //       // User swiped Right
                  //     }
                  //   },
                  // child:
                  Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppImages.homebgimg),
                              fit: BoxFit.fill)),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () =>
                                        _scaffoldKey.currentState!.openDrawer(),
                                    icon: const Icon(
                                      Icons.menu,
                                      color: AppColors.white,
                                      size: 32,
                                    )),
                                Text(
                                  homecontroller.currentpage.value == 0
                                      ? "widgets".tr
                                      : homecontroller.currentpage.value == 1
                                          ? "track".tr
                                          : homecontroller.currentpage.value ==
                                                  2
                                              ? "performance".tr
                                              : homecontroller
                                                          .currentpage.value ==
                                                      3
                                                  ? "goal".tr
                                                  : "history".tr,
                                  style: AppTextStyles.homeappbartextstyle,
                                ),
                                homecontroller.currentpage.value == 0
                                    ? const SizedBox(
                                        width: 50,
                                      )
                                    : homecontroller.currentpage.value == 1
                                        ? InkWell(
                                            onTap: () async {
                                              showCustomOptionsPopupMenu(
                                                context,
                                                [
                                                  AppStrings.startTracking,
                                                  AppStrings.pauseTracking,
                                                  AppStrings.stopTracking,
                                                ],
                                                [
                                                  () {
                                                    if (homecontroller
                                                            .trackingenumval
                                                            .value !=
                                                        TrackingEnum.tracking) {
                                                      if (homecontroller
                                                              .trackingenumval
                                                              .value ==
                                                          TrackingEnum.paused) {
                                                        trackfilename =
                                                            AppSharedPreferences
                                                                .gettrackname();
                                                      } else {
                                                        trackController
                                                            .tracklist
                                                            .value = [];
                                                        trackfilename = DateTime
                                                                .now()
                                                            .toIso8601String();
                                                        AppSharedPreferences
                                                            .settrackname(
                                                                trackfilename);
                                                      }

                                                      AppSharedPreferences
                                                          .settrackstate(
                                                              "tracking");
                                                      homecontroller
                                                          .changetrackenum(
                                                              TrackingEnum
                                                                  .tracking);
                                                    }
                                                  },
                                                  () {
                                                    if (homecontroller
                                                            .trackingenumval
                                                            .value !=
                                                        TrackingEnum.paused) {
                                                      if (homecontroller
                                                              .trackingenumval
                                                              .value ==
                                                          TrackingEnum
                                                              .tracking) {
                                                        homecontroller
                                                            .changetrackenum(
                                                                TrackingEnum
                                                                    .paused);
                                                        AppSharedPreferences
                                                            .settrackstate(
                                                                "paused");
                                                      } else {
                                                        Get.snackbar(
                                                            AppStrings.appName,
                                                            "Please Start Tracking First then pause it");
                                                      }
                                                    }
                                                  },
                                                  () {
                                                    if (homecontroller
                                                            .trackingenumval
                                                            .value !=
                                                        TrackingEnum
                                                            .nottracking) {
                                                      trackController
                                                          .tracklist.value = [];
                                                      homecontroller
                                                          .changetrackenum(
                                                              TrackingEnum
                                                                  .nottracking);
                                                      AppSharedPreferences
                                                          .settracksteps(0);
                                                      homecontroller
                                                          .tracksteps.value = 0;

                                                      homecontroller
                                                          .trackcalories
                                                          .value = 0.0;
                                                      homecontroller
                                                          .trackdistance
                                                          .value = 0.0;

                                                      AppSharedPreferences
                                                          .savetrackStoredDuration(
                                                              const Duration(
                                                                  seconds: 0));
                                                      AppSharedPreferences
                                                          .settrackstate(
                                                              "nottracking");
                                                    }
                                                  },
                                                ],
                                              );
                                            },
                                            child: CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    AppColors.blueLight,
                                                child: Icon(
                                                  Icons.power_settings_new,
                                                  color: homecontroller
                                                              .trackingenumval
                                                              .value ==
                                                          TrackingEnum.tracking
                                                      ? Colors.green
                                                      : homecontroller
                                                                  .trackingenumval
                                                                  .value ==
                                                              TrackingEnum
                                                                  .paused
                                                          ? AppColors.orangeDark
                                                          : AppColors.red,
                                                  size: 26,
                                                )))
                                        : homecontroller.currentpage.value == 2
                                            ? const SizedBox(
                                                width: 50,
                                              )
                                            : homecontroller
                                                        .currentpage.value ==
                                                    3
                                                ? InkWell(
                                                    onTap: () async {
                                                      await homecontroller
                                                          .saveGoalData1();
                                                    },
                                                    child: const CircleAvatar(
                                                        radius: 22,
                                                        backgroundColor: AppColors
                                                            .colorPrimaryDark,
                                                        child: Icon(
                                                          Icons.done,
                                                          color:
                                                              AppColors.white,
                                                        )),
                                                  )
                                                : const SizedBox(
                                                    width: 50,
                                                  )
                              ],
                            ),
                          ),
                          Expanded(
                            child: homecontroller.currentpage.value == 0
                                ? const WidgetsPage()
                                : homecontroller.currentpage.value == 1
                                    ? const Trackpage()
                                    : homecontroller.currentpage.value == 2
                                        ? const Performancepage()
                                        : homecontroller.currentpage.value == 3
                                            ? const Goalpage()
                                            : const HistoryPage(),
                          ),
                        ],
                      )),
              // ),
            );
          }),
          bottomNavigationBar: Container(
            height: height * .1,
            color: Colors.transparent,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: AppColors.backgroundcolor,
                      height: height * .04,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: const Color.fromARGB(255, 11, 36, 58),
                      height: height * .06,
                    ),
                  ],
                ),
                Obx(() {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        color: Colors.transparent,
                        height: height * .1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppWigets.textwidget(
                                "\n${"widgets".tr}",
                                homecontroller.currentpage.value == 0
                                    ? AppColors.colorAccent
                                    : Colors.white, () {
                              analytics.logEvent(
                                name: 'widgets_tab_clicked',
                                parameters: {
                                  'languageselected': selectedlanguage,
                                  'date': DateTime.now().toString(),
                                  'action': 'click'
                                },
                              );
                              homecontroller.currentpage.value = 0;
                              homecontroller.swipe(0);
                            }),
                            AppWigets.textwidget(
                                "\n${"track".tr}",
                                homecontroller.currentpage.value == 1
                                    ? AppColors.colorAccent
                                    : Colors.white, () {
                              analytics.logEvent(
                                name: 'track_tab_clicked',
                                parameters: {
                                  'languageselected': selectedlanguage,
                                  'date': DateTime.now().toString(),
                                  'action': 'click'
                                },
                              );
                              homecontroller.currentpage.value = 1;
                              homecontroller.swipe(1);
                            }),
                            InkWell(
                              onTap: () {
                                analytics.logEvent(
                                  name: 'performance_tab_clicked',
                                  parameters: {
                                    'languageselected': selectedlanguage,
                                    'date': DateTime.now().toString(),
                                    'action': 'click'
                                  },
                                );
                                homecontroller.currentpage.value = 2;
                                homecontroller.swipe(2);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(bottom: 8),
                                height: height * .1,
                                width: height * .1,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: homecontroller.currentpage.value == 2
                                        ? AppColors.colorAccent
                                        : const Color.fromARGB(255, 11, 36, 58),
                                    border: Border.all(
                                        color: AppColors.backgroundcolor,
                                        width:
                                            homecontroller.currentpage.value ==
                                                    2
                                                ? 0.0
                                                : 2.0)),
                                child: Image.asset(AppImages.shoesimg),
                              ),
                            ),
                            AppWigets.textwidget(
                                "\n${"goal".tr}",
                                homecontroller.currentpage.value == 3
                                    ? AppColors.colorAccent
                                    : Colors.white, () {
                              analytics.logEvent(
                                name: 'goal_tab_clicked',
                                parameters: {
                                  'languageselected': selectedlanguage,
                                  'date': DateTime.now().toString(),
                                  'action': 'click'
                                },
                              );
                              homecontroller.swipe(3);
                            }),
                            AppWigets.textwidget(
                                "\n${"history".tr}",
                                homecontroller.currentpage.value == 4
                                    ? AppColors.colorAccent
                                    : Colors.white, () {
                              analytics.logEvent(
                                name: 'history_tab_clicked',
                                parameters: {
                                  'languageselected': selectedlanguage,
                                  'date': DateTime.now().toString(),
                                  'action': 'click'
                                },
                              );
                              homecontroller.swipe(4);
                            }),
                          ],
                        ),
                      )
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
