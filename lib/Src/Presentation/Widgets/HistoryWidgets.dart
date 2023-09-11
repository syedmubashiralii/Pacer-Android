import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../Domain/Controllers/HistoryController.dart';
import '../../Domain/Controllers/HomeController.dart';
import '../../Domain/DataHandlers/StepsDatahandler.dart';
import '../../Domain/Model/ChartDataModel.dart';
import '../../Domain/Model/DayDataModel.dart';
import '../../Utils/Constants.dart';
import '../../Utils/Functions.dart';

class HistoryGraph extends StatelessWidget {
  const HistoryGraph({
    super.key,
    required this.historycontroller,
    required TooltipBehavior tooltip,
  }) : _tooltip = tooltip;

  final HistoryController historycontroller;
  final TooltipBehavior _tooltip;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColors.colorPrimaryDark.withOpacity(.5),
        ),
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
              maximum: historycontroller.maxheight.value,
              // interval: 10,
              minorGridLines: const MinorGridLines(width: 0),
              labelStyle: AppTextStyles.goalpagetextstyle1,
            ),
            tooltipBehavior: _tooltip,
            series: <ChartSeries<ChartDataModel, String>>[
              ColumnSeries<ChartDataModel, String>(
                  width: .3,
                  // spacing: 1.5,
                  dataSource: historycontroller.datax.value,
                  xValueMapper: (ChartDataModel data, _) => data.x,
                  yValueMapper: (ChartDataModel data, _) => data.y,
                  name: 'Progress',
                  color: Colors.green),
              ColumnSeries<ChartDataModel, String>(
                  width: .3,
                  // spacing: 1.5,
                  dataSource: historycontroller.datay.value,
                  xValueMapper: (ChartDataModel data, _) => data.x,
                  yValueMapper: (ChartDataModel data, _) => data.y,
                  name: "Goal",
                  color: Colors.pink[300]),
            ]),
      );
    });
  }
}

Widget progressGoalWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: AppColors.colorPrimaryDark.withOpacity(.5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 8,
              backgroundColor: Colors.green,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "progress".tr,
              style: AppTextStyles.historypagetextstyle,
              textScaleFactor: ScaleSize.textScaleFactor(context),
            )
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: Colors.pink[300],
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "goal".tr,
              style: AppTextStyles.historypagetextstyle,
              textScaleFactor: ScaleSize.textScaleFactor(context),
            )
          ],
        ),
      ],
    ),
  );
}

class weeklyMonthlyYearlyWidget extends StatefulWidget {
  final double height;

  const weeklyMonthlyYearlyWidget({super.key, required this.height});

  @override
  State<weeklyMonthlyYearlyWidget> createState() =>
      _weeklyMonthlyYearlyWidgetState();
}

