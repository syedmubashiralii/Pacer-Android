import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Domain/Controllers/GoalController.dart';
import 'package:pacer/Src/Domain/Controllers/HomeController.dart';
import 'package:pacer/Src/Domain/Model/ChartDataModel.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Utils/Functions.dart';

class Goalpage extends StatefulWidget {
  const Goalpage({super.key});

  @override
  State<Goalpage> createState() => _GoalpageState();
}

class _GoalpageState extends State<Goalpage> {
  int currentweek = 0;

  final GoalController goalcont = Get.put(GoalController());
  final HomeController homeController = Get.find();
  @override
  void initState() {
    super.initState();
    goalcont.getcurrentweekgoal(homeController.stepDataList);
    goalcont.change(DateTime.now().weekday - 1);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          backgroundColor: AppColors.backgroundcolor,
          color: Colors.green,
          onRefresh: () async {
            goalcont.maxheight.value = 240;
            await goalcont.getcurrentweekgoal(homeController.stepDataList);
            homeController.getpercantage();
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: ListView(
                children: [
                  Obx(() {
                    return FadeInLeft(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < goalcont.days.length; i++) ...[
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                goalcont.change(i);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 2000),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor:
                                      goalcont.selectedIndex.value == i
                                          ? Colors.green
                                          : AppColors.colorPrimaryDark
                                              .withOpacity(.5),
                                  child: Text(goalcont.days[i],
                                      textScaleFactor:
                                          ScaleSize.textScaleFactor(context),
                                      style: AppTextStyles.waterpagetextstyle1),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return FadeInLeft(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: height * .06,
                            width: width * .65,
                            padding: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                                color:
                                    AppColors.colorPrimaryDark.withOpacity(.5),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12))),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("goal_cals".tr,
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style: AppTextStyles.waterpagetextstyle1),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(left: 6),
                                height: height * .06,
                                width: width * .65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.colorPrimaryDark
                                        .withOpacity(.5),
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(12))),
                                child: TextField(
                                  cursorColor: AppColors.white,
                                  keyboardAppearance: Brightness.dark,
                                  style: AppTextStyles.goalpagetextstyle1,
                                  controller: goalcont.controllers[
                                      goalcont.selectedIndex.value][0],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      goalcont
                                              .controllers[goalcont
                                                  .selectedIndex.value][1]
                                              .text =
                                          (double.parse(value) * 25)
                                              .toStringAsFixed(0);
                                      goalcont
                                              .controllers[goalcont
                                                  .selectedIndex.value][2]
                                              .text =
                                          (double.parse(value) / 57)
                                              .toStringAsFixed(2);
                                    } else {
                                      goalcont
                                          .controllers[
                                              goalcont.selectedIndex.value][1]
                                          .text = "0.0";
                                      goalcont
                                          .controllers[
                                              goalcont.selectedIndex.value][2]
                                          .text = "0.0";
                                    }
                                  },
                                  onSubmitted: (value) async {
                                    await homeController.saveGoalData();
                                  },
                                )),
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 2,
                  ),
                  Obx(() {
                    return FadeInLeft(
                      child: Row(
                        children: [
                          Container(
                            height: height * .06,
                            width: width * .65,
                            padding: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              color: AppColors.colorPrimaryDark.withOpacity(.5),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("steps".tr,
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style: AppTextStyles.waterpagetextstyle1),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(left: 6),
                                height: height * .06,
                                width: width * .65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.colorPrimaryDark
                                      .withOpacity(.5),
                                ),
                                child: TextField(
                                  cursorColor: AppColors.white,
                                  style: AppTextStyles.goalpagetextstyle1,
                                  controller: goalcont.controllers[
                                      goalcont.selectedIndex.value][1],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelStyle:
                                          AppTextStyles.waterpagetextstyle1),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      goalcont
                                              .controllers[goalcont
                                                  .selectedIndex.value][0]
                                              .text =
                                          (double.parse(value) / 25)
                                              .toStringAsFixed(2);
                                      goalcont
                                              .controllers[goalcont
                                                  .selectedIndex.value][2]
                                              .text =
                                          (double.parse(value) / 1400)
                                              .toStringAsFixed(2);
                                    } else {
                                      goalcont
                                          .controllers[
                                              goalcont.selectedIndex.value][0]
                                          .text = "0.0";
                                      goalcont
                                          .controllers[
                                              goalcont.selectedIndex.value][2]
                                          .text = "0.0";
                                    }
                                  },
                                  onSubmitted: (value) async {
                                    await homeController.saveGoalData1();
                                  },
                                )),
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 2,
                  ),
                  Obx(() {
                    return FadeInLeft(
                      child: Row(
                        children: [
                          Container(
                            height: height * .06,
                            width: width * .65,
                            padding: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                                color:
                                    AppColors.colorPrimaryDark.withOpacity(.5),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12))),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("goal_distance".tr,
                                  textScaleFactor:
                                      ScaleSize.textScaleFactor(context),
                                  style: AppTextStyles.waterpagetextstyle1),
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.only(left: 6),
                                height: height * .06,
                                width: width * .65,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.colorPrimaryDark
                                        .withOpacity(.5),
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(12))),
                                child: TextField(
                                  cursorColor: AppColors.white,
                                  style: AppTextStyles.waterpagetextstyle1,
                                  controller: goalcont.controllers[
                                      goalcont.selectedIndex.value][2],
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      labelStyle:
                                          AppTextStyles.waterpagetextstyle1),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      goalcont
                                              .controllers[goalcont
                                                  .selectedIndex.value][1]
                                              .text =
                                          (double.parse(value) * 1428.54)
                                              .toStringAsFixed(0);
                                      goalcont
                                              .controllers[goalcont
                                                  .selectedIndex.value][0]
                                              .text =
                                          (double.parse(value) * 57.15)
                                              .toStringAsFixed(2);
                                    } else {
                                      goalcont
                                          .controllers[
                                              goalcont.selectedIndex.value][1]
                                          .text = "0.0";
                                      goalcont
                                          .controllers[
                                              goalcont.selectedIndex.value][0]
                                          .text = "0.0";
                                    }
                                  },
                                  onSubmitted: (value) async {
                                    await homeController.saveGoalData();
                                  },
                                )),
                          )
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(() {
                    return FadeInLeft(
                      child: Container(
                        height: height * .35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.colorPrimaryDark.withOpacity(.5)),
                        padding: const EdgeInsets.all(4),
                        child: SfCartesianChart(
                            plotAreaBorderWidth: 0,
                            zoomPanBehavior: ZoomPanBehavior(
                                enableSelectionZooming: true,
                                selectionRectBorderColor: Colors.red,
                                selectionRectBorderWidth: 1,
                                selectionRectColor: Colors.grey),
                            primaryXAxis: CategoryAxis(
                              labelStyle: AppTextStyles.goalpagetextstyle1,
                              borderColor: Colors.transparent,
                              majorGridLines: const MajorGridLines(
                                  width: 0), // Remove the vertical grid lines
                              minorGridLines: const MinorGridLines(width: 0),
                            ),
                            primaryYAxis: NumericAxis(
                              majorGridLines: const MajorGridLines(
                                  width:
                                      0), // Remove the horizontal grid lines // Remove the vertical grid lines
                              minimum: 0,
                              maximum: goalcont.maxheight.value,
                              // interval: 10,
                              minorGridLines: const MinorGridLines(width: 0),
                              labelStyle: AppTextStyles.goalpagetextstyle1,
                            ),
                            tooltipBehavior: goalcont.tooltip,
                            series: <ChartSeries<ChartDataModel, String>>[
                              ColumnSeries<ChartDataModel, String>(
                                  dataSource: goalcont.goaldatalist.value,
                                  xValueMapper: (ChartDataModel data, _) =>
                                      data.x,
                                  yValueMapper: (ChartDataModel data, _) =>
                                      data.y,
                                  name: "Goal",
                                  color: Colors.green)
                            ]),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ));
  }
}
