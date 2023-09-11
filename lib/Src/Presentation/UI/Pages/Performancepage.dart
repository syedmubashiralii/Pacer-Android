// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../Domain/Controllers/HomeController.dart';
import '../../../Utils/Functions.dart';

class Performancepage extends StatefulWidget {
  const Performancepage({super.key});

  @override
  State<Performancepage> createState() => _PerformancepageState();
}

class _PerformancepageState extends State<Performancepage> {
  bool trackingstatus = true;
  var completed = "---";
  final HomeController homecontroller = Get.find();
  String? day;
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 2), (timer) {
      Geolocator.isLocationServiceEnabled()
          .then((value) => homecontroller.islocationenabled.value = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    homecontroller.todaystepgoal.value = homecontroller.getTodayStepGoal();
    homecontroller.getpercantage();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FadeInLeft(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: height * .05,
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryDark.withOpacity(.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FadeInDown(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Today",
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                            style: AppTextStyles.performancepagetextstyle2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FadeInLeft(
                  child: Container(
                    padding:
                        EdgeInsets.all(20 * ScaleSize.textScaleFactor(context)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorPrimaryDark.withOpacity(.5),
                    ),
                    child: FadeInDown(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularPercentIndicator(
                            animation: true,
                            animationDuration: 90,
                            radius: 115 * ScaleSize.textScaleFactor(context),
                            lineWidth: 8 * ScaleSize.textScaleFactor(context),
                            percent: 0.80,
                            startAngle: 216,
                            progressColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          CircularPercentIndicator(
                            animation: true,
                            animationDuration: 90,
                            radius: 115 * ScaleSize.textScaleFactor(context),
                            lineWidth: 8 * ScaleSize.textScaleFactor(context),
                            percent: homecontroller.percentageAchieved.value >=
                                    100
                                ? 0.80
                                : homecontroller.percentageAchieved.value / 122,
                            startAngle: 216,
                            progressColor: Colors.green,
                            backgroundColor: Colors.transparent,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          Text(
                            "2110\n${'steps'.tr}",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.appslogantextstyle,
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "${homecontroller.percentageAchieved.value != 0.0 ? homecontroller.percentageAchieved.value.toStringAsFixed(0) : 0.0}%\n${'completed'.tr}",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.performancepagetextstyle2,
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                              ),
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     // SizedBox(
                          //     //   height: height * .23,
                          //     // ),
                          //     Align(
                          //       alignment: Alignment.bottomCenter,
                          //       child: Text(
                          //         "${homecontroller.percentageAchieved.value != 0.0 ? homecontroller.percentageAchieved.value.toStringAsFixed(0) : 0.0}%\n${'completed'.tr}",
                          //         textAlign: TextAlign.center,
                          //         style:
                          //             AppTextStyles.performancepagetextstyle2,
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                homecontroller.pedestrianStatusStream == null
                    ? const SizedBox.shrink()
                    : FadeInLeft(
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder<PedestrianStatus>(
                                stream: homecontroller.pedestrianStatusStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<PedestrianStatus> snapshot) {
                                  if (snapshot.hasData) {
                                    final data = snapshot.data!;
                                    Widget icon = getIconBasedOnStatus(
                                        data.status, height);
                                    String statusText =
                                        getStatusText(data.status);

                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        icon,
                                        Text(statusText,
                                            textScaleFactor:
                                                ScaleSize.textScaleFactor(
                                                    context),
                                            style: AppTextStyles
                                                .historypagetextstyle),
                                      ],
                                    );
                                  }

                                  return Column(
                                    children: [
                                      getIconBasedOnStatus("stopped", height),
                                      Text(getStatusText("stopped"),
                                          textScaleFactor:
                                              ScaleSize.textScaleFactor(
                                                  context),
                                          style: AppTextStyles
                                              .historypagetextstyle),
                                    ],
                                  );
                                },
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: height * .05,
                                    width: height * .05,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: homecontroller
                                                  .islocationenabled.value ==
                                              true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        homecontroller
                                                    .islocationenabled.value ==
                                                true
                                            ? Icons.location_on
                                            : Icons.location_off,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      onPressed: () async {
                                        if (!homecontroller
                                            .islocationenabled.value) {
                                          Get.closeAllSnackbars();
                                          Get.snackbar(
                                              "Pacer", "Please Turn On Gps",
                                              backgroundColor: Colors.red,
                                              colorText: AppColors.white);
                                          Future.delayed(
                                              const Duration(seconds: 2),
                                              () async {
                                            await Geolocator
                                                .openLocationSettings();
                                            Geolocator
                                                    .isLocationServiceEnabled()
                                                .then((value) => homecontroller
                                                    .islocationenabled
                                                    .value = value);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Text(
                                    'tracking'.tr,
                                    textScaleFactor:
                                        ScaleSize.textScaleFactor(context),
                                    style: AppTextStyles.historypagetextstyle,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                const Spacer(),
                FadeInLeft(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("sensorInfoDetector".tr,
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                            style: AppTextStyles.performancepagetextstyle1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FadeInLeft(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    height: height * .07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.colorPrimaryDark.withOpacity(0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("1.50 km",
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                "distance".tr,
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("84.4 kcal",
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                "calories".tr,
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                        FadeInDown(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("08:23 hrs",
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style:
                                      AppTextStyles.performancepagetextstyle1),
                              Text(
                                'duration'.tr,
                                textScaleFactor:
                                    ScaleSize.textScaleFactor(context),
                                style: AppTextStyles.performancepagetextstyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