class _weeklyMonthlyYearlyWidgetState extends State<weeklyMonthlyYearlyWidget> {
  HomeController homeController = Get.find();
  HistoryController historycontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return IndexedStack(
        index: historycontroller.historytypeindex.value,
        children: [
          const SizedBox.shrink(),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: widget.height * .065,
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimaryDark.withOpacity(.5),
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (historycontroller.selectedweekindex.value !=
                                0) {
                              historycontroller.chnageselectedweekindex(
                                  historycontroller.selectedweekindex.value -
                                      1);
                              historycontroller.weekstartdate.value =
                                  homeController
                                      .stepDataList[currentDate.month - 1]
                                      .weeklySteps[historycontroller
                                          .selectedweekindex.value]
                                      .weekStartDate;
                              historycontroller.weekenddate.value =
                                  homeController
                                      .stepDataList[currentDate.month - 1]
                                      .weeklySteps[historycontroller
                                          .selectedweekindex.value]
                                      .weekEndDate;
                              historycontroller.currentweekdata(
                                  homeController.stepDataList,
                                  historycontroller.selectedweekindex.value);
                              // setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color:
                                historycontroller.selectedweekindex.value == 0
                                    ? Colors.green.withOpacity(.6)
                                    : Colors.green,
                          ),
                        ),
                        FadeInDown(
                          child: Text(
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                            "${historycontroller.weekstartdate} - ${historycontroller.weekenddate}",
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (historycontroller.selectedweekindex.value !=
                                historycontroller.currentweekindex.value) {
                              historycontroller.chnageselectedweekindex(
                                  historycontroller.selectedweekindex.value +
                                      1);

                              historycontroller.weekstartdate.value =
                                  homeController
                                      .stepDataList[currentDate.month - 1]
                                      .weeklySteps[historycontroller
                                          .selectedweekindex.value]
                                      .weekStartDate;
                              historycontroller.weekenddate.value =
                                  homeController
                                      .stepDataList[currentDate.month - 1]
                                      .weeklySteps[historycontroller
                                          .selectedweekindex.value]
                                      .weekEndDate;

                              historycontroller.currentweekdata(
                                  homeController.stepDataList,
                                  historycontroller.selectedweekindex.value);
                              // setState(() {});
                            }
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: historycontroller.selectedweekindex.value ==
                                    historycontroller.currentweekindex.value
                                ? Colors.green.withOpacity(.6)
                                : Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: widget.height * .065,
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimaryDark.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (historycontroller.selectedmonthindex.value !=
                                    0 &&
                                historycontroller.selectedmonthindex.value <
                                    12) {
                              historycontroller.changeselectedmonthindex(
                                  historycontroller.selectedmonthindex.value -
                                      1);
                              historycontroller.currentmonth.value =
                                  DateFormat('MMMM').format(DateTime(
                                      currentDate.year,
                                      historycontroller
                                              .selectedmonthindex.value +
                                          1));
                              historycontroller.montlyhistorydata(
                                  homeController.stepDataList,
                                  historycontroller.selectedmonthindex.value);
                            }
                            // setState(() {});
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color:
                                historycontroller.selectedmonthindex.value == 0
                                    ? Colors.green.withOpacity(.6)
                                    : Colors.green,
                          ),
                        ),
                        Text(
                          historycontroller.currentmonth.value,
                          style: const TextStyle(
                              color: Colors.green, fontSize: 18),
                        ),
                        InkWell(
                          onTap: () {
                            if (historycontroller.selectedmonthindex.value !=
                                historycontroller.currentmonthindex.value) {
                              historycontroller.changeselectedmonthindex(
                                  historycontroller.selectedmonthindex.value +
                                      1);
                              historycontroller.currentmonth.value =
                                  DateFormat('MMMM').format(DateTime(
                                      currentDate.year,
                                      historycontroller
                                              .selectedmonthindex.value +
                                          1));
                              historycontroller.montlyhistorydata(
                                  homeController.stepDataList,
                                  historycontroller.selectedmonthindex.value);
                            }
                            // setState(() {});
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: historycontroller.selectedmonthindex.value ==
                                    historycontroller.currentmonthindex.value
                                ? Colors.green.withOpacity(.6)
                                : Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: widget.height * .065,
                  decoration: BoxDecoration(
                      color: AppColors.colorPrimaryDark.withOpacity(.5),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (historycontroller.currentyear.value ==
                                    DateTime.now().year.toString() ||
                                historycontroller.currentyear.value ==
                                    DateTime.now().year.toString()) {
                              historycontroller.changeyear((int.parse(
                                          historycontroller.currentyear.value) -
                                      1)
                                  .toString());

                              List<MonthlyStepData> data =
                                  await StepDataManager().getSpecificMonthData(
                                      historycontroller.currentyear.value);
                              if (data.isEmpty) {
                                dlog("Previous Data", "No Data");
                                historycontroller.changeyear((int.parse(
                                            historycontroller
                                                .currentyear.value) +
                                        1)
                                    .toString());
                              } else {
                                historycontroller
                                    .calculateYearlyAggregates(data);
                              }
                            }
                          },
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.green),
                        ),
                        Text(historycontroller.currentyear.value,
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                            style: AppTextStyles.languagetextstyle),
                        InkWell(
                          onTap: () async {
                            if (historycontroller.currentyear.value !=
                                DateTime.now().year.toString()) {
                              historycontroller.changeyear((int.parse(
                                          historycontroller.currentyear.value) +
                                      1)
                                  .toString());

                              List<MonthlyStepData> data =
                                  await StepDataManager().getSpecificMonthData(
                                      historycontroller.currentyear.value);
                              if (data.isEmpty) {
                                dlog("next Data", "No Data");
                                historycontroller.changeyear((int.parse(
                                            historycontroller
                                                .currentyear.value) +
                                        1)
                                    .toString());
                              } else {
                                historycontroller
                                    .calculateYearlyAggregates(data);
                              }
                            }
                          },
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: historycontroller.currentyear.value ==
                                    DateTime.now().year.toString()
                                ? Colors.green.withOpacity(.6)
                                : Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      );
    });
  }
}

class weeklyMonthlyYearlyFilterWidget extends StatefulWidget {
  final double height;
  final double width;
  const weeklyMonthlyYearlyFilterWidget(
      {super.key, required this.height, required this.width});

  @override
  State<weeklyMonthlyYearlyFilterWidget> createState() =>
      _weeklyMonthlyYearlyFilterWidgetState();
}

class _weeklyMonthlyYearlyFilterWidgetState
    extends State<weeklyMonthlyYearlyFilterWidget> {
  HomeController homeController = Get.find();
  HistoryController historycontroller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < historycontroller.historytypelist.length; i++) ...[
          InkWell(
            onTap: () {
              if (i == 0) {
                homeController.swipe(2);
              } else {
                if (i == 1) {
                  historycontroller.currentweekdata(homeController.stepDataList,
                      historycontroller.selectedweekindex.value);
                }
                if (i == 2) {
                  historycontroller.montlyhistorydata(
                      homeController.stepDataList,
                      historycontroller.selectedmonthindex.value);
                }
                if (i == 3) {
                  historycontroller.yearlyHistoryData();
                  historycontroller
                      .calculateYearlyAggregates(homeController.stepDataList);
                }
                historycontroller.changehistorytype(i);
                // setState(() {});
              }
            },
            child: FadeInDown(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.colorPrimaryDark.withOpacity(.5),
                ),
                height: widget.height * .04,
                width: widget.width * .22,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Text(
                      historycontroller.historytypelist[i],
                      textScaleFactor: ScaleSize.textScaleFactor(context),
                      style: TextStyle(
                          color: i == historycontroller.historytypeindex.value
                              ? Colors.green
                              : Colors.white,
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]
      ],
    );
  }
}
