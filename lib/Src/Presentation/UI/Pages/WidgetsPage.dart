import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pacer/Src/Domain/Controllers/WidgetsController.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/Functions.dart';
import '../../Widgets/WeatherWidget.dart';

class WidgetsPage extends StatefulWidget {
  const WidgetsPage({super.key});

  @override
  State<WidgetsPage> createState() => _WidgetsPageState();
}

class _WidgetsPageState extends State<WidgetsPage> {
  WidgetsController widgetsController = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeInLeft(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.colorPrimaryDark.withOpacity(.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: height * .1,
                    child: const WeatherWidget(),
                  ),
                ),
                const Spacer(),
                widgetsController.address.value == ""
                    ? const SizedBox.shrink()
                    : FadeInLeft(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.colorPrimaryDark.withOpacity(.5),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Center(
                            child: Text(
                              textScaleFactor:
                                  ScaleSize.textScaleFactor(context),
                              widgetsController.address.value,
                              style: AppTextStyles.historypagetextstyle,
                            ),
                          ),
                        ),
                      ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FadeInLeft(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.colorPrimaryDark.withOpacity(.5)),
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: height * .2,
                              child: const CompassWidget(),
                            ),
                          ),
                          Text(
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                            'direction'.tr,
                            style: AppTextStyles.historypagetextstyle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FadeInLeft(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.colorPrimaryDark.withOpacity(.5)),
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              width: height * .19,
                              height: height * .19,
                              child: SpeedometerWidget(
                                  speed: widgetsController.speed.value),
                            ),
                          ),
                          Text(
                            textScaleFactor: ScaleSize.textScaleFactor(context),
                            'speed'.tr,
                            style: AppTextStyles.historypagetextstyle,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
