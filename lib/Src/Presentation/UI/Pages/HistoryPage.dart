import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pacer/Src/Domain/Controllers/HistoryController.dart';
import 'package:pacer/Src/Domain/Controllers/HomeController.dart';
import 'package:pacer/Src/Utils/Constants.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Utils/Functions.dart';
import '../../Widgets/HistoryWidgets.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late TooltipBehavior _tooltip;
  HistoryController historycontroller = Get.put(HistoryController());
  HomeController homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    if (homeController.stepDataList.isNotEmpty) {
      /////////////
      //============weekly====================
      //======================================
      historycontroller.currentweekindex.value = currentWeekIndex(
          homeController.stepDataList[currentDate.month - 1].weeklySteps,
          currentdate);

      dlog("historycontroller.currentweekindex.value",
          historycontroller.currentweekindex.value);
      historycontroller.selectedweekindex.value =
          historycontroller.currentweekindex.value;
      historycontroller.weekstartdate.value = homeController
          .stepDataList[currentDate.month - 1]
          .weeklySteps[historycontroller.currentweekindex.value]
          .weekStartDate;
      historycontroller.weekenddate.value = homeController
          .stepDataList[currentDate.month - 1]
          .weeklySteps[historycontroller.currentweekindex.value]
          .weekEndDate;

      if (historycontroller.historytypeindex.value == 1) {
        historycontroller.currentweekdata(homeController.stepDataList,
            historycontroller.currentweekindex.value);
      }
      /////////////
      //============monthly====================
      //======================================
      historycontroller.currentmonthindex = (currentDate.month - 1).obs;
      historycontroller.selectedmonthindex.value =
          historycontroller.currentmonthindex.value;
      historycontroller.currentmonth.value = DateFormat('MMMM')
          .format(DateTime(currentDate.year, currentDate.month));
      if (historycontroller.historytypeindex.value == 2) {
        historycontroller.montlyhistorydata(homeController.stepDataList,
            historycontroller.selectedmonthindex.value);
      }
      /////////////
      //============yearly====================
      //======================================
      historycontroller.currentyear.value = DateTime.now().year.toString();
      if (historycontroller.historytypeindex.value == 3) {
        historycontroller.yearlyHistoryData();
        historycontroller
            .calculateYearlyAggregates(homeController.stepDataList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              ///==========================================================
              ///==========weeklyMonthlyYearlyWidget==============================
              ///==========================================================
              FadeInLeft(
                child: weeklyMonthlyYearlyWidget(
                  height: height,
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              ///==========================================================
              ///==========historygraphwidget==============================
              ///==========================================================
              Expanded(
                child: FadeInDown(
                  child: HistoryGraph(
                      historycontroller: historycontroller, tooltip: _tooltip),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              ///==========================================================
              ///==========progressGoalWidget==============================
              ///==========================================================
              FadeInLeft(child: progressGoalWidget(context)),
              const SizedBox(
                height: 10,
              ),
              FadeInLeft(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int i = 0;
                        i < historycontroller.icons.length;
                        i++) ...[
                      InkWell(
                        onTap: () {
                          historycontroller.changehistoryicon(i);
                          if (historycontroller.historytypeindex.value == 1) {
                            historycontroller.currentweekdata(
                                homeController.stepDataList,
                                historycontroller.selectedweekindex.value);
                          }
                          if (historycontroller.historytypeindex.value == 2) {
                            historycontroller.montlyhistorydata(
                                homeController.stepDataList,
                                historycontroller.selectedmonthindex.value);
                          }
                          if (historycontroller.historytypeindex.value == 3) {
                            historycontroller.calculateYearlyAggregates(
                                homeController.stepDataList);
                          }
                        },
                        child: CircleAvatar(
                          radius: 20 * ScaleSize.textScaleFactor(context),
                          backgroundColor:
                              AppColors.colorPrimaryDark.withOpacity(.5),
                          child: CircleAvatar(
                            backgroundColor:
                                AppColors.colorPrimaryDark.withOpacity(.5),
                            radius: 18,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FadeInDown(
                                child: Image.asset(
                                  historycontroller.icons[i],
                                  color: historycontroller.iconindex.value == i
                                      ? Colors.green
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FadeInLeft(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.colorPrimaryDark.withOpacity(.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInDown(
                            child: Text(
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                              '${'totalcalsburn'.tr}:\t\t\t ${historycontroller.caloriesburnt.value.toString()}',
                              style: AppTextStyles.historypagetextstyle,
                            ),
                          ),
                          FadeInDown(
                            child: Text(
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                              '${'totalstepstaken'.tr}:\t\t\t ${historycontroller.stepstaken.value.toString()}',
                              style: AppTextStyles.historypagetextstyle,
                            ),
                          ),
                          FadeInDown(
                            child: Text(
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                              '${'totaldistancecovered'.tr}:\t\t\t ${historycontroller.distancecovered.value.toString()}',
                              style: AppTextStyles.historypagetextstyle,
                            ),
                          ),
                          FadeInDown(
                            child: Text(
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                              '${'avgcalburned'.tr}:\t\t\t ${historycontroller.averagecaloriesburnt.value.toString()}',
                              style: AppTextStyles.historypagetextstyle,
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              ///==========================================================
              ///==========weeklyMonthlyYearlyFilterWidget==============================
              ///==========================================================
              FadeInLeft(
                  child: weeklyMonthlyYearlyFilterWidget(
                      height: height, width: width)),
              const SizedBox(
                height: 10,
              ),
            ]),
          );
        }));
  }
}
